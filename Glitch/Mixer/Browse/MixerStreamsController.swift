//
//  MixerStreamsController.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/11/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class MixerStreamsController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 20, right: 0)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    var game: MixerGame?
    var streams: [MixerStream] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(MixerStreamsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(MixerStreamCell.self, forCellWithReuseIdentifier: cellId)
        
        setupViews()
        getStreams()
    }
    
    private func setupViews() {
        view.backgroundColor = .mixerDarkBlue()
        
        view.addSubview(collectionView)
        
        collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    private func getStreams() {
        guard let id = game?.id else { return }
        
        let url = "https://mixer.com/api/v1/types/\(id)/channels"
        
        let parameters = [
            "limit" : 99,
            "order" : "viewersCurrent:DESC"
            ] as [String : Any]
        
        MixerService.getStreams(url: url, parameters: parameters) { (streams) in
            self.streams = streams
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
