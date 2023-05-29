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
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "albums_background")
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.9
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "Listen to Milions\nof Songs on \nthe go."
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Spotify"
        view.addSubview(backgroundImageView)
        view.addSubview(overlayView)
        view.backgroundColor = .blue
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        view.addSubview(label)
        view.addSubview(logoImageView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        overlayView.frame = view.bounds
        backgroundImageView.frame = view.bounds
        signInButton.frame = CGRect(x: 20,
                                    y: view.height-50-view.safeAreaInsets.bottom,
                                    width: view.width - 40,
                                    height: 50)
        logoImageView.frame = CGRect(
            x: (view.width-120)/2,
            y: (view.height-350)/2,
            width: 120,
            height: 120
        )
        label.frame = CGRect(
            x: 30,
            y: logoImageView.bottom+30,
            width: view.width-60,
            height: 150
        )
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
