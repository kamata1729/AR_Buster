import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer: Timer?
    var isFirstObjTapped: Bool = false
    var timerCnt :Int = 30 //タイムリミットは30sec
    var score: Int = 0
    let generator = UIImpactFeedbackGenerator(style: .medium) //Taptic Engine generator
    

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //デリゲートを設定することにより、sceneViewをこのViewController上で制御可能
        sceneView.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapView))
        sceneView.addGestureRecognizer(gesture)
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        generator.prepare()
    }
    
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let scene = SCNScene(named: "art.scnassets/Suzy.scn") {
            if let suzyNode = scene.rootNode.childNode(withName: "Suzy", recursively: true) {
                suzyNode.position = SCNVector3(x: 0, y: 0, z: -0.5)
                sceneView.scene.rootNode.addChildNode(suzyNode)
            }
        }
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // MARK: - tapView
    @objc private func tapView(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        
        let hitTestResult = sceneView.hitTest(location, types: .featurePoint)
        if let result = hitTestResult.first {
            print("hit")
            if let camera = sceneView.pointOfView {
                var position = SCNVector3()
                var flag: Bool = false
                for_i: for i in stride(from: -2, to: 2, by: 0.0005){
                    let t: Float = Float(i)
                    self.sceneView.scene.rootNode.enumerateChildNodes {(node, _) in
                        position.x = (1 - t)*camera.position.x + t * result.worldTransform.columns.3.x
                        position.y = (1 - t)*camera.position.y + t * result.worldTransform.columns.3.y
                        position.z = (1 - t)*camera.position.z + t * result.worldTransform.columns.3.z
                        let isInRangeX: Bool = isInRange(tapPosition: position.x, objPosition: node.position.x, radius: 0.08)
                        let isInRangeY: Bool = isInRange(tapPosition: position.y, objPosition: node.position.y, radius: 0.08)
                        let isInRangeZ: Bool = isInRange(tapPosition: position.z, objPosition: node.position.z, radius: 0.08)
                        if(isInRangeX && isInRangeY && isInRangeZ){
                            self.sceneView.scene.rootNode.enumerateChildNodes {(node, _) in
                                node.removeFromParentNode() //該当のノードを削除
                            }
                            score += 1
                            generator.impactOccurred() //Taptic Engine
                            print("i = " + String(i))
                            print("スコア: " + String(score))
                            makeNewObj(camera: camera) //新しいオブジェクトを生成
                            if(!isFirstObjTapped) {
                                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerUpdate), userInfo: nil, repeats: true)
                            }
                            isFirstObjTapped = true
                            flag = true
                            return //クロージャから抜ける
                        }
                    }
                    if(flag) {
                        //forから抜ける（一応明示的）
                        break for_i
                    }
                }
            }
        }
    }
    
    
    // MARK: - timerUpdate
    @objc private func timerUpdate() {
        timerCnt -= 1
        timerLabel.text = String(timerCnt)
        if(timerCnt < 0) {
            timer?.invalidate()
            finish()
        }
    }
    
    private func finish(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.score = self.score
        let resultVC = storyboard!.instantiateViewController(withIdentifier: "result");
        self.present(resultVC ,animated: true, completion: nil)
    }
    
    
    //カメラ周辺のランダムな位置にオブジェクトを配置する
    private func makeNewObj(camera :SCNNode) {
        if let scene = SCNScene(named: "art.scnassets/Suzy.scn") {
            if let node = scene.rootNode.childNode(withName: "Suzy", recursively: true) {
                let randx = drand48()*0.6 - 0.3
                let randy = drand48()*0.6 - 0.3
                let randz = drand48()*0.6 - 0.3
                let position = SCNVector3(randx, randy, randz-0.4)
                node.position = camera.convertPosition(position, to: nil)// カメラ位置からの偏差で求めた位置
                node.eulerAngles = camera.eulerAngles  // 向きをカメラのオイラー角と同じにする
                sceneView.scene.rootNode.addChildNode(node)
            }
        }
    }
    
    //オブジェクトをタップできているかを見る関数
    private func isInRange(tapPosition: Float, objPosition: Float, radius: Float) -> Bool{
        if(objPosition - radius <= tapPosition && tapPosition <= objPosition + radius){
            return true
        }else{
            return false
        }
    }
    private func isTappedObj(tapPosition: SCNVector3, objPosition: SCNVector3, radius: Float) -> Bool {
        var flag: Bool = true
        for (tap, obj) in [(tapPosition.x, objPosition.x), (tapPosition.y, objPosition.y), (tapPosition.z, objPosition.z)] {
            if(obj - radius <= tap && tap <= obj + radius) {
                flag = false
            }
        }
        return !flag
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
