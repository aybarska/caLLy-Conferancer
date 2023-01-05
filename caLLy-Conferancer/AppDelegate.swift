//
//  AppDelegate.swift
//  caLLy-Conferancer
//
//  Created by Ayberk Mogol on 2.01.2023.
//

import UIKit
import VoxeetSDK
import VoxeetUXKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Voxeet SDK initialization.
        VoxeetSDK.shared.initialize(consumerKey: "L6kc9lqubiPtgAo4UqcDgw==", consumerSecret: "DvvBC93xtdRE5LyObWqKwFjG7xkrjL5M5rM-Kgvhdzg=")
        VoxeetUXKit.shared.initialize()

        // Example of public variables to change the conference behavior.
        //VoxeetSDK.shared.pushNotification.push.type = .none
        VoxeetSDK.shared.conference.defaultBuiltInSpeaker = false
        VoxeetSDK.shared.conference.defaultVideo = false
        
        VoxeetUXKit.shared.conferenceController!.appearMaximized = true
        VoxeetUXKit.shared.conferenceController!.telecom = false
        VoxeetUXKit.shared.conferenceController!.isVideoViewMirrorEffect = true
        
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


}

