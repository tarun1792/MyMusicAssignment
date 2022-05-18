//
//  PlayerViewModel.swift
//  MyMusic
//
//  Created by Tarun Kaushik on 07/11/20.
//

import Foundation

protocol PlayerViewModelDelegate: class {
    func currentTrack() -> Track?
    func getNextTrack() -> Track?
    func playNextTrack() -> Track?
    func playPreviousTrack()
    func getPreviousTrack() -> Track?
    func playAgain()
    func playTrack(track: Track?)
    func playPauseAction()
}


class PlayerViewModel {
    
    init () {}
    
    var updateState: ((_ state: PlayerView.State) -> Void)?
//    
//    func currentTrack() -> Track? {
//        return MusicPlayer.shared.currentTrack
//    }
//    
//    func getNextTrack() -> Track? {
//        return MusicPlayer.shared.getNextTrack()
//    }
//    
//    func playNextTrack() {
//        MusicPlayer.shared.playNextTrack()
//        self.updateState?(.update)
//    }
//    
//    func playPreviousTrack() {
//        MusicPlayer.shared.playPreviousTrack()
//        self.updateState?(.update)
//    }
//    
//    func getPreviousTrack() -> Track? {
//        return MusicPlayer.shared.getPreviousTrack()
//    }
//    
//    func playAgain(){
//        MusicPlayer.shared.playAgain()
//        self.updateState?(.update)
//    }
//    
//    func playTrack(track: Track?) {
//        guard let track = track else {return}
//        MusicPlayer.shared.playTrack(track: track)
//    }
//    
//    func playPauseAction(){
//    }
}
