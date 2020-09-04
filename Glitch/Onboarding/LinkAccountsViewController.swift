//
//  LinkAccountsViewController.swift
//  Glitch
//
//  Created by Jordan Bryant on 7/22/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class LinkAccountsViewController: UIViewController {
    
    let linkAccountsLabel: UILabel = {
        let label = UILabel()
        label.text = "Link your accounts"
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
        label.text = "Connect your accounts from other platforms to view them in Glitch."
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let twitchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Connect Twitch", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Twitch Connected", for: .disabled)
        button.setTitleColor(.twitchGrayTextColor(), for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.titleLabel?.textAlignment = .left
        button.backgroundColor = .twitchLightGray()
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.twitchGrayTextColor().withAlphaComponent(0.3).cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let twitchLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "twitchLogo")
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let twitterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Connect Twitter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Twitter Connected", for: .disabled)
        button.setTitleColor(.twitchGrayTextColor(), for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.titleLabel?.textAlignment = .left
        button.backgroundColor = .twitchLightGray()
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.twitchGrayTextColor().withAlphaComponent(0.3).cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let twitterLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "twitterLogo")
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    let twitchCheckImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let twitterCheckImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var pageViewController: OnboardingPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        twitchCheckImageView.image = HelperFunctions.resizeImage(image: UIImage(named: "checkmarkIcon")!, newSize: CGSize(width: 20, height: 20))
        twitterCheckImageView.image = HelperFunctions.resizeImage(image: UIImage(named: "checkmarkIcon")!, newSize: CGSize(width: 20, height: 20))
        
        twitchButton.addTarget(self, action: #selector(handleTwitch), for: .touchUpInside)
        twitterButton.addTarget(self, action: #selector(handleTwitter), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        view.addSubview(linkAccountsLabel)
        view.addSubview(subLabel)
        view.addSubview(twitchButton)
        view.addSubview(twitterButton)
        view.addSubview(continueButton)
        view.addSubview(backButton)
        
        twitchButton.addSubview(twitchLogoImageView)
        twitchButton.addSubview(twitchCheckImageView)
        twitterButton.addSubview(twitterLogoImageView)
        twitterButton.addSubview(twitterCheckImageView)
        
        linkAccountsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        linkAccountsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        subLabel.anchor(linkAccountsLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 75)
        
        twitchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        twitchButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -5).isActive = true
        twitchButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        twitchButton.widthAnchor.constraint(equalToConstant: view.frame.width + 4).isActive = true
        
        twitchLogoImageView.centerYAnchor.constraint(equalTo: twitchButton.centerYAnchor).isActive = true
        twitchLogoImageView.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -100).isActive = true
        twitchLogoImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        twitchLogoImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        twitterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        twitterButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 5).isActive = true
        twitterButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        twitterButton.widthAnchor.constraint(equalToConstant: view.frame.width + 4).isActive = true
    
        twitterLogoImageView.centerYAnchor.constraint(equalTo: twitterButton.centerYAnchor).isActive = true
        twitterLogoImageView.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -100).isActive = true
        twitterLogoImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        twitterLogoImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        twitchCheckImageView.centerYAnchor.constraint(equalTo: twitchButton.centerYAnchor).isActive = true
        twitchCheckImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        twitchCheckImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        twitchCheckImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        twitterCheckImageView.centerYAnchor.constraint(equalTo: twitterButton.centerYAnchor).isActive = true
        twitterCheckImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        twitterCheckImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        twitterCheckImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        continueButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 60, bottomConstant: view.frame.height * 0.175, rightConstant: 60, widthConstant: 0, heightConstant: 65)
        
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 15).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    @objc private func handleTwitch() {
        TwitchService.signIn(withViewController: self) { (status) in
            if status == .validAccessToken {
                self.twitchButton.isEnabled = false
                self.twitchCheckImageView.isHidden = false
            }
        }
    }
    
    @objc private func handleTwitter() {
        TwitterService.signIn(withViewController: self) { (isSignedIn) in
            if isSignedIn {
                self.twitterButton.isEnabled = false
                self.twitterCheckImageView.isHidden = false
            }
        }
    }
    
    @objc private func handleContinue() {
        pageViewController?.changeToNextPage()
    }
    
    @objc private func handleBackButton() {
        pageViewController?.changeToPreviousPage()
    }
}
