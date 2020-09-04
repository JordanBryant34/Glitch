//
//  YoutubeOnboardingController.swift
//  Glitch
//
//  Created by Jordan Bryant on 7/23/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class YoutubeOnboardingController: UIViewController {
    
    let followLabel: UILabel = {
        let label = UILabel()
        label.text = "Follow your favorite YouTubers"
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
        label.text = "View the recent videos of YouTube creators by following them."
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
    
    lazy var youtubeSearchController: YoutubeSearchController = {
        let controller = YoutubeSearchController()
        controller.view.backgroundColor = .clear
        controller.backgroundView.removeFromSuperview()
        controller.searchLabel.isHidden = true
        controller.separatorView.isHidden = true
        controller.searchBar.searchTextField.backgroundColor = .twitchLightGray()
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
        
        view.addSubview(youtubeSearchController.backgroundView)
        view.addSubview(followLabel)
        view.addSubview(subLabel)
        view.addSubview(continueButton)
        view.addSubview(backButton)
        view.addSubview(youtubeSearchController.view)
        
        followLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        followLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        subLabel.anchor(followLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 75)
        
        continueButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 60, bottomConstant: view.frame.height * 0.175, rightConstant: 60, widthConstant: 0, heightConstant: 65)
        
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 15).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        youtubeSearchController.view.anchor(subLabel.bottomAnchor, left: view.leftAnchor, bottom: continueButton.topAnchor, right: view.rightAnchor, topConstant: -65, leftConstant: 0, bottomConstant: 25, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        youtubeSearchController.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        youtubeSearchController.backgroundView.imageView.image = UIImage(named: "youtubeBackground")?.withRenderingMode(.alwaysTemplate)
        youtubeSearchController.backgroundView.imageView.tintColor = UIColor.white.withAlphaComponent(0.05)
        youtubeSearchController.backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80).isActive = true
        youtubeSearchController.backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        youtubeSearchController.backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        youtubeSearchController.backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
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
