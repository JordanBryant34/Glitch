//
//  OboardingPageViewController.swift
//  Glitch
//
//  Created by Jordan Bryant on 7/22/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate {
    
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = UIColor.twitchGrayTextColor().withAlphaComponent(0.5)
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    var subViewControllers: [UIViewController] = []
    var currentIndex = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        delegate = self
        
        let welcomeController = WelcomeViewController()
        welcomeController.pageViewController = self
        subViewControllers.append(welcomeController)
        
        let linkAccountsController = LinkAccountsViewController()
        linkAccountsController.pageViewController = self
        subViewControllers.append(linkAccountsController)
        
        let youtubersController = YoutubeOnboardingController()
        youtubersController.pageViewController = self
        subViewControllers.append(youtubersController)
        
        let esportsController = EsportsOnboardingController()
        esportsController.pageViewController = self
        subViewControllers.append(esportsController)
        
        subViewControllers.append(SubscriptionViewController())
        
        setViewControllers([subViewControllers[0]], direction: .forward, animated: true, completion: nil)
        
        pageControl.numberOfPages = subViewControllers.count
        view.addSubview(pageControl)
        
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        pageControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        view.setGradientBackground(colorOne: .twitchLightGray(), colorTwo: .twitchGray())
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        
        if currentIndex <= 0 {
            return nil
        }
        
        return subViewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        
        if currentIndex >= (subViewControllers.count - 1) {
            return nil
        }
        
        return subViewControllers[currentIndex + 1]
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setViewControllers([subViewControllers[0]], direction: .forward, animated: true, completion: nil)
    }
    
    func changeToNextPage() {
        setViewControllers([subViewControllers[currentIndex + 1]], direction: .forward, animated: true, completion: nil)
        pageControl.currentPage = currentIndex + 1
        currentIndex += 1
    }
    
    func changeToPreviousPage() {
        setViewControllers([subViewControllers[currentIndex - 1]], direction: .reverse, animated: true, completion: nil)
        pageControl.currentPage = currentIndex - 1
        currentIndex -= 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

