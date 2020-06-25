//
//  SceneDelegate.swift
//  chatter-ios
//
//  Created by Julian Rubisch on 25.06.20.
//  Copyright © 2020 Julian Rubisch. All rights reserved.
//

import UIKit
import SwiftUI
import Turbolinks
import WebKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigationController = UINavigationController()
    lazy var session: Session = {
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "Chatter iOS"
        return Session(webViewConfiguration: configuration)
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = navigationController
            self.window = window
            visit(URL: NSURL(string: "http://localhost:3000")!)
            self.session.delegate = self
            window.makeKeyAndVisible()
        }
    }

    func visit(URL: NSURL, action: Action = .Advance) {
        let viewController = VisitableViewController(url: URL as URL)
        
        if action == .Advance {
            navigationController.pushViewController(viewController, animated: true)
        } else if action == .Replace {
            if navigationController.viewControllers.count == 1 {
            navigationController.setViewControllers([viewController], animated: false)
            } else {
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(viewController, animated: false)
            }
        }
        session.visit(viewController)
    }

}

extension SceneDelegate: SessionDelegate {
    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, withError error: NSError) {
        // TODO handle errors
    }
    
    func session(_ session: Session, didProposeVisitToURL URL: URL, withAction action: Action) {
        visit(URL: URL as NSURL, action: action)
    }
}
