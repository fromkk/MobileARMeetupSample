//
//  RecordWindow.swift
//  ARKitSample
//
//  Created by Kazuya Ueoka on 2018/02/04.
//  Copyright © 2018 Timers, Inc. All rights reserved.
//

import UIKit

class RecordWindow: UIWindow {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    private var isSetUp: Bool = false
    private func setUp() {
        guard !isSetUp else { return }
        defer { isSetUp = true }
        
        addSubview(recordButton)
        layoutRecordButton()
    }
    
    lazy var recordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.layer.borderWidth = 12.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 40.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func layoutRecordButton() {
        NSLayoutConstraint.activate([
            recordButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            recordButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -0.0),
            recordButton.widthAnchor.constraint(equalToConstant: 80.0),
            recordButton.heightAnchor.constraint(equalTo: recordButton.widthAnchor),
            ])
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event), view.isEqual(recordButton) else {
            return nil
        }
        
        return recordButton
    }
    
}
