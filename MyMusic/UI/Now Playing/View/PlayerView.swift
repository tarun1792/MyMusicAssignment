//
//  PlayerView.swift
//  MyMusic
//
//  Created by Tarun Kaushik on 07/11/20.
//

import UIKit

class PlayerView: UIView {
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var timeDurationLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    enum State {
        case intial, update, play, paused
    }

    func updateState(track : Track?, state: State) {
        switch state {
        
        case .intial:
            playerImageView.image = UIImage(named: "placeholder")
            trackTitle.text = "No Track"
            timeDurationLabel.text = "00:00"
            genreLabel.text = "No Genre"
            break
            
        case .update:
            if let track = track{
                self.playerImageView.downloadImage(url: track.imageUrl)
                self.trackTitle.text = track.title
                self.updateProgressView(progress: 0.0, time: 0)
                self.genreLabel.text = track.genre
            }
        
        case .play:
            self.playPauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
            
        case .paused:
            self.playPauseBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    func updateProgressView(progress: Float, time: Int){
        self.timeDurationLabel.text = self.timeDuration(time: time)
        self.progressView.progress = progress
    }
    
    func timeDuration(time: Int) -> String {
        let seconds = time
        let minutes = Int(seconds/60)
        let remainingSeconds = Int(seconds%60)
        return String(format: "%02d:%02d", minutes,remainingSeconds)
    }
}
