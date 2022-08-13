//
//  SceneDelegate.swift
//  FlashCards
//
//  Created by Work on 8/5/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let dependencyContainer: DependencyContainer
        
        
        // MARK: - TEST JIG
        #if LOAD_TEST_JIG
        // A convenient way to test out the functionality of view controllers before incorporating them into the project
        print("LOAD_TEST_JIG enabled")
        print("Loading test jig instead of normal project...")
        window.rootViewController = loadTestJig()
        window.makeKeyAndVisible()
        self.window = window
        return
        #endif
        
        
        // MARK: - TEST STORES
        #if IN_MEMORY_STORES
        dependencyContainer = DependencyContainer(storesInMemory: true)
        
            #if LOAD_TEST_DATA
            // If needed, loads some test entities into CoreData
            print("LOAD_TEST_DATA enabled")
            print("Loading test data if needed...")
            loadTestData(flashCardService: dependencyContainer.flashCardService)
            #endif
        
        #else
        dependencyContainer = DependencyContainer(storesInMemory: false)
        
            #if DESTROY_PERSISTENT_STORES
            PersistentContainerHelper.shared.destroyPersistentStoresOnDisk(persistentContainer: persistentContainer)
            #endif
        
        #endif
        
        // MARK: - RUN APP
        
        // Configure Navigation
        let tabBarController = UITabBarController()
        let decksNavigation = UINavigationController()
        let packsNavigation = UINavigationController()
        
        // Tab bar appearance
        let tabStandardAppearance = UITabBarAppearance()
        tabStandardAppearance.configureWithOpaqueBackground()
        tabStandardAppearance.backgroundColor = .secondarySystemBackground
        
        tabBarController.tabBar.standardAppearance = tabStandardAppearance
        tabBarController.tabBar.scrollEdgeAppearance = tabStandardAppearance
        
        // Nav appearance
        let navStandardAppearance = UINavigationBarAppearance()
        navStandardAppearance.configureWithOpaqueBackground()
        navStandardAppearance.backgroundColor = .secondarySystemBackground
        
        decksNavigation.navigationBar.standardAppearance = navStandardAppearance
        decksNavigation.navigationBar.scrollEdgeAppearance = navStandardAppearance
        decksNavigation.navigationBar.compactAppearance = navStandardAppearance
        
        packsNavigation.navigationBar.standardAppearance = navStandardAppearance
        packsNavigation.navigationBar.scrollEdgeAppearance = navStandardAppearance
        packsNavigation.navigationBar.compactAppearance = navStandardAppearance
        
        // Inject dependencies
        let deckListViewController = DeckListViewController(dependencyContainer: dependencyContainer)
        let contentPackListViewController = ContentPackListViewController(dependencyContainer: dependencyContainer)
        
        // Set up view hierarchy
        tabBarController.setViewControllers([decksNavigation, packsNavigation], animated: true)
        
        decksNavigation.setViewControllers([deckListViewController], animated: true)
        
        packsNavigation.setViewControllers([contentPackListViewController], animated: true)
        
        // Make tab bar items visible
        decksNavigation.tabBarItem = deckListViewController.tabBarItem
        packsNavigation.tabBarItem = contentPackListViewController.tabBarItem
        decksNavigation.loadViewIfNeeded()
        packsNavigation.loadViewIfNeeded()
        
        window.rootViewController = tabBarController
        
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

