//
//  NowPlayingViewController.swift
//  MyMusic
//
//  Created by Tarun Kaushik on 07/11/20.
//

import UIKit

class NowPlayingViewController: UIViewController {
    
    private lazy var playerView: PlayerView = {
        let view = Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first  as! PlayerView
        return view
    }()
    
    private var viewModel: PlayerViewModel!
    
    override func loadView() {
        self.view = playerView
        self.viewModel = PlayerViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.playerView.nextBtn.addTarget(self, action: #selector(playNext), for: .touchUpInside)
        self.playerView.previousBtn.addTarget(self, action: #selector(playPrevious), for: .touchUpInside)
        self.playerView.playPauseBtn.addTarget(self, action: #selector(playPauseAction), for: .touchUpInside)
        
        self.setupViewModel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showAlert), name:  NSNotification.Name(rawValue: "FinishedPlayList"), object: nil)
        
        MusicPlayer.shared.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let currentTrack = MusicPlayer.shared.currentTrack {
            playerView.updateState(track: currentTrack, state: .update)
        }
    }
    
    @objc func playNext() {
        MusicPlayer.shared.playNextTrack()
    }
    
    @objc func playPrevious() {
        MusicPlayer.shared.playPreviousTrack()
    }
    
    @objc func playPauseAction() {
        MusicPlayer.shared.togglePlayerState()
    }
    
    private func setupViewModel() {
        viewModel.updateState = {state in }
    }
    
    @objc private func showAlert() {
        playerView.updateState(track: nil, state: .intial)
        
        let alertController = UIAlertController(title: "MUSIC Player", message: "Songs Finished In PlayList", preferredStyle: .alert)
        let playAgain = UIAlertAction(title: "Play Again", style: .default) {(action) in
            // perform some action
            MusicPlayer.shared.playAgain()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(playAgain)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

}

extension NowPlayingViewController: MusicPlayerDelegate {
    func playingNextTrack(track: Track?) {
        if let currentTrack = track{
            self.playerView.updateState(track: currentTrack, state: .update)
        }
    }
    
    func playerPaused() {
        self.playerView.updateState(track: nil, state: .paused)
    }
    
    func playerContinue() {
        self.playerView.updateState(track: nil, state: .play)
    }
    
    func currentTrack(track: Track?) {
        if let currentTrack = track{
            self.playerView.updateState(track: currentTrack, state: .update)
        }
    }
    
    func updateTrackProgress(progress: Float, time: Int) {
        playerView.updateProgressView(progress: progress, time: time)
    }
}
