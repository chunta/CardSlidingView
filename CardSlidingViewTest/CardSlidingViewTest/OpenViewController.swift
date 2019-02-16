//
//  OpenViewController.swift
//  CardSlidingViewTest
//
//  Created by nmi on 2019/2/16.
//  Copyright © 2019 nmi. All rights reserved.
//

import UIKit

class OpenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onTab(){
        self.present(ViewController(), animated: true, completion: nil)
    }

}
