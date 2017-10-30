//
//  ViewController.swift
//  ARKitHandsOn
//
//  Created by 藤井陽介 on 2017/10/29.
//  Copyright © 2017年 Fujii Yosuke. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var pumpkinNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        guard let scene = SCNScene(named: "model.scn") else {
            
            print("NotFound")
            return
        }
        
        let _pumpkinNode = scene.rootNode.childNode(withName: "n0b0", recursively: true)
        pumpkinNode = _pumpkinNode?.clone()
        pumpkinNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        pumpkinNode.scale = SCNVector3Make(0.001, 0.001, 0.001)
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.scene.rootNode.replaceChildNode(_pumpkinNode!, with: pumpkinNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touchLocation = touches.first?.location(in: sceneView) {
            
            if let hit = sceneView.hitTest(touchLocation, types: .featurePoint).first {
                
                let hitTransform = SCNMatrix4(hit.worldTransform)
                let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
                let pumpkinClone = pumpkinNode.clone()
                pumpkinClone.position = hitPosition
                sceneView.scene.rootNode.addChildNode(pumpkinClone)
            }
        }
    }

    // MARK: - ARSCNViewDelegate

/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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
