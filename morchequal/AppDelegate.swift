//
//  AppDelegate.swift
//  morchequal
//
//  Created by Erik Jälevik on 29.05.19.
//  Copyright © 2019 Fileside. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var fetcher: Fetcher!
    private var iTunesClient: ITunesClient!
    private var artworkCache: NSCache<NSString, UIImage>!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let rootVC = initApp()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        return true
    }
    
    private func initApp() -> UIViewController {
        // These are shared dependencies owned by the app
        fetcher = Fetcher(session: URLSession.shared)
        iTunesClient = ITunesClient(fetcher: fetcher)
        artworkCache = NSCache<NSString, UIImage>()

        // These are screen-specific components created on navigation (which
        // we don't have in this demo app, but which we would in a real one)
        let searchBinder = SearchBinder(
            client: iTunesClient,
            artworkCache: artworkCache
        )
        let searchVC = SearchViewController(binder: searchBinder)

        return searchVC
    }
}

