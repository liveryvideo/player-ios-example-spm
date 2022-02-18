//
//  ViewController.swift
//  player-ios-example-spm
//
//  Created by Jose Nogueira on 18/02/2022.
//

import UIKit
import Livery

class ViewController: UIViewController {
    
    // MARK: - UI Properties
    @IBOutlet private weak var playerView: UIView!
    
    // MARK: - Properties
    private let liveSDK = LiverySDK()
    private var player: Player?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Livery SDK Version: \(LiverySDK.sdkVersion)")
        initializeLiveSDK()
    }
    
    // MARK: - Livery SDK Initialization
    private func initializeLiveSDK() {
        stop()
        
        // Initialize the SDK
        liveSDK.initialize(streamId: "5ddb98f5e4b0937e6a4507f2", completionQueue: .main) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                // Create a player object
                self.player = self.liveSDK.createPlayer()
                if let player = self.player {
                    // Set a UIView for the player to render into
                    player.setView(view: self.playerView)
                    
                    // Set 'self' as the class that implements the PlayerDelegate protocol to receive the Player Events
                    player.delegate = self
                }
                
                // The player is now ready to play
                self.play() // If your remote config as 'autoplay' set to true you don't need to call 'play'
            
            case .failure(let error):
                // deal with the initialization error here
                self.showError(errorMessage: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Livery Player Actions
    private func play() {
        player?.play(completionQueue: .main) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                // player is now playing
                break
            case .failure(let error):
                // deal with the play error here
                self.showError(errorMessage: error.localizedDescription)
            }
        }
    }
    
    private func stop() {
        player?.stop {
            print("Player did Stop")
        }
    }
    
    @objc private func playbackDidChange(_ notification: Notification) {
        print("Playback state did change")
        
        guard let stateString = (notification.object as? Player.PlaybackState)?.description  else { return }
        print("Playback State Now: \(stateString)")
    }
    
    // MARK: - Error Alert View
    private func showError(errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - PlayerDelegate
extension ViewController: PlayerDelegate {
    func playbackStateDidChange(playbackState: Player.PlaybackState) {
        print("Playback state did change")
        print("Playback State Now: \(playbackState.description)")
    }
}
