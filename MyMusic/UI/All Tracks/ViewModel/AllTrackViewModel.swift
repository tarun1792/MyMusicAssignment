//
//  AllTrackViewModel.swift
//  MyMusic
//
//  Created by Tarun Kaushik on 07/11/20.
//

import Foundation

protocol AllTracksViewModelDelegate: class {
    // ViewController Methods
    func viewDidLoad()
    func addTrackToPlayList(track: Track, index: Int)
    func removeTrackFromPlayList(track: Track, index: Int)
    
    // TableViewDelegates
    func itemAt(index: Int) -> Track?
    func itemCounts() -> Int
    
    var errorHandler: ((_ error: Error) -> Void)? {set get}
    var didAddItemAt: ((_ index: Int) -> Void)? {set get}
    var didRemoveItemAt: ((_ index: Int) -> Void)? {set get}
    var updateState: ((_ state: AllTracksView.State) -> Void)? {set get}
}

class AllTrackViewModel: AllTracksViewModelDelegate {
    
    var updateState: ((AllTracksView.State) -> Void)?
    var errorHandler: ((Error) -> Void)?
    var didAddItemAt: ((Int) -> Void)?
    var didRemoveItemAt: ((Int) -> Void)?
    var tracks: [Track]?
    
    init() {}
    
    func viewDidLoad() {
        self.updateState?(.initial)
        self.loadTracks()
        self.updateState?(.loading)
    }
    
    func removeTrackFromPlayList(track: Track, index: Int) {
        if MusicPlayer.shared.removeTrackfromPlayList(track: track) {
            self.didRemoveItemAt?(index)
        }
    }
    
    func addTrackToPlayList(track: Track, index: Int) {
        MusicPlayer.shared.addTrackToPlaylist(track: track)
        self.didAddItemAt?(index)
    }
    
    func playAgain(){
        MusicPlayer.shared.playAgain()
    }
    
    func itemAt(index: Int) -> Track? {
        return tracks?[index]
    }
    
    func itemCounts() -> Int {
        return tracks?.count ?? 0
    }
    
    func trackPresentInPlayList(track: Track) -> Bool {
        if let _ = MusicPlayer.shared.playList.firstIndex(of: track) {
            return true
        }
        return false
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
        
    private func loadTracks() {
        guard let path = Bundle.main.path(forResource: "TestData", ofType: "JSON") else { return }
        let queue = DispatchQueue.global(qos: .userInteractive)
        
        queue.async { [weak self] in
            do {
                let decoder = JSONDecoder()
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                self?.tracks = try decoder.decode([Track].self, from: data)
                self?.updateState?(.update)
            } catch {
                print("Unexpected Error: \(error).")
            }
        }
    }
}
