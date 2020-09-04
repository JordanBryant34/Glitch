//
//  MatchTableViewCell.swift
//  Glitch
//
//  Created by Jordan Bryant on 6/26/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {
        
    let gameLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        imageView.image = UIImage(named: "noTeamImage")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let awayTeamImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.image = UIImage(named: "noTeamImage")
        imageView.contentMode = .scaleAspectFit
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
    
    var match: EsportsMatch? {
        didSet {
            setData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        
        backgroundColor = .twitchLightGray()
        
        setupCell()
    }
    
    private func setupCell() {
        addSubview(gameLogoImageView)
        addSubview(infoLabel)
        addSubview(homeTeamImageView)
        addSubview(awayTeamImageView)
        addSubview(homeTeamNameLabel)
        addSubview(awayTeamNameLabel)
        addSubview(homeTeamScoreLabel)
        addSubview(awayTeamScoreLabel)
        
        gameLogoImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        gameLogoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        gameLogoImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        gameLogoImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        infoLabel.anchor(gameLogoImageView.topAnchor, left: gameLogoImageView.rightAnchor, bottom: gameLogoImageView.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        homeTeamImageView.anchor(gameLogoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 45, heightConstant: 45)
        awayTeamImageView.anchor(homeTeamImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 45, heightConstant: 45)
        homeTeamNameLabel.anchor(homeTeamImageView.topAnchor, left: homeTeamImageView.rightAnchor, bottom: homeTeamImageView.bottomAnchor, right: homeTeamScoreLabel.leftAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        awayTeamNameLabel.anchor(awayTeamImageView.topAnchor, left: awayTeamImageView.rightAnchor, bottom: awayTeamImageView.bottomAnchor, right: awayTeamScoreLabel.leftAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        homeTeamScoreLabel.anchor(homeTeamNameLabel.topAnchor, left: nil, bottom: homeTeamNameLabel.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 15, heightConstant: 0)
        awayTeamScoreLabel.anchor(awayTeamNameLabel.topAnchor, left: nil, bottom: awayTeamNameLabel.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 15, heightConstant: 0)
    }

    private func setData() {
        guard let match = self.match else { return }
        var gamePosition = 1
        
        homeTeamImageView.image = UIImage(named: "noTeamImage")
        awayTeamImageView.image = UIImage(named: "noTeamImage")
        homeTeamNameLabel.textColor = .white
        homeTeamScoreLabel.textColor = .white
        awayTeamNameLabel.textColor = .white
        awayTeamScoreLabel.textColor = .white
        
        if match.opponents.count == 2 {
            let homeTeam = match.opponents[0]
            let awayTeam = match.opponents[1]
            
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
            
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d h:mm z"
        let scheduledDate = DateFormatter.iso8601.date(from: match.scheduledTime) ?? Date()
        let presentableDate = formatter.string(from: scheduledDate)
        
        infoLabel.text = "\(presentableDate) • \(match.leagueName)"
        
        if match.status == "finished" {
            if match.opponents[0].score > match.opponents[1].score {
                awayTeamNameLabel.textColor = .twitchGrayTextColor()
                awayTeamScoreLabel.textColor = .twitchGrayTextColor()
            } else if match.opponents[1].score > match.opponents[0].score {
                homeTeamNameLabel.textColor = .twitchGrayTextColor()
                homeTeamScoreLabel.textColor = .twitchGrayTextColor()
            }
        }
        
        gameLogoImageView.image = UIImage(named: "\(match.gameName)_Logo")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
