//
//  NativeAdTableViewCell.swift
//  Glitch
//
//  Created by Jordan Bryant on 4/27/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NativeAdTableViewCell: UITableViewCell {
    
    let adView: GADUnifiedNativeAdView = {
        let view = GADUnifiedNativeAdView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.5)
        label.textColor = .white
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let adLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Ad"
        label.font = .systemFont(ofSize: 17.5)
        label.layer.masksToBounds = true
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let advertiserNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.5)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width * 0.6
        label.sizeToFit()
        return label
    }()
    
    let callToActionButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 3
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    var nativeAd: GADUnifiedNativeAd? {
        didSet {
            headlineLabel.text = nativeAd?.headline
            adView.nativeAd = nativeAd
            headlineLabel.text = nativeAd?.headline
            advertiserNameLabel.text = nativeAd?.advertiser
            callToActionButton.setTitle(nativeAd?.callToAction, for: .normal)
            iconImageView.image = nativeAd?.icon?.image
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        selectionStyle = .none
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        
        backgroundColor = .clear
        
        adView.advertiserView = advertiserNameLabel
        adView.callToActionView = callToActionButton
        adView.headlineView = headlineLabel
        adView.iconView = iconImageView
        
        setupViews()
    }
    
    private func setupViews() {
        addSubview(adView)
        
        adView.addSubview(iconImageView)
        adView.addSubview(headlineLabel)
        adView.addSubview(adLabel)
        adView.addSubview(advertiserNameLabel)
        adView.addSubview(callToActionButton)
        
        adView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        headlineLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor).isActive = true
        headlineLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10).isActive = true
        headlineLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        headlineLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        adLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 5).isActive = true
        adLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10).isActive = true
        adLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        adLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        advertiserNameLabel.leftAnchor.constraint(equalTo: adLabel.rightAnchor, constant: 10).isActive = true
        advertiserNameLabel.centerYAnchor.constraint(equalTo: adLabel.centerYAnchor).isActive = true
        
        callToActionButton.anchor(adLabel.bottomAnchor, left: iconImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
