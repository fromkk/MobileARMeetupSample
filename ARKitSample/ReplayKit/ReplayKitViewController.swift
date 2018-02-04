//
//  ReplayKitViewController.swift
//  ARKitSample
//
//  Created by Kazuya Ueoka on 2018/02/04.
//  Copyright © 2018 Timers, Inc. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import ModelIO
import SceneKit.ModelIO
import PolyKit
import ReplayKit

extension Constants {
    fileprivate enum ReplayKitViewController {
        static let assetIdentifier: String = "dPgkqmBDqgH"
        static let defaultAngle: Float = Float(-90.0).toRadians
    }
}

class ReplayKitViewController: UIViewController {
    
    private enum State {
        case stop
        case recording
    }
    
    private var state: State = .stop {
        didSet {
            handleState()
        }
    }
    
    private func toggleState() {
        switch state {
        case .stop:
            state = .recording
        case .recording:
            state = .stop
        }
    }
    
    private func handleState() {
        switch state {
        case .stop:
            recordWindow.recordButton.backgroundColor = .clear
            
            RPScreenRecorder.shared().stopRecording(handler: { (previewViewController, error) in
                if let error = error {
                    debugPrint(#function, "stop error", error)
                    return
                }
                
                guard let previewViewController = previewViewController else { return }
                
                DispatchQueue.main.async {
                    previewViewController.previewControllerDelegate = self
                    self.present(previewViewController, animated: true, completion: nil)
                }
            })
        case .recording:
            recordWindow.recordButton.backgroundColor = .red
            
            RPScreenRecorder.shared().startRecording(handler: { (error) in
                debugPrint(#function, "start error", error)
            })
        }
    }
    
    var node: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(sceneView)
        layoutSceneView()
        
        fetchAsset()
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handle(panGesture:))))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handle(tapGesture:))))
        
        recordWindow.addSubview(stateLabel)
        layoutStateLabel()
        
        recordWindow.recordButton.addTarget(self, action: #selector(handleTap(recordButton:)), for: .touchUpInside)
        
        recordWindow.makeKeyAndVisible()
        
        handleState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
        
        recordWindow.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
        
        recordWindow.isHidden = true
    }
    
    // MARK: UI Elements
    
    let recordWindow: RecordWindow = {
        let window = RecordWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .clear
        return window
    }()
    
    lazy var sceneView: ARSCNView = {
        let sceneView = ARSCNView(frame: .zero, options: nil)
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.session.delegate = self
        sceneView.delegate = self
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        return sceneView
    }()
    
    private func layoutSceneView() {
        NSLayoutConstraint.activate([
            sceneView.widthAnchor.constraint(equalTo: view.widthAnchor),
            sceneView.heightAnchor.constraint(equalTo: view.heightAnchor),
            sceneView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sceneView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
    }
    
    lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40.0)
        label.textColor = .white
        label.textAlignment = .left
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        label.layer.shadowRadius = 5.0
        label.layer.shadowOpacity = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return label
    }()
    
    private func layoutStateLabel() {
        NSLayoutConstraint.activate([
            stateLabel.leadingAnchor.constraint(equalTo: recordWindow.leadingAnchor, constant: 16.0),
            stateLabel.trailingAnchor.constraint(equalTo: recordWindow.trailingAnchor, constant: -16.0),
            stateLabel.bottomAnchor.constraint(equalTo: recordWindow.safeAreaLayoutGuide.bottomAnchor, constant: -120.0)
            ])
    }
    
    
    
    // MARK: Event
    
    @objc private func handle(tapGesture: UITapGestureRecognizer) {
        guard let node = node else { return }
        
        let location = tapGesture.location(in: sceneView)
        guard let result = sceneView.hitTest(location, types: [.featurePoint, .estimatedHorizontalPlane]).first else {
            return
        }
        
        let position = SCNVector3(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
        
        if !sceneView.scene.rootNode.contains(node) {
            sceneView.scene.rootNode.addChildNode(node)
        }
        
        node.position = position
    }
    
    var lastPoint: CGPoint = .zero
    
    @objc private func handle(panGesture: UIPanGestureRecognizer) {
        guard let node = node else { return }
        
        let currentPoint = panGesture.location(in: sceneView)
        
        switch panGesture.state {
        case .began:
            lastPoint = currentPoint
        case .changed:
            let diff = CGPoint(x: currentPoint.x - lastPoint.x, y: currentPoint.y - lastPoint.y)
            
            var position = node.position
            position.x += Float(diff.x) / 100.0
            position.z += Float(diff.y) / 100.0
            
            node.position = position
            
            lastPoint = currentPoint
        default:
            break
        }
    }
    
    @objc private func handleTap(recordButton: UIButton) {
        toggleState()
    }
    
    // MARK: PolyKit
    
    private func fetchAsset() {
        LoadingView.shared.show()
        
        PolyAPI(apiKey: Constants.polyAPIKey).asset(Constants.ReplayKitViewController.assetIdentifier) { (result) in
            switch result {
            case .success(let asset):
                self.download(asset: asset)
            case .failure(let error):
                debugPrint(#function, "error", error)
                
                LoadingView.shared.hide()
            }
        }
    }
    
    private func download(asset: PolyAsset) {
        asset.downloadObj { (result) in
            switch result {
            case .success(let localURL):
                let mdlAsset = MDLAsset(url: localURL)
                mdlAsset.loadTextures()
                self.node = SCNNode(mdlObject: mdlAsset.object(at: 0))
                
                LoadingView.shared.hide()
            case .failure(let error):
                debugPrint(#function, "error", error)
                
                LoadingView.shared.hide()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ReplayKitViewController: ARSessionDelegate {
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        DispatchQueue.main.async {
            switch camera.trackingState {
            case .normal:
                self.stateLabel.text = "state: normal"
            case .notAvailable:
                self.stateLabel.text = "state: notAvailable"
            case .limited(let reason):
                self.stateLabel.text = "state: limited(\(reason))"
            }
        }
    }
}

extension ReplayKitViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            if let eularAngles = self.sceneView.session.currentFrame?.camera.eulerAngles {
                self.node?.eulerAngles = SCNVector3(0.0, eularAngles.y + Constants.ReplayKitViewController.defaultAngle, 0.0)
            }
        }
    }
    
}

extension ReplayKitViewController: RPPreviewViewControllerDelegate {
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true, completion: nil)
    }
    
}
