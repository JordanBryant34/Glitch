//
//  SettingsViewController.swift
//  Glitch
//
//  Created by Jordan Bryant on 4/20/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView: UITableView = {
        let tv = UITableView(frame: CGRect.zero, style: .grouped)
        tv.backgroundColor = .clear
        return tv
    }()

    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupTableView()
    }

    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        default:
            return 0
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        cell.textLabel?.textColor = .white
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .twitchLightGray()
        cell.textLabel?.font = .systemFont(ofSize: 15)
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Twitter"
            case 1:
                cell.textLabel?.text = "Youtube"
            case 2:
                cell.textLabel?.text = "Twitch"
            case 3:
                cell.textLabel?.text = "Mixer"
            default:
                cell.textLabel?.text = ""
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Platforms"
        default:
            return ""
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .twitchGrayTextColor()
            headerView.textLabel?.text = headerView.textLabel?.text?.capitalized
            headerView.textLabel?.font = .boldSystemFont(ofSize: 20)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let cell = tableView.cellForRow(at: indexPath)
            let platformSettingsController = PlatformSettingsController()
            platformSettingsController.platform = cell?.textLabel?.text?.lowercased() ?? ""
            
            present(platformSettingsController, animated: true, completion: nil)
        }
    }

    deinit {
        print("Settings deinit")
    }
}
