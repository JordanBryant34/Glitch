//
//  WelcomeViewController.swift
//  Glitch
//
//  Created by Jordan Bryant on 7/22/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "glitchLogoLarge")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 22.5)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome to Glitch"
        label.sizeToFit()
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .twitchGrayTextColor()
        label.font = .systemFont(ofSize: 17.5)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "To get started, let's set up your profile and link your accounts."
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let setupButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 65/2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .twitchLightGray()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Setup Profile", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//    let skipButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .clear
//        let attributedString = NSAttributedString(string: NSLocalizedString("Skip Setup", comment: ""), attributes:[
//            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17.5),
//            NSAttributedString.Key.foregroundColor : UIColor.twitchGrayTextColor(),
//            NSAttributedString.Key.underlineStyle : 1.0
//        ])
//        button.setAttributedTitle(attributedString, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    var pageViewController: OnboardingPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        skipButton.addTarget(self, action: #selector(handleSkipSetup), for: .touchUpInside)
        setupButton.addTarget(self, action: #selector(handleSetup), for: .touchUpInside)
        
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        view.addSubview(welcomeLabel)
        view.addSubview(logoImageView)
        view.addSubview(subLabel)
        view.addSubview(setupButton)
//        view.addSubview(skipButton)
        
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: welcomeLabel.topAnchor, constant: -20).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        
        subLabel.anchor(welcomeLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 75)
        
        setupButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 60, bottomConstant: view.frame.height * 0.175, rightConstant: 60, widthConstant: 0, heightConstant: 65)
        
//        skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        skipButton.topAnchor.constraint(equalTo: setupButton.bottomAnchor, constant: 15).isActive = true
//        skipButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
//        skipButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    @objc private func handleSkipSetup() {
        let alert = UIAlertController(title: "Are you sure you want to skip setting up your profile?", message: "You can always set up your profile and link your accounts later.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.pageViewController?.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    @objc private func handleSetup() {
        pageViewController?.changeToNextPage()
    }
}
