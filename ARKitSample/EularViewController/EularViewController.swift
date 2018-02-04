//
//  ViewController.swift
//  ARKitSample
//
//  Created by Kazuya Ueoka on 2018/02/03.
//  Copyright © 2018 Timers, Inc. All rights reserved.
//

import UIKit
import ARKit

class EularViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.session.delegate = self
        view.addSubview(sceneView)
        layoutSceneView()
        
        view.addSubview(stateLabel)
        layoutStateLabel()
        
        view.addSubview(eularLabel)
        layoutEulaerLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    lazy var sceneView: ARSCNView = {
        let sceneView = ARSCNView(frame: .zero, options: nil)
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
            stateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            stateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            stateLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80.0)
            ])
    }
    
    lazy var eularLabel: UILabel = {
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
    
    private func layoutEulaerLabel() {
        NSLayoutConstraint.activate([
            eularLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            eularLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            eularLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40.0)
            ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension EularViewController: ARSessionDelegate {
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

extension EularViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            if let eularAngles = self.sceneView.session.currentFrame?.camera.eulerAngles {
                self.eularLabel.text = String(format: "eular y: %f", eularAngles.y.toDegrees)
            }
        }
    }
    
}
