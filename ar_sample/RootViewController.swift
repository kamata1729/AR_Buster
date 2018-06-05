//
//  RootViewController.swift
//  ar_sample
//
//  Created by 鎌田啓路 on 2018/05/26.
//  Copyright © 2018年 鎌田啓路. All rights reserved.
//

import UIKit
import TouchVisualizer

class RootViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!

    @IBAction func longTap(_ sender: Any) {
        print("press")
        Visualizer.start()
        let alert: UIAlertController = UIAlertController(title: "タップ可視化モード", message: "TouchVisualizerを有効にします", preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)

    }
    
    @IBAction func tapButton(_ sender: Any) {
        generator.impactOccurred()
    }
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generator.prepare()
        Visualizer.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// storyboardで編集するために必要な宣言
@IBDesignable class customButton: UIButton {
}
