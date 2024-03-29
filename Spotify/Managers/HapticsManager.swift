//
//  Haptics.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/5/23.
//

import Foundation
import UIKit


final class HapticsManager {
    static let shared = HapticsManager()
    
    private init() {}
    
    public func vibrateForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
}
