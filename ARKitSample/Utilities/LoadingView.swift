//
//  LoadingView.swift
//  ARKitSample
//
//  Created by Kazuya Ueoka on 2018/02/04.
//  Copyright © 2018 Timers, Inc. All rights reserved.
//

import UIKit

final class LoadingView: UIWindow {
    
    static let shared: LoadingView = LoadingView(frame: UIScreen.main.bounds)
    
    private override init(frame: CGRect) {
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
        
        windowLevel = UIWindowLevelAlert + 1.0
        backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        isHidden = true
        makeKeyAndVisible()
        
        activityIndeicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndeicatorView)
        NSLayoutConstraint.activate([
            activityIndeicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndeicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
    }
    
    let activityIndeicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    func show() {
        isHidden = false
        
        if !activityIndeicatorView.isAnimating {
            activityIndeicatorView.startAnimating()
        }
    }
    
    func hide () {
        if activityIndeicatorView.isAnimating {
            activityIndeicatorView.stopAnimating()
        }
        
        isHidden = true
    }
    
}
