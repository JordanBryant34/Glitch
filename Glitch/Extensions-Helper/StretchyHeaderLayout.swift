//
//  StretchyHeaderLayout.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/31/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class StretchyHeaderLayout: UICollectionViewFlowLayout {
        
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
       
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        layoutAttributes?.forEach({ (attributes) in
            guard let collectionView = collectionView else { return }
            
            let contentOffsetY = collectionView.contentOffset.y
            let width = collectionView.frame.width
            let height = attributes.frame.height - contentOffsetY
            
            if contentOffsetY > 0 {
                return
            }
            
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                attributes.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
            }
        })
        
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
