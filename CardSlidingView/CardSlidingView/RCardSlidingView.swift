//
//  RCardSlidingView.swift
//  RCardView
//
//  Created by nmi on 2019/2/14.
//  Copyright © 2019 nmi. All rights reserved.
//

import UIKit
import SDWebImage
public struct RCardSliderData
{
    let title:String
    let des:String
    let url:String
    public init(title:String, des:String, url:String){
        self.title = title
        self.des = des
        self.url = url
    }
}

public enum CardSlidingTextAlignment {
    case Top
    case Bottom
}

public struct RCardSliderConfig {
    let indicator_gap:Int
    let indicator_botmargin:Int
    let indicator_rlmargin:Int
    let indicator_color:UIColor
    let indicator_titlecolor:UIColor
    let indicator_descolor:UIColor
    let indicator_cornerradius:CGFloat
    let indicator_height:Int
    let indicator_slideduration:Double
    let indicator_resetdelay:Double
    let indicator_interruptable:Bool
    let indicator_placeholder:UIImage?
    let indicator_txtalightment:CardSlidingTextAlignment
    let indicator_titlehighlitcolor:UIColor
    let indicator_deshighlitcolor:UIColor
    public init(gap:Int, botmargin:Int, rlmargin:Int, color:UIColor, titlecolor:UIColor, descolor:UIColor,
                cornerradius:CGFloat, height:Int, slideduration:Double, resetdelay:Double, interruptable:Bool,
                placeholder:UIImage?, textalignment:CardSlidingTextAlignment, titlehighlitcolor:UIColor, deshighlitcolor:UIColor) {
        self.indicator_gap = gap
        self.indicator_botmargin = botmargin
        self.indicator_rlmargin = rlmargin
        self.indicator_color = color
        self.indicator_titlecolor = titlecolor
        self.indicator_descolor = descolor
        self.indicator_cornerradius = cornerradius
        self.indicator_height = height
        self.indicator_slideduration = slideduration
        self.indicator_resetdelay = resetdelay
        self.indicator_interruptable = interruptable
        self.indicator_placeholder = placeholder
        self.indicator_txtalightment = textalignment
        self.indicator_titlehighlitcolor = titlehighlitcolor
        self.indicator_deshighlitcolor = deshighlitcolor
    }
}

final public class RCardSlidingView: UIViewController {
    
    public static let defaultConfig:RCardSliderConfig = RCardSliderConfig(gap: 6, botmargin: 20, rlmargin: 20, color: UIColor.white,
                                                             titlecolor:UIColor.white, descolor:UIColor.white, cornerradius: 2,
                                                             height: 4, slideduration: 4, resetdelay: 1, interruptable: true,
                                                             placeholder:nil, textalignment: .Top, titlehighlitcolor: UIColor.clear, deshighlitcolor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5))
    private var src:[RCardSliderData]!
    private var config:RCardSliderConfig!
    private var layoutscl:Bool = false
    private var layoutbeingreset:Bool = false
    private var sclView:UIScrollView!
    private var tabList:[UIView] = []
    private var tabIndicatorList:[UIView] = []
    private var tabWidth:Int = 0
    private var displayLink:CADisplayLink?
    private var displayTime:Double = 0
    private var displayCount:Int = 0
    private var displayDuration:Double = 1.0
    private var displayPreView:UIView?
    private var interrupted:Bool = false
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    public init(_ src: [RCardSliderData], _ config:RCardSliderConfig) {
        super.init(nibName: nil, bundle: nil)
        
        // Do something here
        self.src = src
        self.config = config
    }
    
    deinit {
        print("deinit")
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displayLink?.invalidate()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayLink?.invalidate()
        displayDuration = self.config.indicator_slideduration
        displayLink = CADisplayLink.init(target:self, selector:#selector(self.update))
        displayLink!.preferredFramesPerSecond = 30
        displayLink!.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        displayTime = CACurrentMediaTime()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // ---- Start ----
        if (layoutscl == false && self.src.count > 0) {
            
            layoutscl = true
            self.sclView = UIScrollView.init()
            self.view.addSubview(self.sclView)
            self.sclView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint(item: self.sclView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute:.leading, multiplier: 1.0, constant: 10.0).isActive = true
            NSLayoutConstraint(item: self.sclView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute:.trailing, multiplier: 1.0, constant: -10.0).isActive = true
            NSLayoutConstraint(item: self.sclView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 10.0).isActive = true
            NSLayoutConstraint(item: self.sclView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -10.0).isActive = true
            
            let duview:UIView = UIView.init()
            duview.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.size.width-20), height: Int(self.view.frame.size.height-20))
            duview.backgroundColor = UIColor.red
            sclView.addSubview(duview)
            sclView.contentSize = CGRect(x: 0, y: 0, width: Int(self.src.count) * Int(duview.frame.size.width), height: Int(duview.frame.size.height)).size
            sclView.delegate = self
            sclView.showsHorizontalScrollIndicator = false
            sclView.decelerationRate = .fast
            sclView.layer.borderWidth = 1
            
            // Inner view
            for i in 1...Int(self.src.count){
                let vv:UIView = UIView.init()
                vv.backgroundColor = UIColor.white
                vv.frame = CGRect(x: (i-1)*Int(duview.frame.size.width), y: 0, width: Int(duview.frame.size.width), height: Int(duview.frame.size.height))
                
                let rect:CGRect = CGRect(x: 0, y: 0, width: Int(duview.frame.size.width), height: Int(duview.frame.size.height))
                let url:URL = URL(string:self.src[i-1].url)!
                let img:UIImageView = UIImageView.init(frame: rect)
                img.sd_imageTransition = .fade
                img.clipsToBounds = true
                img.contentMode = .scaleAspectFill

                let bundle:Bundle = Bundle(for: RCardSlidingView.self)
                let placeholder:UIImage? = self.config.indicator_placeholder ?? UIImage(named: "placeholder", in: bundle, compatibleWith: nil)
                img.sd_setImage(with: url, placeholderImage:placeholder, options: .forceTransition, progress: nil) { (image, error, type, url) in
                    if (error == nil && (image != nil)){
                        
                    }
                }
                vv.addSubview(img)
                
                //Title & Description
                var txtrect:CGRect = CGRect(x: 0, y: 0, width: Int(duview.frame.size.width), height: Int(duview.frame.size.height))
                txtrect = txtrect.insetBy(dx: 17, dy: 0)
                let txt:UILabel = UILabel.init(frame:txtrect)
                txt.font = UIFont(name: txt.font.fontName, size: 14)
                txt.text = self.src[i-1].title
                txt.numberOfLines = 2
                txt.layer.borderWidth = 0
                txt.textAlignment = .left
                txt.textColor = self.config.indicator_titlecolor
                txt.sizeToFit()
                
                vv.addSubview(txt)
                
                // Description
                var desrect:CGRect = CGRect(x: 0, y: 0, width: Int(duview.frame.size.width), height: Int(duview.frame.size.height))
                desrect = desrect.insetBy(dx: 17, dy: 0)
                let des:UILabel = UILabel.init(frame:desrect)
                des.text = self.src[i-1].des
                des.numberOfLines = 2
                des.layer.borderWidth = 0
                des.textAlignment = .left
                des.textColor = self.config.indicator_descolor
                des.sizeToFit()
                vv.addSubview(des)
                
                let txtgap:Int = 5
                var txtrectafter:CGRect = CGRect.zero
                var desrectafter:CGRect = CGRect.zero
                
                if (self.config.indicator_txtalightment == .Top) {
                    txtrectafter = CGRect(x: Int(txtrect.origin.x), y: txtgap*2,
                                                     width: Int(round(txt.frame.size.width)), height: Int(round(txt.frame.size.height)) )
                    txt.frame = txtrectafter
                    
                    desrectafter = CGRect(x: Int(desrect.origin.x), y: Int(txtrectafter.origin.y + txtrectafter.size.height) + txtgap,
                                              width: Int(round(des.frame.size.width)), height: Int(round(des.frame.size.height)))
                    des.frame = desrectafter
                }
                else if (self.config.indicator_txtalightment == .Bottom){
                    desrectafter = CGRect(x: Int(desrect.origin.x), y: Int(duview.frame.size.height-des.frame.size.height) - txtgap*6,
                                                     width: Int(round(des.frame.size.width)), height: Int(round(des.frame.size.height)))
                    des.frame = desrectafter
                    
                    txtrectafter = CGRect(x: Int(txtrect.origin.x), y: Int(desrectafter.origin.y-txt.frame.size.height) - txtgap,
                                                     width: Int(round(txt.frame.size.width)), height: Int(round(txt.frame.size.height)))
                    txt.frame = txtrectafter
                }
                
                // Highlit
                let txtbackhighlitrect:CGRect = CGRect(x:10, y:Int(txtrectafter.origin.y), width:Int(duview.frame.size.width-20), height:Int(txtrectafter.size.height))
                let txtbackv:UIView = UIView.init(frame: txtbackhighlitrect)
                txtbackv.backgroundColor = self.config.indicator_titlehighlitcolor
                vv.addSubview(txtbackv)
                vv.bringSubviewToFront(txt)
                
                let desbackhighlitrect:CGRect = CGRect(x:10, y:Int(desrectafter.origin.y), width:Int(duview.frame.size.width-20), height:Int(desrectafter.size.height))
                let desbackv:UIView = UIView.init(frame: desbackhighlitrect)
                desbackv.backgroundColor = self.config.indicator_deshighlitcolor
                vv.addSubview(desbackv)
                vv.bringSubviewToFront(des)

                duview.addSubview(vv)
            }
            
            // Tab Background
            let ox:Int = self.config.indicator_rlmargin
            var w:Int = Int(self.view.frame.size.width) - 2 * self.config.indicator_rlmargin - (self.src.count-1) * self.config.indicator_gap
            w = w / self.src.count
            tabWidth = w
            
            for i in 1...Int(self.src.count){
                let vv:UIView = UIView.init()
                vv.frame = CGRect(x: ox + Int((i-1) * (w + self.config.indicator_gap)),
                                  y: Int(Int(self.view.frame.size.height) - self.config.indicator_height - self.config.indicator_botmargin),
                                  width: w,
                                  height: self.config.indicator_height)
                vv.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
                vv.layer.cornerRadius = self.config.indicator_cornerradius
                vv.layer.borderWidth = 0
                self.view.addSubview(vv)
                tabList.append(vv)
            }
            
            // Tab Indicator
            for i in 1...Int(self.src.count){
                
                // Tab Mask
                let maskLayer:CALayer = CALayer.init()
                maskLayer.backgroundColor = UIColor.black.cgColor
                maskLayer.frame = CGRect(x: 0, y: 0, width: w, height: self.config.indicator_height)
                maskLayer.cornerRadius = self.config.indicator_cornerradius
                
                let bar:UIView = UIView.init()
                bar.backgroundColor = self.config.indicator_color
                bar.frame = CGRect(x: tabList[i-1].frame.origin.x, y: tabList[i-1].frame.origin.y, width: 0, height: tabList[i-1].frame.size.height)
                bar.layer.borderWidth = 0
                bar.layer.cornerRadius = self.config.indicator_cornerradius
                self.view.addSubview(bar)
                bar.layer.mask = maskLayer
                tabIndicatorList.append(bar)
            }
            

        }
        // ---- End ----
    }
    
    public func injectSrc(_ src:[RCardSliderData], _ config:RCardSliderConfig){
        self.src = src
        self.config = config
    }
    
    public func reset() {
        interrupted = false
        if (self.displayLink != nil){
            if (layoutscl) {
                resetIndicatorWidth()
            }
        }
    }
    
    @objc func update(){
        if (interrupted) {
            return
        }
        let def:Double = CACurrentMediaTime()-displayTime
        if (def <= self.displayDuration && layoutbeingreset==false){
            let ratio:CGFloat = CGFloat(def) / CGFloat(displayDuration)
            let theview:UIView = tabIndicatorList[displayCount]
            theview.frame = CGRect(x: theview.frame.origin.x, y: theview.frame.origin.y,
                                   width: CGFloat(tabWidth) * ratio, height: theview.frame.size.height)
            displayPreView = theview
        }
        else if (layoutbeingreset){
            if (def >= self.config.indicator_resetdelay){
                layoutbeingreset = false
                resetIndicatorWidth()
            }
        }
        else{
            if (displayPreView != nil){
                displayPreView!.frame = CGRect(x: displayPreView!.frame.origin.x, y: displayPreView!.frame.origin.y,
                                               width: CGFloat(tabWidth), height: displayPreView!.frame.size.height)
            }
            displayCount = (displayCount+1)%self.src.count
            displayTime = CACurrentMediaTime()
            if (displayCount == 0){
                layoutbeingreset = true
            }else{
                scrollViewScrollByIndex(displayCount, true)
            }
        }
    }
    
    private func resetIndicatorWidth(){
        displayPreView = nil
        displayTime = CACurrentMediaTime()
        displayCount = 0
        for i in 0 ..< tabIndicatorList.count{
            let vv:UIView = tabIndicatorList[i]
            vv.frame = CGRect(x: vv.frame.origin.x, y: vv.frame.origin.y, width: 0, height: vv.frame.size.height)
        }
        scrollViewScrollByIndex(0, true)
    }
    
    private func snapInnerView(){
        let offsetx:CGFloat = CGFloat(self.sclView.contentOffset.x)
        let findex:CGFloat = offsetx / self.sclView.frame.size.width
        let index:Int = Int(roundf(Float(findex)))
        scrollViewScrollByIndex(index, true)
        
        for i in 0 ..< tabIndicatorList.count{
            let vv:UIView = tabIndicatorList[i]
            vv.frame = CGRect(x: vv.frame.origin.x, y: vv.frame.origin.y, width: 0, height: vv.frame.size.height)
        }
        
        for i in 0 ... index{
            let vv:UIView = tabIndicatorList[i]
            vv.frame = CGRect(x: vv.frame.origin.x, y: vv.frame.origin.y, width: CGFloat(self.tabWidth), height: vv.frame.size.height)
        }
    }
    
    private func scrollViewScrollByIndex(_ index:Int, _ animated:Bool){
        let x:Int = Int(self.sclView.bounds.size.width) * index
        let rect:CGRect = CGRect(x: x, y: 0, width: Int(self.sclView.bounds.size.width), height: Int(self.sclView.bounds.size.height))
        self.sclView.scrollRectToVisible(rect, animated: animated)
    }

}

extension RCardSlidingView:UIScrollViewDelegate {
    @objc(scrollViewWillBeginDragging:)
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("begin dragging")
        if (self.config.indicator_interruptable) {
            interrupted = true
        }
    }
    
    @objc(scrollViewDidEndDecelerating:)
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("end decelerating...")
        snapInnerView()
    }
    
    @objc(scrollViewDidEndDragging:scrollViewDidEndDragging:)
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("end dragging~~~")
        snapInnerView()
    }
}
