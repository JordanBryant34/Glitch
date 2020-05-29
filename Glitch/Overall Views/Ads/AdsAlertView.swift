//
//  AdsAlertView.swift
//  Glitch
//
//  Created by Jordan Bryant on 4/24/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class AdsAlertView: UIView {
    
    let alertView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.5)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var isShown = false
    var alertViewCenterYConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isHidden = true
        
        addSubview(alertView)
        
        alertView.addSubview(imageView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(detailsLabel)
        alertView.addSubview(confirmButton)
        alertView.addSubview(cancelButton)
        
        alertView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        alertView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 60).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        alertView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -15).isActive = true
        alertView.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 15).isActive = true
        alertViewCenterYConstraint = alertView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height)
        alertViewCenterYConstraint?.isActive = true
        
        imageView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 15).isActive = true
        imageView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -5).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 80).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        detailsLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor).isActive = true
        detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        detailsLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 80).isActive = true
        detailsLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        confirmButton.leftAnchor.constraint(equalTo: detailsLabel.centerXAnchor, constant: 7.5).isActive = true
        confirmButton.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -15).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        confirmButton.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 20).isActive = true
        
        cancelButton.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 15).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: alertView.centerXAnchor, constant: -7.5).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        cancelButton.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 20).isActive = true
    }
    
    func show() {
        isShown = true
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.alertViewCenterYConstraint?.constant = 0
            self.layoutIfNeeded()
        }
        
        self.isHidden = false
    }
    
    func hide() {
        isShown = false
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.alertViewCenterYConstraint?.constant = UIScreen.main.bounds.height
            self.layoutIfNeeded()
        }) { (completed) in
            self.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
