//
//  ContainerViewController.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/25/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import Firebase

class ContainerViewController: UIPageViewController {
    
    lazy var selectMediaVC: SelectSocialMediaVC = {
        let controller = SelectSocialMediaVC()
        controller.containerVC = self
        return controller
    }()
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitchLightGray()
        return view
    }()
    
    lazy var pageController: PageViewController = {
        let pageController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.view.frame = self.view.bounds
        return pageController
    }()
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .twitchGray()
        
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(headerView)
        view.addSubview(selectMediaVC.view)
        
        addChild(pageController)
        pageController.didMove(toParent: self)
        
        view.addSubview(pageController.view)
        
        selectMediaVC.view.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 75)
        pageController.view.anchor(selectMediaVC.view.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        headerView.anchor(view.topAnchor, left: view.leftAnchor, bottom: selectMediaVC.view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {}
    
}
