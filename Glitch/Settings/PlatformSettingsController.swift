//
//  PlatformSettingsController.swift
//  Glitch
//
//  Created by Jordan Bryant on 4/20/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class PlatformSettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView: UITableView = {
        let tv = UITableView(frame: CGRect.zero, style: .grouped)
        tv.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tv.backgroundColor = .clear
        return tv
    }()

    let cellId = "cellId"
    var platform = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = .twitchGray()
        
        setupTableView()
    }

    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .twitchLightGray()
        cell.textLabel?.font = .systemFont(ofSize: 15)
        cell.selectionStyle = .none
        
        if UserDefaults.standard.string(forKey: "\(platform)AccessToken") != nil {
           cell.textLabel?.text = "Sign Out"
        } else {
            cell.textLabel?.text = "Sign In"
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return platform
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .twitchGrayTextColor()
            headerView.textLabel?.text = headerView.textLabel?.text?.capitalized
            headerView.textLabel?.font = .boldSystemFont(ofSize: 20)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            handleSignInOrOut()
        default:
            print("default")
        }
    }
    
    private func handleSignInOrOut() {
        if UserDefaults.standard.string(forKey: "\(platform)AccessToken") != nil {
            let alert = UIAlertController(title: "Sign out of \(platform.capitalized)?", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                UserDefaults.standard.removeObject(forKey: "\(self.platform)AccessToken")
                UserDefaults.standard.removeObject(forKey: "\(self.platform)RefreshToken")
                self.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        } else {
            signIn()
        }
    }
    
    private func signIn() {
        switch platform {
        case "mixer":
            MixerService.signIn(withViewController: self) { (signedIn) in
                if signedIn {
                    self.reloadData()
                }
            }
        case "twitch":
            TwitchService.signIn(withViewController: self) { (status) in
                if status == .validAccessToken {
                    self.reloadData()
                }
            }
        case "twitter":
            TwitterService.signIn(withViewController: self) { (isSignedIn) in
                if isSignedIn {
                    self.reloadData()
                }
            }
        case "youtube":
            YoutubeService.signIn(withViewController: self) { (isSignedIn) in
                if isSignedIn {
                    self.reloadData()
                }
            }
        default:
            print("cant sign in")
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    deinit {
        print("Platform settings deinit")
    }
}


