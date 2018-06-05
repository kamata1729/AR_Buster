import UIKit
import TouchVisualizer

class RootViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func tapButton(_ sender: Any) {
        generator.impactOccurred()
    }
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generator.prepare()
        /* 以下はデモ用
        Visualizer.start()
         */
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
