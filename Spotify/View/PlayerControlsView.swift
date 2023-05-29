//
//  PlayerControlsView.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/25/23.
//

import UIKit

protocol PlayerControlViewDelegate: AnyObject {
    func playerControlsViewDidTapPlayPauseButton(_ playerControlView: PlayerControlView)
    func playerControlsViewDidTapBackwardsButton(_ playerControlView: PlayerControlView)
    func playerControlsViewDidTapForwardsButton(_ playerControlView: PlayerControlView)
    func playerControlsView(_ playerControlView: PlayerControlView, didSlideSlider value: Float)
}

struct PlayerControlsViewModel {
    let title: String?
    let subtitle: String?
}

final class PlayerControlView: UIView {
    
    private var isPlaying = true
    
    weak var delegate: PlayerControlViewDelegate?
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "backward.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 34,
                weight: .regular
            )
        )
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "forward.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 34,
                weight: .regular
            )
        )
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "pause.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 34,
                weight: .regular
            )
        )
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(slider)
        
        addSubview(backButton)
        addSubview(nextButton)
        addSubview(playPauseButton)
       
        clipsToBounds = true
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        slider.addTarget(self, action: #selector(didSlideSlider(_: )), for: .valueChanged)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        delegate?.playerControlsView(self, didSlideSlider: value)
    }
    
    @objc func didTapBack() {
        delegate?.playerControlsViewDidTapBackwardsButton(self)
    }
    
    @objc func didTapNext() {
        delegate?.playerControlsViewDidTapForwardsButton(self)
    }
    
    @objc func didTapPlayPause() {
        self.isPlaying = !isPlaying
        delegate?.playerControlsViewDidTapPlayPauseButton(self)
        
        //update icon
        let pause = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        let play = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        playPauseButton.setImage(isPlaying ? pause : play, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subtitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom+10, width: width, height: 50)
        
        slider.frame = CGRect(x: 10, y: subtitleLabel.bottom+20, width: width-20, height: 44)
        
        let buttonSize: CGFloat = 60
        playPauseButton.frame = CGRect(x: (width-buttonSize)/2, y: slider.bottom+30, width: buttonSize, height: buttonSize)
        backButton.frame = CGRect(x: playPauseButton.left-80-buttonSize, y: playPauseButton.top, width: buttonSize, height: buttonSize+10)
        nextButton.frame = CGRect(x: playPauseButton.right+80, y: playPauseButton.top, width: buttonSize, height: buttonSize)
    }
    
    func configure(with viewModel: PlayerControlsViewModel) {
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}

