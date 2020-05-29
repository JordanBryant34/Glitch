//
//  CustomAnimator.swift
//  Glitch
//
//  Created by Jordan Bryant on 4/23/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import CRRefresh
import NVActivityIndicatorView

class CustomAnimator: UIView, CRRefreshProtocol {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Pull to refresh..."
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: UIColor(r: 60, g: 151, b: 138), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = false
        return indicator
    }()
    
    var isRefreshing: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        view.addSubview(activityIndicator)
        view.addSubview(label)
        
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 45).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var view: UIView = {
        let view = UIView()
        return view
    }()
    
    var insets: UIEdgeInsets = .zero
    
    var trigger: CGFloat = 65.0
    
    var execute: CGFloat = 65.0
    
    var endDelay: CGFloat = 1.5
    
    var hold: CGFloat = 65.0
    
    func refreshBegin(view: CRRefreshComponent) {
        isRefreshing = true
        label.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func refreshEnd(view: CRRefreshComponent, finish: Bool) {
        activityIndicator.stopAnimating()
        
        isRefreshing = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.label.isHidden = false
        }
    }
    
    func refreshWillEnd(view: CRRefreshComponent) {}
    func refresh(view: CRRefreshComponent, progressDidChange progress: CGFloat) {}
    func refresh(view: CRRefreshComponent, stateDidChange state: CRRefreshState) {}
    
    
}
