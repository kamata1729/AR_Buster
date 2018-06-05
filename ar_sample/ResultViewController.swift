//
//  ResultViewController.swift
//  ar_sample
//
//  Created by 鎌田啓路 on 2018/05/26.
//  Copyright © 2018年 鎌田啓路. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var score1: UILabel!
    @IBOutlet weak var score2: UILabel!
    @IBOutlet weak var score3: UILabel!
    @IBOutlet weak var score4: UILabel!
    @IBOutlet weak var score5: UILabel!
    
    @IBAction func tapButton(_ sender: Any) {
        generator.impactOccurred()
    }
    let generator = UIImpactFeedbackGenerator(style: .medium)
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generator.prepare()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let score = appDelegate.score {
            self.score = score
            scoreLabel.text = String(self.score) + "点"
        } else {
            scoreLabel.text = "エラー"
        }
        let scorelabels: [UILabel] = [score1, score2, score3, score4, score5]
        let defaults = UserDefaults()
        if var scoreArray = defaults.array(forKey: "score") as? [Int] {
            scoreArray.append(score)
            scoreArray.sort(by: {$0 > $1})
            scoreArray = scoreArray.prefix(5).map{$0}
            defaults.set(scoreArray, forKey: "score")
            defaults.synchronize()
            
            for i in stride(from: 0, to: scoreArray.count, by: 1) {
                scorelabels[i].text = String(scoreArray[i]) + "点"
            }
            
        } else {
            let scoreArray: [Int] = [self.score]
            defaults.set(scoreArray, forKey: "score")
            defaults.synchronize()
            for i in stride(from: 0, to: scoreArray.count, by: 1) {
                scorelabels[i].text = String(scoreArray[i]) + "点"
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
