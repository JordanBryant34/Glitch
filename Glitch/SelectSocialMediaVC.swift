//
//  SelectSocialMediaVC.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/25/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class SelectSocialMediaVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.allowsMultipleSelection = false
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 20, g: 20, b: 20)
        return view
    }()
    
    let logos = [UIImage(named: "glitchLogo"), UIImage(named: "twitchLogo"), UIImage(named: "youtubeLogo"), UIImage(named: "twitterLogo"), UIImage(named: "esportsLogo"), UIImage(named: "settingsIcon")]
    let cellId = "cellId"
    
    var containerVC: ContainerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        collectionView.register(SocialMediaCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(collectionView)
        view.addSubview(separatorView)
        
        collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        separatorView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return logos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SocialMediaCell
        
        cell.imageView.image = logos[indexPath.item]
        
        switch indexPath.item {
        case 1:
            cell.selectedView.backgroundColor = .twitchPurple()
        case 2:
            cell.selectedView.backgroundColor = .youtubeRed()
        case 3:
            cell.selectedView.backgroundColor = .twitterLightBlue()
        case 4:
            cell.selectedView.backgroundColor = .esportsBlue()
        case 5:
            cell.selectedView.backgroundColor = .twitchGrayTextColor()
        default:
            cell.selectedView.backgroundColor = .white
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 20) / CGFloat(logos.count), height: (view.frame.width - 20) / CGFloat(logos.count))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        changePage(index: indexPath.item)
        
        switch indexPath.item {
        case 0:
            changeColors(newBackgroundColor: .twitchGray(), newHeaderColor: .twitchLightGray())
        case 1:
            changeColors(newBackgroundColor: .twitchGray(), newHeaderColor: .twitchGray())
        case 2:
            changeColors(newBackgroundColor: .youtubeBlack(), newHeaderColor: .youtubeBlack())
        case 3:
            changeColors(newBackgroundColor: .twitterMediumBlue(), newHeaderColor: .twitterDarkBlue())
        case 4:
            changeColors(newBackgroundColor: .twitchGray(), newHeaderColor: .twitchLightGray())
        case 5:
            changeColors(newBackgroundColor: .twitchGray(), newHeaderColor: .twitchLightGray())
        default:
            print("Default")
        }
    }
    
    func changeColors(newBackgroundColor: UIColor, newHeaderColor: UIColor) {
        if let container = containerVC {
            UIView.animate(withDuration: 0.3) {
                container.view.backgroundColor = newBackgroundColor
                container.headerView.backgroundColor = newHeaderColor
            }
        }
    }
    
    func changePage(index: Int) {
        if let currentIndex = containerVC?.currentIndex, let containerVC = containerVC {
            if index < currentIndex {
                containerVC.pageController.setViewControllers([containerVC.pageController.subViewControllers[index]], direction: .reverse, animated: true, completion: nil)
            } else {
                containerVC.pageController.setViewControllers([containerVC.pageController.subViewControllers[index]], direction: .forward, animated: true, completion: nil)
            }
            
            containerVC.currentIndex = index
        }
    }
}

