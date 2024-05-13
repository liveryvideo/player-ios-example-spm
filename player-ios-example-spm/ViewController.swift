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
    @IBOutlet private weak var playerContainerView: UIView! {
        didSet {
            playerContainerView.addSubview(playerView)
            playerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                playerView.topAnchor.constraint(equalTo: playerContainerView.topAnchor),
                playerView.trailingAnchor.constraint(equalTo: playerContainerView.trailingAnchor),
                playerView.bottomAnchor.constraint(equalTo: playerContainerView.bottomAnchor),
                playerView.leadingAnchor.constraint(equalTo: playerContainerView.leadingAnchor),
            ])
        }
    }
    
    // MARK: - Properties
    private let playerView = LiveryPlayerView()
    
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
        LiverySDK.initialize(streamId: "5ddb98f5e4b0937e6a4507f2", completionQueue: .main) { [weak self] error in
            guard let self else { return }
            
            if let error {
                // deal with the initialization error here
                showError(errorMessage: error.localizedDescription)
            } else {
                do {
                    try playerView.createPlayer()
                } catch {
                    showError(errorMessage: error.localizedDescription)
                    return
                }
                
                // Set 'self' as the class that implements the PlayerDelegate protocol to receive the Player Events
                playerView.delegate = self
                playerView.play() // If your remote config as 'autoplay' set to true you don't need to call 'play'
            }
        }
    }
    
    // MARK: - Livery Player Actions
    private func play() {
        playerView.play()
    }
    
    private func stop() {
        playerView.stop()
    }
    
    @objc private func playbackDidChange(_ notification: Notification) {
        print("Playback state did change")
        
        guard let stateString = (notification.object as? LiveryPlaybackState)?.description  else { return }
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
extension ViewController: LiveryPlayerDelegate {
    func playbackStateDidChange(playbackState: LiveryPlaybackState) {
        print("Playback state did change")
        print("Playback State Now: \(playbackState.description)")
    }
}
