//
//  YoutubeViewController.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/25/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import AppAuth

class YoutubeViewController: UIViewController {
    
    let segmentControl: CustomSegmentedControl = {
        let sc = CustomSegmentedControl(items: [])
        sc.insertSegment(withTitle: "Explore", at: 0, animated: false)
        sc.insertSegment(withTitle: "Following", at: 1, animated: false)
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    let segmentControlBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .twitchLightGray()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        return view
    }()
    
    let segmentBar: UIView = {
        let view = UIView()
        view.backgroundColor = .youtubeRed()
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var trendingController: YoutubeTrendingController = {
        let viewController = YoutubeTrendingController()
        return viewController
    }()
    
    lazy var followingController: YoutubeFollowingController = {
        let viewController = YoutubeFollowingController()
        return viewController
    }()
    
    private var observer: NSObjectProtocol?
    private var barWidthAnchor: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        add(asChildViewController: trendingController)
        segmentControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            self.moveSegmentBar(duration: 0.1)
        }
            
        setupSegmentControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if segmentControl.selectedSegmentIndex == 1 || segmentControl.selectedSegmentIndex == 2 {
            moveSegmentBar(duration: 0)
        }
    }
    
    private func setupSegmentControl() {
        view.addSubview(segmentControlBackground)
        segmentControlBackground.addSubview(segmentControl)
        segmentControlBackground.addSubview(segmentBar)
        
        segmentControlBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        segmentControlBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentControlBackground.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        segmentControlBackground.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        segmentControl.anchor(segmentControlBackground.topAnchor, left: segmentControlBackground.leftAnchor, bottom: segmentControlBackground.bottomAnchor, right: segmentControlBackground.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        segmentBar.bottomAnchor.constraint(equalTo: segmentControl.bottomAnchor).isActive = true
        segmentBar.leftAnchor.constraint(equalTo: segmentControl.leftAnchor).isActive = true
        segmentBar.heightAnchor.constraint(equalToConstant: 3).isActive = true
        barWidthAnchor = segmentBar.widthAnchor.constraint(equalTo: segmentControl.widthAnchor, multiplier: 1 / CGFloat(segmentControl.numberOfSegments))
        barWidthAnchor.isActive = true
        
        segmentControl.selectedSegmentIndex = 0
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    private func moveSegmentBar(duration: Double) {
        UIView.animate(withDuration: duration) {
            self.segmentBar.frame.origin.x = (self.segmentControl.frame.width / CGFloat(self.segmentControl.numberOfSegments)) * CGFloat(self.segmentControl.selectedSegmentIndex)
        }
    }
    
    @objc private func handleSegmentChange() {
        if segmentControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: followingController)
            add(asChildViewController: trendingController)
        } else {
            remove(asChildViewController: trendingController)
            add(asChildViewController: followingController)
        }
        
        view.bringSubviewToFront(segmentControlBackground)
        moveSegmentBar(duration: 0.3)
    }

    @objc func presentVideoController() {
        let videoController = YoutubeVideoController()
        present(videoController, animated: true, completion: nil)
    }

    deinit {
        print("Youtube Video Player Controller Deinit")
    }
}
