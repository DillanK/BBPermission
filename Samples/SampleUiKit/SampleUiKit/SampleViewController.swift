//
//  ViewController.swift
//  BBPermission
//
//  Created by hyunjin on 9/11/25.
//

import UIKit
import Foundation
import Combine

class SampleViewController: UIViewController {

    @IBOutlet var tbPermission: UITableView!
    
    var cancellables = Set<AnyCancellable>()
    
    deinit {
        cancellables.removeAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initRegist()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    private func initRegist() {
        // 앱이 포그라운드에 들어올 때 (백그라운드에서 다시 활성화될 때)
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { _ in
                self.tbPermission.reloadData()
            }
            .store(in: &cancellables)
    }

    private func initView() {
        tbPermission.register(UINib(nibName: "PermissionTableCell", bundle: Bundle.main), forCellReuseIdentifier: "PermissionTableCell")
        tbPermission.dataSource = self
        tbPermission.delegate = self
    }
}

extension SampleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PermissionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PermissionTableCell", for: indexPath) as? PermissionTableCell else {
            return UITableViewCell()
        }
        
        cell.setData(type: PermissionType.allCases[indexPath.row])
        cell.loadView()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PermissionTableCell else {
            return
        }
        
        cell.permission?.requestPermission(with: true, completed: { status in
            DispatchQueue.main.async {
                self.tbPermission.reloadData()
            }
        })
    }
}

