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
import Purchases
import Flurry_iOS_SDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GADUnifiedNativeAdLoaderDelegate, GADRewardBasedVideoAdDelegate, PurchasesDelegate {
    
    var window: UIWindow?
    var currentAuthorizationFlow: OIDExternalUserAgentSession?
    var urlToHandle: URL?
    
    let rootViewController = ContainerViewController()
    
    private var adLoader: GADAdLoader!
    var nativeAds: [GADUnifiedNativeAd] = []
    var adLoadAttempts = 0
    var rewardAdInstance = GADRewardBasedVideoAd.sharedInstance()
    
    //Test ID's for Google Admob
    let rewardAdId = "ca-app-pub-3940256099942544/5224354917"
    let nativeAdId = "ca-app-pub-3940256099942544/2247696110"
    
    //Actual ID's for Google Admob
//    let rewardAdId = "ca-app-pub-7879710565936793/2226085464"
//    let nativeAdId = "ca-app-pub-7879710565936793/9913003799"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        Purchases.debugLogsEnabled = true
        Purchases.shared.delegate = self
        Purchases.configure(withAPIKey: "uYHOofWgPecKHrieUvAToTvMPrBFrPQT")
        
        Flurry.startSession("Q6TBFFNH6MM2F6498BWK", with: FlurrySessionBuilder
            .init()
            .withCrashReporting(true)
            .withLogLevel(FlurryLogLevelAll))
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .dark
        
        window?.rootViewController = rootViewController
        
        getRewardAds()
        getNativeAds()
        checkId()
                
        return true
    }
    
    private func getRewardAds() {
        rewardAdInstance.delegate = self
        rewardAdInstance.load(GADRequest(), withAdUnitID: rewardAdId)
    }
    
    private func getNativeAds() {
        let options = GADMultipleAdsAdLoaderOptions()
        options.numberOfAds = 5
                
        adLoader = GADAdLoader(adUnitID: nativeAdId,
                               rootViewController: rootViewController,
                               adTypes: [.unifiedNative],
                               options: [options])
        
        adLoader.delegate = self
    }
    
    private func checkId() {
        if let id = UserDefaults.standard.string(forKey: "userId") {
            let db = Database.database().reference().child("users").child(id).child("lastSeen")
            db.setValue(Date().timeIntervalSince1970)
            
            Purchases.shared.purchaserInfo { (purchaserInfo, error) in
                if let error = error {
                    print("Error with purchaser info in app delegate: \(error.localizedDescription)")
                }
            }
        } else {
            let newId = HelperFunctions.getRandomAlphanumericString(length: 25)
            let db = Database.database().reference().child("users").child(newId).child("lastSeen")
            UserDefaults.standard.set(newId, forKey: "userId")
            db.setValue(Date().timeIntervalSince1970)
            
            let onboardingController = OnboardingPageViewController()
            onboardingController.modalPresentationStyle = .overFullScreen
            rootViewController.present(onboardingController, animated: true, completion: nil)
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
        if nativeAds.count < 25 && adLoadAttempts <= 7 {
            Purchases.shared.purchaserInfo { (purchaserInfo, error) in
                if let error = error {
                    print("Error with purchaser info in app delegate ad loader: \(error.localizedDescription)")
                }
                
                if purchaserInfo?.entitlements["remove-ads"]?.isActive == false {
                    adLoader.load(GADRequest())
                }
            }
        }
        
        adLoadAttempts += 1
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        UserDefaults.standard.set(0, forKey: "contentWatchedCount")
        rewardAdInstance = GADRewardBasedVideoAd.sharedInstance()
        rewardAdInstance.load(GADRequest(), withAdUnitID: rewardAdId)
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        UserDefaults.standard.set(0, forKey: "contentWatchedCount")
        rewardAdInstance = GADRewardBasedVideoAd.sharedInstance()
        rewardAdInstance.load(GADRequest(), withAdUnitID: rewardAdId)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        TwitchService.validateToken { (status) in
            print("Twitch Token Status: \(status)")
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let authorizationFlow = self.currentAuthorizationFlow, authorizationFlow.resumeExternalUserAgentFlow(with: url) {
            self.currentAuthorizationFlow = nil
            return true
        }
        
        if url.scheme == "player3Glitch" || url.scheme == "player3glitch" {
            OAuthSwift.handle(url: url)
        }

        urlToHandle = url

        return false
    }
}

