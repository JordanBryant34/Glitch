//
//  AppDelegate.swift
//  Glitch
//
//  Created by Jordan Bryant on 2/12/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import OAuthSwift
import AppAuth
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GADUnifiedNativeAdLoaderDelegate, GADRewardBasedVideoAdDelegate {
    
    var window: UIWindow?
    var currentAuthorizationFlow: OIDExternalUserAgentSession?
    var urlToHandle: URL?
    
    let rootViewController = ContainerViewController()
    
    private var adLoader: GADAdLoader!
    var nativeAds: [GADUnifiedNativeAd] = []
    var adLoadAttempts = 0
    var rewardAdInstance = GADRewardBasedVideoAd.sharedInstance()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .dark

        
        window?.rootViewController = rootViewController
        
        getNativeAds()
        getRewardAds()
        
        checkId()
                
        return true
    }
    
    private func getRewardAds() {
        rewardAdInstance.delegate = self
        rewardAdInstance.load(GADRequest(), withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
    }
    
    private func getNativeAds() {
        let adUnitID = "ca-app-pub-3940256099942544/3986624511"
        
        let options = GADMultipleAdsAdLoaderOptions()
        options.numberOfAds = 5
                
        adLoader = GADAdLoader(adUnitID: adUnitID,
                               rootViewController: rootViewController,
                               adTypes: [.unifiedNative],
                               options: [options])
        
        adLoader.delegate = self
        
        adLoader.load(GADRequest())
    }
    
    private func checkId() {
        if let id = UserDefaults.standard.string(forKey: "userId") {
            let db = Database.database().reference().child("users").child(id).child("lastSeen")
            db.setValue(Date().timeIntervalSince1970)
        } else {
            let newId = HelperFunctions.getRandomAlphanumericString(length: 25)
            let db = Database.database().reference().child("users").child(newId).child("lastSeen")
            UserDefaults.standard.set(newId, forKey: "userId")
            db.setValue(Date().timeIntervalSince1970)
        }
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        if nativeAd.icon?.image != nil && nativeAd.images != nil {
            nativeAds.append(nativeAd)
        }
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("failed to load native ad")
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        if nativeAds.count < 25 && adLoadAttempts <= 6 {
            adLoader.load(GADRequest())
        }
        
        adLoadAttempts += 1
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        UserDefaults.standard.set(0, forKey: "contentWatchedCount")
        rewardAdInstance = GADRewardBasedVideoAd.sharedInstance()
        rewardAdInstance.load(GADRequest(), withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        UserDefaults.standard.set(0, forKey: "contentWatchedCount")
        rewardAdInstance = GADRewardBasedVideoAd.sharedInstance()
        rewardAdInstance.load(GADRequest(), withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        TwitchService.validateToken { (status) in
            print("Twitch Token Status: \(status)")
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Sends the URL to the current authorization flow (if any) which will
        // process it if it relates to an authorization response.
        if let authorizationFlow = self.currentAuthorizationFlow, authorizationFlow.resumeExternalUserAgentFlow(with: url) {
            self.currentAuthorizationFlow = nil
            return true
        }
        
        if (url.host == "mixer.player3studios.glitch.com") {
            OAuthSwift.handle(url: url)
        }

        if url.scheme == "player3Glitch" {
            OAuthSwift.handle(url: url)
        }
        
        if url.host == "twitter" {
            OAuthSwift.handle(url: url)
        }
        
        if url.host == "twitch" {
            OAuthSwift.handle(url: url)
        }
    
        // Your additional URL handling (if any)
        urlToHandle = url

        return false
    }
}

