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
        print(Service.doSomething())
        
        let src:[RCardSliderData] = [ RCardSliderData.init(title: "The Untold Secret To Mastering ALITA In Just 3 Days.3 Simple Tips For Using ALITA To Get Ahead Your Competition", des: "Hello World",
                                                           url: "https://dl.dropboxusercontent.com/s/pue5p4tkw0f3xq1/haifsa-rafique-110898-unsplash-small.jpg"),
                                      
                                      RCardSliderData.init(title: "Why My ALITA Is Better Than Yours", des: "Hello Friend",
                                                           url: "https://dl.dropboxusercontent.com/s/r1blgs7eue99y5x/on-the-road-6-1384796.jpg"),
                                      
                                      RCardSliderData.init(title: "How To Earn $398/Day Using ALITA", des: "Hello Miss",
                                                           url: "https://dl.dropboxusercontent.com/s/kalnied3mo0bu2k/pickupimage.jpg")]
        
        let conf:RCardSliderConfig = RCardSliderConfig.init(gap: 6, botmargin: 20,
                                                            rlmargin: 20, color: UIColor.white,
                                                            cornerradius: 3, height: 6,
                                                            slideduration: 4, resetdelay: 0.7,
                                                            interruptable: true)
        slidingView = RCardSlidingView.init(src, conf)
        slidingView.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(slidingView.view)
        NSLayoutConstraint(item: self.slidingView.view, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute:.leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self.slidingView.view, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute:.trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self.slidingView.view, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 90.0).isActive = true
        NSLayoutConstraint(item: self.slidingView.view, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.4, constant: 0.0).isActive = true
        
    }


}

