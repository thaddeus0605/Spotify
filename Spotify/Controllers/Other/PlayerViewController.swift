//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/5/23.
//

import UIKit
import SDWebImage
import AVFoundation

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didSlideSlider(_ value: Float)
}

class PlayerViewController: UIViewController {
    
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let controlsView = PlayerControlView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        configureBarButtons()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: view.width
        )
        controlsView.frame = CGRect(
            x: 10,
            y: imageView.bottom+10,
            width: view.width-20,
            height: view.height-imageView.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-15
        )
        
    }
    

    private func configure() {
        imageView.sd_setImage(with: dataSource?.imageURL, completed:  nil)
        controlsView.configure(
            with: PlayerControlsViewModel(
            title: dataSource?.songName,
            subtitle: dataSource?.subtitle
        )
        )
    }
    
    
    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapActions))
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapActions() {
        //actions
        
    }
    
    func refreshUI() {
        configure()
    }
}

extension PlayerViewController: PlayerControlViewDelegate {
    func playerControlsView(_ playerControlView: PlayerControlView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
    func playerControlsViewDidTapPlayPauseButton(_ playerControlView: PlayerControlView) {
        delegate?.didTapPlayPause()
    }
    
    func playerControlsViewDidTapBackwardsButton(_ playerControlView: PlayerControlView) {
        delegate?.didTapBackward()
    }
    
    func playerControlsViewDidTapForwardsButton(_ playerControlView: PlayerControlView) {
        delegate?.didTapForward()
    }
    
    
    
}
