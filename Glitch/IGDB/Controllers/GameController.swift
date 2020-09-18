//
//  GameController.swift
//  Glitch
//
//  Created by Jordan Bryant on 9/12/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import Firebase

class GameController {
    
    static let shared = GameController()
    
    private var apiKey: String?
    private var baseUrl = "https://api-v3.igdb.com"
    
    func getScreenshot(withName name: String, completion: @escaping (_ screenshotUrl: String?) ->()) {
        if let imageUrl = UserDefaults.standard.string(forKey: "\(name)_image_url") {
            if let url = URL(string: imageUrl), UIApplication.shared.canOpenURL(url) == true {
                completion(imageUrl)
            } else {
                UserDefaults.standard.removeObject(forKey: "\(name)_image_url")
                completion(nil)
            }
        } else {
            guard let apiKey = apiKey else { completion(nil); return }
            
            let url = URL(string: "\(baseUrl)/games/")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(apiKey, forHTTPHeaderField: "user-key")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = "fields artworks.image_id;search \"\(name)\";limit 1;".data(using: .utf8)
                
            AF.request(request).responseJSON { (response) in
                guard let value = response.value else { completion(nil); return }
                let artworkId = JSON(value)[0]["artworks"][0]["image_id"].stringValue
                            
                if !artworkId.isEmpty {
                    let imageUrl = "https://images.igdb.com/igdb/image/upload/t_screenshot_big/\(artworkId).jpg"
                    UserDefaults.standard.set(imageUrl, forKey: "\(name)_image_url")
                    
                    completion(imageUrl)
                } else {
                    let ref = Database.database().reference().child("igdb").child("missingGameArt").child(name)
                    
                    ref.observeSingleEvent(of: .value) { (snapshot) in
                        if let imageUrl = snapshot.value as? String {
                            completion(imageUrl)
                        } else {
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    func storeAPIKey() {
        if let apiKey = UserDefaults.standard.string(forKey: "igdbAPIKey") {
            self.apiKey = apiKey
        } else {
            let ref = Database.database().reference().child("igdb").child("apiKey")
            ref.observeSingleEvent(of: .value) { (snapshot) in
                guard let value = snapshot.value as? String else { return }
                
                UserDefaults.standard.set(value, forKey: "igdbAPIKey")
                self.apiKey = value
            }
        }
    }
}
