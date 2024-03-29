//
//  TabBarViewController.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/5/23.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Tab Bar and Navigation Controller setup
        let homeVC = HomeViewController()
        let searchVC = SearchViewController()
        let libraryVC = LibraryViewController()
        
        homeVC.title = "Browse"
        searchVC.title = "Search"
        libraryVC.title = "Library"
        
        homeVC.navigationItem.largeTitleDisplayMode = .always
        searchVC.navigationItem.largeTitleDisplayMode = .always
        libraryVC.navigationItem.largeTitleDisplayMode = .always
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let searchNav = UINavigationController(rootViewController: searchVC)
        let libraryNav = UINavigationController(rootViewController: libraryVC)
        
        homeNav.navigationBar.tintColor = .label
        searchNav.navigationBar.tintColor = .label
        libraryNav.navigationBar.tintColor = .label
        
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        searchNav.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        libraryNav.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 1)
        
        homeNav.navigationBar.prefersLargeTitles = true
        searchNav.navigationBar.prefersLargeTitles = true
        libraryNav.navigationBar.prefersLargeTitles = true
        
        setViewControllers([homeNav, searchNav, libraryNav], animated: false)
    }
    
}
