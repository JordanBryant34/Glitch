//
//  EsportsOnboardingController.swift
//  Glitch
//
//  Created by Jordan Bryant on 7/24/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class EsportsOnboardingController: UIViewController {
    
    let followLabel: UILabel = {
        let label = UILabel()
        label.text = "Follow some esports teams"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 22.5)
        label.textColor = .white
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .twitchGrayTextColor()
        label.font = .systemFont(ofSize: 17.5)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "See the scores and game times of esport matches by following teams."
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 65/2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .twitchLightGray()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let attributedString = NSAttributedString(string: NSLocalizedString("Back", comment: ""), attributes:[
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17.5),
            NSAttributedString.Key.foregroundColor : UIColor.twitchGrayTextColor(),
            NSAttributedString.Key.underlineStyle : 1.0
        ])
        button.setAttributedTitle(attributedString, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var followTeamController: FollowTeamController = {
        let controller = FollowTeamController()
        controller.view.backgroundColor = .clear
        controller.backgroundView.removeFromSuperview()
        controller.tableView.backgroundColor = .clear
        controller.searchLabel.isHidden = true
        controller.separatorView.isHidden = true
        controller.cellBackgroundColor = .clear
        return controller
    }()
    
    var pageViewController: OnboardingPageViewController?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        view.addSubview(followTeamController.backgroundView)
        view.addSubview(followLabel)
        view.addSubview(subLabel)
        view.addSubview(continueButton)
        view.addSubview(backButton)
        view.addSubview(followTeamController.view)
        
        followLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        followLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        subLabel.anchor(followLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 75)
        
        continueButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 60, bottomConstant: view.frame.height * 0.175, rightConstant: 60, widthConstant: 0, heightConstant: 65)
        
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 15).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        followTeamController.view.anchor(subLabel.bottomAnchor, left: view.leftAnchor, bottom: continueButton.topAnchor, right: view.rightAnchor, topConstant: -65, leftConstant: 0, bottomConstant: 25, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        followTeamController.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        followTeamController.backgroundView.imageView.image = UIImage(named: "esportsBackground")?.withRenderingMode(.alwaysTemplate)
        followTeamController.backgroundView.imageView.tintColor = UIColor.white.withAlphaComponent(0.05)
        followTeamController.backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80).isActive = true
        followTeamController.backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        followTeamController.backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        followTeamController.backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    @objc private func handleContinue() {
        pageViewController?.changeToNextPage()
    }
    
    @objc private func handleBackButton() {
        pageViewController?.changeToPreviousPage()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
