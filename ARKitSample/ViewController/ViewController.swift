//
//  ViewController.swift
//  ARKitSample
//
//  Created by Kazuya Ueoka on 2018/02/04.
//  Copyright © 2018 Timers, Inc. All rights reserved.
//

import UIKit

extension Constants {
    fileprivate enum ViewController {
        static let cellIdentifier: String = "Cell"
    }
}

class ViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        
        title = "Sample"
        
        view.addSubview(tableView)
        layoutTableView()
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.ViewController.cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private func layoutTableView() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewController.cellIdentifier, for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Eular"
        case 1:
            cell.textLabel?.text = "Poly"
        case 2:
            cell.textLabel?.text = "ReplayKit"
        default:
            cell.textLabel?.text = nil
            break
        }
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        switch indexPath.row {
        case 0:
            let eularViewController = EularViewController()
            navigationController?.pushViewController(eularViewController, animated: true)
        case 1:
            let polyViewController = PolyViewController()
            navigationController?.pushViewController(polyViewController, animated: true)
        case 2:
            let replayKitViewController = ReplayKitViewController()
            navigationController?.pushViewController(replayKitViewController, animated: true)
        default:
            break
        }
    }
    
}
