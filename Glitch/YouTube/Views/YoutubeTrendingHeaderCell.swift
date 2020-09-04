//
//  YoutubeTrendingHeaderCell.swift
//  Glitch
//
//  Created by Jordan Bryant on 9/1/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class YoutubeTrendingHeaderCell: UICollectionViewCell {
    
    let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.returnKeyType = .search
        search.backgroundImage = UIImage()
        search.searchBarStyle = .minimal
        search.searchTextField.backgroundColor = .youtubeGray()
        search.searchTextField.textColor = .white
        search.placeholder = "Search Videos"
        search.tintColor = .white
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    private func setupCell() {
        addSubview(searchBar)
        
        searchBar.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        searchBar.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 5).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchBar.widthAnchor.constraint(equalToConstant: frame.width - 20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
