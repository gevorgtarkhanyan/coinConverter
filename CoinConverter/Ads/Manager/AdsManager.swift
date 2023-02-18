//
//  AdsManager.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 04.01.22.
//

import Foundation
import UIKit

class AdsManager: NSObject {
    
    static let shared = AdsManager()
    
    // MARK: - Init
    fileprivate override init() {
        super.init()
    }
    
    private var adsView = AdsView()
    private var allAds = ZoneIdsManager.shared.getAdsZoneFromDirectory()
    private var adsTrack: Bool = false
    private var ads = AdsModel()
    private var isAdsTableView = false
    private var showAdsListID = ZoneIdsManager.shared.getAdsZoneFromDirectory().map({$0.id})
    private var showAdsForSubscriberListID = ZoneIdsManager.shared.getAdsZoneFromDirectory().filter({$0.showToSubscribed == true}).map({$0.id})
    
    func checkUserForAds(zoneName:ZoneName,isAdsTableView: Bool = false,success: @escaping(AdsView) -> Void) {
        self.isAdsTableView = isAdsTableView
        
        let isAdsListNeedUpdate = TimerManager.shared.isLoadingTime(item: .adsList)
        
        if isAdsListNeedUpdate {
            
            AdsRequestService.shared.getZoneIdsList {
                debugPrint("Ads List is update")
            } failer: { err in
                debugPrint(err)
            }
        }
        
        for ads in allAds {
            
            self.adsTrack = ads.track
            
            if ads.native {
                for zone in ads.zones {
                    if zone["name"] == zoneName.rawValue {
                        self.ads.showToSubscribed = ads.showToSubscribed
                        self.ads.hideDuration = ads.hideDuration
                        self.ads.adsZoneName = zone["name"] ?? ""
                        self.ads.adsZoneId =  zone["_id"] ?? ""
                        
                        if subscribed {
                            let isShowAds = TimerManager.shared.isLoadingTime(item: .adsHide, duration: ads.hideDuration)
                            if  isShowAds {
                                self.getAdsFromServer{ adsView in
                                    success(adsView)
                                }
                            } else {
                                NotificationCenter.default.post(name: .hideAdsForSubscribeUsers, object: nil)
                            }
                            return
                        }
                        self.ads.showToSubscribed = false
                        self.getAdsFromServer{ adsView in
                            success(adsView)
                        }
                        return
                    }
                }
            }
            
            if ads.name == "Coinzilla" {
                
                self.ads.showToSubscribed = false
                
                guard !subscribed else {
                    NotificationCenter.default.post(name: .hideAdsForSubscribeUsers, object: nil)
                    continue
                }
                
                for zone in ads.zones {
                    if zone["name"] == zoneName.rawValue {
                        self.ads.adsZoneName = zone["name"] ?? ""
                        self.ads.adsZoneId =  zone["_id"] ?? ""
                        self.ads.id = ads.id
                        var endpoint = ""
                        switch zoneName {
                        case .converter:
                            endpoint = AdsEndPointEnum.converter.rawValue
                        case .newsMyFeed:
                            endpoint = AdsEndPointEnum.converter.rawValue
                        case .newsTop:
                            endpoint = AdsEndPointEnum.converter.rawValue
                        case .newsAll:
                            endpoint = AdsEndPointEnum.converter.rawValue
                        case .newArticle:
                            endpoint = AdsEndPointEnum.converter.rawValue
                        }
                        self.getAdsFromCoinzila(success: { adsView in
                            success(adsView)
                        }, endpoint: endpoint)
                        return
                    }
                }
            }
        }
    }
    func getAdsFromServer(success: @escaping(AdsView) -> Void) {
        AdsRequestService.shared.getAdsFromServer (success: { [self] (ads) in
            
            ads.isNative = true
            
            guard showAdsListID.contains(ads.id) else { return }
            
            guard !subscribed else {
                if showAdsForSubscriberListID.contains(ads.id) && !removeAds {
                    self.ads.id = ads.id
                    self.ads.showToSubscribed = true
                    success(self.configAds(ads: ads))
                }
                return
            }
            self.ads.id = ads.id
            self.ads.showToSubscribed = false
            success(self.configAds(ads: ads))
            
        }, zoneId: self.ads.adsZoneId , zoneName: self.ads.adsZoneName ) { (err) in
            print(err)
        }
    }
    
    
    func getAdsFromCoinzila(success: @escaping(AdsView) -> Void, endpoint: String) {
        AdsRequestService.shared.getAdsFromCoinzila (success: { [self] (ads) in
            
            success(self.configAds(ads: ads))
            
        }, endpoint: endpoint) { (err) in
            print(err)
        }
    }
    
    func configAds(ads: AdsModel) ->  AdsView {
        
        self.adsView.titleLabel.setLocalizableText(ads.title)
        
        if ads.shortDesc == "" {
            self.adsView.adsShortDesc.setLocalizableText(ads.descript)
        } else {
            self.adsView.adsShortDesc.setLocalizableText(ads.shortDesc)
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if ads.descript != "" {
                self.adsView.adsShortDesc.setLocalizableText(ads.descript)
            } else {
                self.adsView.adsShortDesc.setLocalizableText(ads.shortDesc)
            }
        }
        self.adsView.adsLogoImage.sd_setImage(with:  URL(string:  ads.isNative ? (Constants.HttpUrlWithoutApi + "images/ads/" + ads.thumbnail) : ads.thumbnail ), completed: nil)
        self.adsView.joinNowButton.setTitle(ads.btnName,for: .normal)
        self.adsView.cancelButton.addTarget(self, action: #selector(hideAdsForSubscribeUsers), for: .touchUpInside)
        self.adsView.url = ads.url
        self.adsView.joinNowButton.addTarget(self, action: #selector(goToURLAds), for: .touchUpInside)
        AdsRequestService.shared.postForCoinzileInpression(url: ads.impressionUrl)
        if self.adsTrack {
            AdsRequestService.shared.putAdsTrackForServer(zoneId: self.ads.adsZoneId, adsId: self.ads.id, click: 0, imp: 1)
            print(self.ads.adsZoneId)
            print(self.ads.id)
        }
        return adsView
        
    }
    @objc func openUrl (url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc  func openURL(urlString: String) {
        if let copyRightURL = URL(string: urlString), UIApplication.shared.canOpenURL(copyRightURL) {
            openUrl(url: copyRightURL)
        }
    }
    
    @objc func goToURLAds() {
        openURL(urlString: adsView.url)
        AdsRequestService.shared.putAdsTrackForServer(zoneId: self.ads.adsZoneId, adsId: self.ads.id, click: 1, imp: 0)
    }
    
    @objc func hideAdsForSubscribeUsers() {
        guard self.ads.showToSubscribed  else {
            self.goToSubscriptionPage()
            return
        }
        TimerManager.shared.setDurationTime(item: .adsHide)
        
        NotificationCenter.default.post(name: .hideAdsForSubscribeUsers, object: nil)
        adsView.removeFromSuperview()
        return
        
    }
    
    @objc public func goToSubscriptionPage() {
        guard let vc = UIApplication.getTopViewController() as? BaseViewController else { return }
        vc.showSubscriptionPopup()
    }
}
