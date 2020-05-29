//
//  TwitterImageViewerController.swift
//  Glitch
//
//  Created by Jordan Bryant on 2/23/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TwitterImageViewerController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UICollectionViewDataSourcePrefetching {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        cv.isPagingEnabled = true
        cv.backgroundColor = UIColor.twitterMediumBlue().withAlphaComponent(0.95)
        cv.dataSource = self
        cv.delegate = self
        cv.prefetchDataSource = self
        cv.allowsMultipleSelection = false
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.bounces = false
        return cv
    }()
    
    var media: [TwitterMedia]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var imageColors: [Int : UIColor] = [:]
    
    let imageCache = NSCache<NSString, UIImage>()
    let cellId = "cellId"
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.95)
        
        collectionView.minimumZoomScale = 1.0
        collectionView.maximumZoomScale = 10.0
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler))
        view.addGestureRecognizer(pan)
        
        collectionView.register(TwitterImageCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(collectionView)
        
        collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TwitterImageCell
        guard let imageUrlString = media?[indexPath.item].url else { return cell }
        
        cell.imageView.image = nil
        cell.imageView.loadImageUsingUrlString(urlString: imageUrlString as NSString)
        
        if indexPath.item == 0 {
            if imageColors[0] == nil {
                let imageColor = cell.imageView.image?.getColors()?.secondary.withAlphaComponent(0.3)
                collectionView.backgroundColor = imageColor
                imageColors[0] = imageColor
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let imageUrlString = media?[indexPath.item].url else { return }
            
            AF.request(imageUrlString).responseImage { (response) in
                if case .success(let image) = response.result {
                    image.getColors { (colors) in
                        self.imageColors[indexPath.item] = colors?.secondary.withAlphaComponent(0.3)
                    }
                }
            }
        }
    }

    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)

        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            UIView.animate(withDuration: 0.3) {
                self.collectionView.backgroundColor = .clear
                self.view.backgroundColor = .clear
            }
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y > view.frame.height * 0.7 {
                self.dismiss(animated: true, completion: nil)
            } else {
                let pageWidth: CGFloat = collectionView.bounds.size.width
                let currentPage: Int = Int( floor( (collectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.collectionView.backgroundColor = self.imageColors[currentPage] ?? UIColor.twitterDarkBlue()
                    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.95)
                    
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = collectionView.bounds.size.width
        let currentPage: Int = Int( floor( (collectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)

        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.size.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x

        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        
        if media?.count == 2 {
            if percentageHorizontalOffset < 0.5 {
                collectionView.backgroundColor = fadeFromColor(fromColor: imageColors[currentPage] ?? UIColor.twitterDarkBlue().withAlphaComponent(0.3), toColor: imageColors[currentPage + 1] ?? UIColor.twitterDarkBlue().withAlphaComponent(0.3), withPercentage: percentageHorizontalOffset)
            } else {
                collectionView.backgroundColor = fadeFromColor(fromColor: imageColors[currentPage - 1] ?? UIColor.twitterDarkBlue().withAlphaComponent(0.3), toColor: imageColors[currentPage] ?? UIColor.twitterDarkBlue().withAlphaComponent(0.3), withPercentage: percentageHorizontalOffset)
            }
        } else if media?.count == 3 {
            if percentageHorizontalOffset < 0.5 {
                collectionView.backgroundColor = fadeFromColor(fromColor: imageColors[0] ?? UIColor.twitterDarkBlue().withAlphaComponent(0.3), toColor: imageColors[1] ?? UIColor.twitterDarkBlue().withAlphaComponent(0.3), withPercentage: percentageHorizontalOffset * 2)
            } else {
                collectionView.backgroundColor = fadeFromColor(fromColor: imageColors[1] ?? UIColor.twitterDarkBlue().withAlphaComponent(0.3), toColor: imageColors[2] ?? UIColor.twitterDarkBlue().withAlphaComponent(0.3), withPercentage: (percentageHorizontalOffset - 0.3) * 2)
            }
        } else if media?.count == 4 {
            if (percentageHorizontalOffset < 0.333333) {
                collectionView.backgroundColor = fadeFromColor(fromColor: imageColors[0] ?? UIColor.twitterDarkBlue().withAlphaComponent(0.3), toColor: imageColors[1] ?? UIColor.twitterDarkBlue().withAlphaComponent(0.3), withPercentage: percentageHorizontalOffset * 3)
            } else if (percentageHorizontalOffset >= 0.333333 && percentageHorizontalOffset < 0.666667) {
                collectionView.backgroundColor = fadeFromColor(fromColor: imageColors[1] ?? UIColor.twitterDarkBlue().withAlphaComponent(0.3), toColor: imageColors[2] ?? UIColor.twitterDarkBlue().withAlphaComponent(0.3), withPercentage: (percentageHorizontalOffset - 0.3333333) * 3)
            } else if (percentageHorizontalOffset >= 0.666667) {
                collectionView.backgroundColor = fadeFromColor(fromColor: imageColors[2] ?? UIColor.twitterDarkBlue().withAlphaComponent(0.3), toColor: imageColors[3] ?? UIColor.twitterDarkBlue().withAlphaComponent(0.3), withPercentage: (percentageHorizontalOffset - 0.6666667) * 3)
            }
        }
        
    }

    func fadeFromColor(fromColor: UIColor, toColor: UIColor, withPercentage: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0.0
        var fromGreen: CGFloat = 0.0
        var fromBlue: CGFloat = 0.0
        var fromAlpha: CGFloat = 0.0

        // Get the RGBA values from the colours
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)

        var toRed: CGFloat = 0.0
        var toGreen: CGFloat = 0.0
        var toBlue: CGFloat = 0.0
        var toAlpha: CGFloat = 0.0

        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)

        // Calculate the actual RGBA values of the fade colour
        let red = (toRed - fromRed) * withPercentage + fromRed;
        let green = (toGreen - fromGreen) * withPercentage + fromGreen;
        let blue = (toBlue - fromBlue) * withPercentage + fromBlue;
        let alpha = (toAlpha - fromAlpha) * withPercentage + fromAlpha;

        // Return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

class TwitterImageCell: UICollectionViewCell {
    
    let imageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        
        imageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
