//
//  EsportsFollowingContainerCell.swift
//  Glitch
//
//  Created by Jordan Bryant on 7/1/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import Firebase

class EsportsFollowingContainerCell: UITableViewCell,  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 25)
        cv.backgroundColor = .twitchGray()
        cv.dataSource = self
        cv.delegate = self
        cv.allowsMultipleSelection = true
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let addNewFollowButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 40)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .twitchLightGray()
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    let cellId = "cellId"
    
    var teams: [EsportsTeam] = []
    
    var rootViewController: EsportsFollowingViewController?
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
                             
        collectionView.register(EsportsFollowingCell.self, forCellWithReuseIdentifier: cellId)
        addNewFollowButton.addTarget(self, action: #selector(presentFollowTeamController), for: .touchUpInside)
        
        addSubview(collectionView)
        addSubview(addNewFollowButton)
        
        addNewFollowButton.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 110)
        collectionView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: addNewFollowButton.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 110)
        
        observeTeams()
    }
    
    private func observeTeams() {
        guard let id = UserDefaults.standard.string(forKey: "userId") else { return }
        let ref = Database.database().reference().child("users").child(id).child("esports").child("following")
        
        ref.observe(.value) { (snapshot) in
            guard let followingDict = snapshot.value as? NSDictionary else { return }
            guard let ids = followingDict.allKeys as? [String] else { return }
            
            self.teams = []
            
            for id in ids {
                guard let teamDict = followingDict[id] as? NSDictionary else { return }
                guard let name = teamDict["name"] as? String else { return }
                guard let id = teamDict["id"] as? Int else { return }
                guard let imageUrl = teamDict["imageUrl"] as? String else { return }
                guard let game = teamDict["game"] as? String else { return }
                
                let team = EsportsTeam(name: name, picUrl: imageUrl, id: id, score: 0, game: game)
                self.teams.append(team)
                self.rootViewController?.teamIdNamesDict[id] = name
            }
            
            self.teams = self.teams.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EsportsFollowingCell
        let team = teams[indexPath.item]
        cell.team = team
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.twitchLightGray()
        cell.selectedBackgroundView = selectedView
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var indexPaths = collectionView.indexPathsForSelectedItems
        if let index = indexPaths?.firstIndex(of: indexPath) {
            indexPaths?.remove(at: index)
            
            for selectedIndexPath in indexPaths ?? [] {
                collectionView.deselectItem(at: selectedIndexPath, animated: false)
            }
        }
        
        
        rootViewController?.selectedTeamId = teams[indexPath.item].id
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        rootViewController?.selectedTeamId = nil
    }
    
    @objc private func presentFollowTeamController() {
        rootViewController?.present(FollowTeamController(), animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: frame.height)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
