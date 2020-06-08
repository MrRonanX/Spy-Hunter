//
//  AppDelegate.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 25.04.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import RealmSwift
import LanguageManager_iOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
 
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        do {
               _ = try Realm()
               }catch{
                   print("Realm cannot write data \(error)")
               }
        
        // Get selected language if already there, otherwise check preferred languages on basis of locale if available then set to default language else english
        
        if let selectedLanguage = RKLocalization.sharedInstance.getLanguage(){
            RKLocalization.sharedInstance.setLanguage(language: selectedLanguage)
        }else{
            let languageCode = Locale.preferredLanguages[0]
            if Languages.isLanguageAvailable(languageCode){
                RKLocalization.sharedInstance.setLanguage(language: languageCode)
            }else{
                RKLocalization.sharedInstance.setLanguage(language: "en")
            }
        }
        self.initRootView()
        return true
    }
    
  
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func initRootView(){
        
        // set appearance of component on basis of language direction
        let dir = RKLocalization().getlanguageDirection()
        if  dir == .leftToRight {
            let semantic: UISemanticContentAttribute = .forceLeftToRight
            UITabBar.appearance().semanticContentAttribute = semantic
            UIView.appearance().semanticContentAttribute = semantic
            UINavigationBar.appearance().semanticContentAttribute = semantic
        }
        else {
            let semantic: UISemanticContentAttribute = .forceRightToLeft
            UITabBar.appearance().semanticContentAttribute = semantic
            UIView.appearance().semanticContentAttribute = semantic
            UINavigationBar.appearance().semanticContentAttribute = semantic
        }
        
        // init root controller of application and setting it to window
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let rootController: UINavigationController? = storyboard.instantiateViewController(withIdentifier: "appNavigationController") as? UINavigationController
        let window = UIApplication.shared.windows.first
        window?.rootViewController = rootController
    }


}

