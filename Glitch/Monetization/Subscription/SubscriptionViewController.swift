//
//  SubscriptionViewController.swift
//  Glitch
//
//  Created by Jordan Bryant on 6/2/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Purchases

class SubscriptionViewController: UIViewController {
    
    let subscribeButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 65/2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .twitchLightGray()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Subscribe for $1.99/month", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let declineButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = false
        button.setTitleColor(.white, for: .normal)
        let attributedString = NSAttributedString(string: NSLocalizedString("No thanks", comment: ""), attributes:[
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17.5),
            NSAttributedString.Key.foregroundColor : UIColor.twitchGrayTextColor(),
            NSAttributedString.Key.underlineStyle : 1.0
        ])
        button.setAttributedTitle(attributedString, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let restoreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Restore", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
     
    let freeTrialLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.text = "Start your 7-day free trial now."
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
     
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 25)
        label.text = "Tired of the ads?"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
     
    let infoSubLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.font =  .systemFont(ofSize: 20)
        label.numberOfLines = 5
        label.lineBreakMode = .byWordWrapping
        label.text = "Remove all Glitch ads from the entire app by subscribing. Start with a 7 day free trial."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
     
    let gradientSeparator: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
     
    let glitchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "glitchLogoLarge")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
     
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "subscriptionBackground")
        imageView.alpha = 0.5
        return imageView
    }()
     
    let finePrintLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 11)
        label.numberOfLines = 4
        label.lineBreakMode = .byWordWrapping
        label.text = "This subscription renews automatically unless cancelled in 'Settings' at least 24 hours before the next billing date. Billing begins right after the end of the trial period."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
     
    let activityIndicatorView: NVActivityIndicatorView = {
         let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .white, padding: 0)
         indicator.translatesAutoresizingMaskIntoConstraints = false
         indicator.alpha = 0.8
         return indicator
    }()
     
    var isRegistering = false
     
     override func viewDidLoad() {
        super.viewDidLoad()
                  
        subscribeButton.addTarget(self, action: #selector(subscribePressed), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restorePurchase), for: .touchUpInside)
        declineButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
         
        setupViews()
     }
     
     func setupViews() {
        view.backgroundColor = .twitchGray()
         
        view.addSubview(backgroundImageView)
        view.addSubview(subscribeButton)
        view.addSubview(declineButton)
        view.addSubview(freeTrialLabel)
        view.addSubview(gradientSeparator)
        view.addSubview(infoSubLabel)
        view.addSubview(infoLabel)
        view.addSubview(glitchImageView)
        view.addSubview(finePrintLabel)
        view.addSubview(restoreButton)
        view.addSubview(activityIndicatorView)
         
        backgroundImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        gradientSeparator.anchor(nil, left: view.leftAnchor, bottom: freeTrialLabel.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 25, rightConstant: 20, widthConstant: 0, heightConstant: 2)
        infoSubLabel.anchor(infoLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 60, bottomConstant: 0, rightConstant: 60, widthConstant: 0, heightConstant: view.frame.height * 0.14)
        
        subscribeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subscribeButton.topAnchor.constraint(equalTo: freeTrialLabel.bottomAnchor, constant: 20).isActive = true
        subscribeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        subscribeButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        declineButton.anchor(subscribeButton.bottomAnchor, left: subscribeButton.leftAnchor, bottom: nil, right: subscribeButton.rightAnchor, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        restoreButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        restoreButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        restoreButton.heightAnchor.constraint(equalToConstant: 22.5).isActive = true
        restoreButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
         
        freeTrialLabel.topAnchor.constraint(equalTo: infoSubLabel.bottomAnchor, constant: 50).isActive = true
        freeTrialLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
         
        infoLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
         
        glitchImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        glitchImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        glitchImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        glitchImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
         
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1).isActive = true
        
        finePrintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        finePrintLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        finePrintLabel.widthAnchor.constraint(equalTo: declineButton.widthAnchor, multiplier: 0.8).isActive = true
        finePrintLabel.heightAnchor.constraint(equalToConstant: 85).isActive = true
     }
     
     @objc func subscribePressed() {
        activityIndicatorView.startAnimating()
        let delegate = UIApplication.shared.delegate as! AppDelegate
        Purchases.shared.offerings { (offerings, error) in
            if let package = offerings?.offering(identifier: "default")?.availablePackages[0] {
                Purchases.shared.purchasePackage(package) { (transaction, purchaserInfo, error, userCancelled) in
                    if userCancelled {
                        self.activityIndicatorView.stopAnimating()
                    }
                    
                    if purchaserInfo?.entitlements.active.first != nil {
                        delegate.nativeAds = []
                        self.dismissController()
                    }
                }
            } else {
                print("cant get package")
            }
        }
     }
    
    @objc func restorePurchase() {
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            if purchaserInfo?.entitlements.all["RemoveAds"]?.isActive == true {
                self.dismissController()
            } else {
                let alertController = UIAlertController(title: "Could not find purchase to restore.", message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    alertController.dismiss(animated: true, completion: nil)
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
     
    @objc func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
}
