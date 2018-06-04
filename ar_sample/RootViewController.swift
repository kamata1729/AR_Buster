//
//  RootViewController.swift
//  ar_sample
//
//  Created by 鎌田啓路 on 2018/05/26.
//  Copyright © 2018年 鎌田啓路. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    @IBAction func tapButton(_ sender: Any) {
        generator.impactOccurred()
    }
    let generator = UIImpactFeedbackGenerator(style: .medium)
    override func viewDidLoad() {
        super.viewDidLoad()
        generator.prepare()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

@IBDesignable class customButton: UIButton {
    
}
