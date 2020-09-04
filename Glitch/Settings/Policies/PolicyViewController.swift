//
//  PolicyViewController.swift
//  Glitch
//
//  Created by Jordan Bryant on 6/10/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import WebKit

class PolicyViewController: UIViewController {
    
    let policyWebView: WKWebView = {
        let wv = WKWebView()
        wv.translatesAutoresizingMaskIntoConstraints = false
        wv.scrollView.bounces = false
        wv.isOpaque = false
        wv.scrollView.pinchGestureRecognizer?.isEnabled = false
        wv.scrollView.showsHorizontalScrollIndicator = false
        wv.isHidden = false
        return wv
    }()
    
    let source: String = "var meta = document.createElement('meta');" +
                         "meta.name = 'viewport';" +
                         "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
                         "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPolicy()
        setupViews()
    }
    
    private func setupPolicy() {
        let policyURL = URL(string: "https://docs.google.com/document/d/e/2PACX-1vSWzayFdHRUjFJksbkrXXlU9ZjZJgB_rbDBPYcbdQvzWsONbktaYsbTb_VYBD3v_W02Qm_dZOqKqovJ/pub")!
        policyWebView.load(URLRequest(url: policyURL))
        
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        policyWebView.configuration.userContentController.addUserScript(script)
        policyWebView.scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupViews() {
        view.addSubview(policyWebView)
        
        policyWebView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
