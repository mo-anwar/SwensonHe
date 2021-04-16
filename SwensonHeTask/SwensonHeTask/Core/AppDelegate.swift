//
//  AppDelegate.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        enableIQKeyboardManager()
        initalizeWindow()
        start()
        return true
    }
    
    private func enableIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
    }
    
    private func initalizeWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    }
    
    private func start() {
        window?.rootViewController = UINavigationController(rootViewController: HomeViewController.create())
    }
}
