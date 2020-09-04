//
//  ReferralViewController.swift
//  Glitch
//
//  Created by Jordan Bryant on 7/25/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class ReferralViewController: UIViewController, UITextFieldDelegate {
    
    let referralLabel: UILabel = {
        let label = UILabel()
        label.text = "Let us know who sent you"
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
        label.numberOfLines = 3
        label.textAlignment = .center
        label.text = "If you have a referral code, enter that code here and then hit finish."
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
        button.setTitle("Finish", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22.5)
        button.setTitle("", for: .disabled)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let attributedString = NSAttributedString(string: NSLocalizedString("Cancel", comment: ""), attributes:[
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17.5),
            NSAttributedString.Key.foregroundColor : UIColor.twitchGrayTextColor(),
            NSAttributedString.Key.underlineStyle : 1.0
        ])
        button.setAttributedTitle(attributedString, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let textFieldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .twitchLightGray()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let creatorReferralLabel: UILabel = {
        let label = UILabel()
        label.text = "Referral code:"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 17.5)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Referral code..."
        tf.backgroundColor = .clear
        return tf
    }()
    
    let invalidReferralLabel: UILabel = {
        let label = UILabel()
        label.text = "This referral code does not exist. Please try again or continue without entering a referral code."
        label.numberOfLines = 3
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor(r: 255, g: 83, b: 73)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .white, padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var parentController: SubscriptionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setupViews()
    }
    
    private func setupViews() {
        view.setGradientBackground(colorOne: .twitchLightGray(), colorTwo: .twitchGray())
        
        view.addSubview(referralLabel)
        view.addSubview(subLabel)
        view.addSubview(continueButton)
        view.addSubview(backButton)
        view.addSubview(textFieldContainer)
        view.addSubview(creatorReferralLabel)
        view.addSubview(invalidReferralLabel)
        
        textFieldContainer.addSubview(textField)
        
        continueButton.addSubview(activityIndicator)
        
        referralLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        referralLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        subLabel.anchor(referralLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 75)
        
        continueButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 60, bottomConstant: view.frame.height * 0.175, rightConstant: 60, widthConstant: 0, heightConstant: 65)
        
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 15).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        textFieldContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textFieldContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        textFieldContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        textFieldContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        creatorReferralLabel.leftAnchor.constraint(equalTo: textFieldContainer.leftAnchor).isActive = true
        creatorReferralLabel.bottomAnchor.constraint(equalTo: textFieldContainer.topAnchor, constant: -5).isActive = true
        
        textField.anchor(textFieldContainer.topAnchor, left: textFieldContainer.leftAnchor, bottom: textFieldContainer.bottomAnchor, right: textFieldContainer.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        invalidReferralLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        invalidReferralLabel.topAnchor.constraint(equalTo: textFieldContainer.bottomAnchor, constant: 7.5).isActive = true
        invalidReferralLabel.widthAnchor.constraint(equalTo: textFieldContainer.widthAnchor).isActive = true
        invalidReferralLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: continueButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc private func handleContinue() {
        if let referralCode = textField.text?.lowercased() {
            let ref = Database.database().reference().child("subscriptions").child("referralCodes").child(referralCode)
            
            ref.observeSingleEvent(of: .value) { (snapshot) in
                guard let value = snapshot.value as? String else {
                    self.invalidReferralLabel.isHidden = false
                    return
                }
                
                self.invalidReferralLabel.isHidden = true
                
                if value == "free" {
                    UserDefaults.standard.set(referralCode, forKey: "referralCode")
                    
                    self.dismiss(animated: true) {
                        self.parentController?.dismissController()
                    }
                }
            }
        }
    }
    
    @objc private func handleBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
