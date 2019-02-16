//
//  ViewController.swift
//  CardSlidingViewTest
//
//  Created by nmi on 2019/2/14.
//  Copyright © 2019 nmi. All rights reserved.
//

import UIKit
import CardSlidingView

class ViewController: UIViewController {

    var slidingView:RCardSlidingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let src:[RCardSliderData] = [ RCardSliderData.init(title: "The Untold Secret To Mastering ALITA In Just 3 Days.3 Simple Tips For Using ALITA To Get Ahead Your Competition",
                                                           des: "HelloJohn",
                                                           url: "https://dl.dropboxusercontent.com/s/qe2uk79eyqpmc4p/daniel-gregoire-607453-unsplash-small.jpg"),
                                      
                                      RCardSliderData.init(title: "The program’s instructor will be on hand to answer your questions during a live Q&A session.",
                                                           des: "Join our Open House for the Robotics Software Engineer Nanodegree program",
                                                           url: "https://dl.dropboxusercontent.com/s/r1blgs7eue99y5x/on-the-road-6-1384796.jpg"),
                                      
                                      RCardSliderData.init(title: "How To Earn $398/Day Using ALITA",
                                                           des: "Hello Miss",
                                                           url: "https://dl.dropboxusercontent.com/s/kalnied3mo0bu2k/pickupimage.jpg"),
                                      
                                      RCardSliderData.init(title: "About the Speaker",
                                                           des: "Its just a shell.... That part up to you.",
                                                           url: "https://dl.dropboxusercontent.com/s/q7v8e4f971ldirn/screen-shot-2018-05-07-at-2-53-55-pm.png")]
        
        
        let conf01:RCardSliderConfig = RCardSliderConfig.init(gap: 6, botmargin: 20,
                                                            rlmargin: 20, color: UIColor.white, titlecolor: UIColor.white, descolor: UIColor.white,
                                                            cornerradius: 2, height: 4,
                                                            slideduration: 1, resetdelay: 0.7,
                                                            interruptable: true, placeholder: nil, textalignment: .Bottom,
                                                            titlehighlitcolor: UIColor.init(red: 1.0, green: 0, blue: 1.0, alpha: 0.2),
                                                            deshighlitcolor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4))
        
        slidingView = RCardSlidingView.init(src, conf01/*RCardSlidingView.defaultConfig*/)
        slidingView.view.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(slidingView.view)
        NSLayoutConstraint(item: self.slidingView.view, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute:.leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self.slidingView.view, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute:.trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self.slidingView.view, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 90.0).isActive = true
        NSLayoutConstraint(item: self.slidingView.view, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.4, constant: 0.0).isActive = true
        
        let button:UIButton = UIButton.init(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        button.addTarget(self, action: #selector(Dismiss), for: .touchDown)
        button.setTitle("Dismiss", for: .normal)
        self.view.addSubview(button)
        
        self.view.backgroundColor = UIColor.yellow
    }
    
    @objc
    func Dismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(#function, self.view.frame)
    }


}

