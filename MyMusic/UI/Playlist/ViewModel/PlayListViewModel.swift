//
//  PlayListViewModel.swift
//  MyMusic
//
//  Created by Tarun Kaushik on 07/11/20.
//

import Foundation

protocol PlayListViewModelDelegate: class {
    // ViewController Methods
    func removeTrackFromPlayList(track: Track, index: Int)
    
    // TableViewDelegates
    func itemAt(index: Int) -> Track?
    func itemCounts() -> Int
   
    var updateState: ((_ state: PlayListView.State) -> Void)? {set get}
}

class PlayListViewModel: PlayListViewModelDelegate {
 
    var updateState: ((PlayListView.State) -> Void)?
    init (){}
    
    func itemCounts() -> Int {
       return MusicPlayer.shared.playList.count
    }
    
    func itemAt(index: Int) -> Track? {
        return MusicPlayer.shared.playList[index]
    }
    
    func removeTrackFromPlayList(track: Track, index: Int) {
        if MusicPlayer.shared.removeTrackfromPlayList(track: track) {
            self.updateState?(.refresh)
        }
    }
    
    func trackPresentInPlayList(track: Track) -> Bool {
        if let _ = MusicPlayer.shared.playList.firstIndex(of: track) {
            return true
        }
        return false
    }
    
    func playAgain(){
        MusicPlayer.shared.playAgain()
    }
    
    func playTrack(track: Track?) {
        guard let track = track else {return}
        MusicPlayer.shared.playTrack(track: track)
    }
    
    func getTrackTimeDuration(track: Track) -> String {
        if let time = track.duration {
        let seconds = Int(time)
        let minutes = Int(seconds/60)
        let remainingSeconds = Int(seconds%60)
            return String(format: "%02d:%02d", minutes,remainingSeconds)
        }
        return "00:00"
    }
}
