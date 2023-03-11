//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/5/23.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    

    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In With Your Spotify Account", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(x: 20,
                                    y: view.height-50-view.safeAreaInsets.bottom,
                                    width: view.width - 40,
                                    height: 50)
    }
    
    @objc func didTapSignIn() {
        let authVC = AuthViewController()
        authVC.completeionHandler = { [weak self] success in
            self?.handleSignIn(success: success )
        }
        authVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(authVC, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        //handle login functions and tell the user if it was successful or not
        guard success else {
            let alert = UIAlertController(title: "Oops",
                                         message: "Something went wrong when singing in.",
                                         preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
        
    }
}
