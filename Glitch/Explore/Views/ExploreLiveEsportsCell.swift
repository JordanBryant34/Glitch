//
//  ExploreLiveEsportsCell.swift
//  Glitch
//
//  Created by Jordan Bryant on 7/7/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class ExploreLiveEsportsCell: UICollectionViewCell {
    
    let gameLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let liveLabel: UILabel = {
        let label = UILabel()
        label.text = "LIVE"
        label.backgroundColor = .esportsBlue()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 3
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .twitchGrayTextColor()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let homeTeamImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        return imageView
    }()
    
    let awayTeamImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        return imageView
    }()
    
    let homeTeamNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17.5)
        return label
    }()
    
    let awayTeamNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17.5)
        return label
    }()
    
    let homeTeamScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .right
        return label
    }()
    
    let awayTeamScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .right
        return label
    }()
    
    let watchButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .right
        button.setTitle("Watch Match", for: .normal)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = .systemFont(ofSize: 17.5)
        button.setTitleColor(.esportsBlue(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var match: EsportsMatch? {
        didSet {
            setData()
        }
    }
    
    var rootViewController: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        watchButton.addTarget(self, action: #selector(presentStream), for: .touchUpInside)
        
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = .twitchLightGray()
        layer.cornerRadius = 5
        layer.borderColor = UIColor.esportsBlue().cgColor
        layer.borderWidth = 1
        clipsToBounds = true
        
        addSubview(gameLogoImageView)
        addSubview(liveLabel)
        addSubview(infoLabel)
        addSubview(homeTeamImageView)
        addSubview(awayTeamImageView)
        addSubview(homeTeamNameLabel)
        addSubview(awayTeamNameLabel)
        addSubview(homeTeamScoreLabel)
        addSubview(awayTeamScoreLabel)
        addSubview(watchButton)
        
        gameLogoImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        gameLogoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        gameLogoImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        gameLogoImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        liveLabel.anchor(gameLogoImageView.topAnchor, left: gameLogoImageView.rightAnchor, bottom: gameLogoImageView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 45, heightConstant: 0)
        infoLabel.anchor(liveLabel.topAnchor, left: liveLabel.rightAnchor, bottom: liveLabel.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        homeTeamImageView.anchor(gameLogoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 45, heightConstant: 45)
        awayTeamImageView.anchor(homeTeamImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 45, heightConstant: 45)
        homeTeamNameLabel.anchor(homeTeamImageView.topAnchor, left: homeTeamImageView.rightAnchor, bottom: homeTeamImageView.bottomAnchor, right: homeTeamScoreLabel.leftAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        awayTeamNameLabel.anchor(awayTeamImageView.topAnchor, left: awayTeamImageView.rightAnchor, bottom: awayTeamImageView.bottomAnchor, right: awayTeamScoreLabel.leftAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        homeTeamScoreLabel.anchor(homeTeamNameLabel.topAnchor, left: nil, bottom: homeTeamNameLabel.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 15, heightConstant: 0)
        awayTeamScoreLabel.anchor(awayTeamNameLabel.topAnchor, left: nil, bottom: awayTeamNameLabel.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 15, heightConstant: 0)
        
        watchButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        watchButton.topAnchor.constraint(equalTo: awayTeamImageView.bottomAnchor).isActive = true
        watchButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        watchButton.widthAnchor.constraint(equalToConstant: 175).isActive = true
    }
    
    private func setData() {
        guard let match = self.match else { return }
        var gamePosition = 1
        
        if match.liveStreamUrl.contains("https://www.twitch.tv/") {
            watchButton.isHidden = false
        } else {
            watchButton.isHidden = true
        }
        
        if match.opponents.count == 2 {
            let homeTeam = match.opponents[0]
            let awayTeam = match.opponents[1]
            
            homeTeamImageView.image = UIImage(named: "noTeamImage")
            awayTeamImageView.image = UIImage(named: "noTeamImage")
            
            if let homeTeamUrl = URL(string: homeTeam.picUrl) {
                if let image = HelperFunctions.getImageFromFile(pathComponent: "\(homeTeam.name).png") {
                    homeTeamImageView.image = HelperFunctions.resizeImage(image: image, newSize: CGSize(width: 45, height: 45))
                } else {
                    ImageService.getImage(withURL: homeTeamUrl) { (image) in
                        if let image = image {
                            self.homeTeamImageView.image = HelperFunctions.resizeImage(image: image, newSize: CGSize(width: 45, height: 45))
                            HelperFunctions.storePngToFile(image: image, pathComponent: "\(homeTeam.name).png", size: CGSize(width: 100, height: 100))
                        }
                    }
                }
            }
            if homeTeam.picUrl == "" {
                homeTeamImageView.image = UIImage(named: "noTeamImage")
            }
            
            homeTeamNameLabel.text = homeTeam.name
            homeTeamScoreLabel.text = "\(homeTeam.score)"
            gamePosition += homeTeam.score
            
            if let awayTeamUrl = URL(string: awayTeam.picUrl) {
                if let image = HelperFunctions.getImageFromFile(pathComponent: "\(awayTeam.name).png") {
                    awayTeamImageView.image = HelperFunctions.resizeImage(image: image, newSize: CGSize(width: 45, height: 45))
                } else {
                    ImageService.getImage(withURL: awayTeamUrl) { (image) in
                        if let image = image {
                            self.awayTeamImageView.image = HelperFunctions.resizeImage(image: image, newSize: CGSize(width: 45, height: 45))
                            HelperFunctions.storePngToFile(image: image, pathComponent: "\(awayTeam.name).png", size: CGSize(width: 100, height: 100))
                        }
                    }
                }
            }
            if awayTeam.picUrl == "" {
                awayTeamImageView.image = UIImage(named: "noTeamImage")
            }
            
            awayTeamNameLabel.text = awayTeam.name
            awayTeamScoreLabel.text = "\(awayTeam.score)"
            gamePosition += awayTeam.score
        }
        
        if match.numberOfGames == 1 {
            infoLabel.text = "Single game • \(match.leagueName)"
        } else if match.matchType == "best_of" {
            infoLabel.text = "Game \(gamePosition) of \(match.numberOfGames) • \(match.leagueName)"
        } else if match.matchType == "first_to" {
            infoLabel.text = "First to \(match.numberOfGames) • \(match.leagueName)"
        } else {
            infoLabel.text = match.leagueName
        }
        
        gameLogoImageView.image = UIImage(named: "\(match.gameName)_Logo")
    }
    
    @objc private func presentStream() {
        if let match = self.match {
            if match.liveStreamUrl.contains("https://www.twitch.tv/") {
                let streamerName = match.liveStreamUrl.replacingOccurrences(of: "https://www.twitch.tv/", with: "")
                let streamController = TwitchStreamController()
                streamController.streamerName = streamerName
                streamController.modalPresentationStyle = .overFullScreen
                rootViewController?.present(streamController, animated: true, completion: nil)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

