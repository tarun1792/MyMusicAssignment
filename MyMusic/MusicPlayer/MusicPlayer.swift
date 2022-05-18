//
//  MusicPlayer.swift
//  MyMusic
//
//  Created by Tarun Kaushik on 07/11/20.
//

import Foundation

protocol MusicPlayerDelegate: class {
    func updateTrackProgress(progress: Float,time: Int)
    func playingNextTrack(track: Track?)
    func currentTrack(track: Track?)
    func playerPaused()
    func playerContinue()
}

class MusicPlayer {
    
    private init (){}
    static let shared = MusicPlayer()
    
    private var timer: Timer?
    private var currentTime: Int = 0
    private var isPlaying: Bool = false
    private var isPaused = false
    
    var playList: [Track] = []
    var previousTracks: [Track] = []
    var nextTracks: [Track] = []
    var currentTrack: Track?
    
    weak var delegate: MusicPlayerDelegate?
    
    
    //MARK: Player Functions
    func togglePlayerState(){
        if isPaused == false{
            pauseTrack()
            isPaused = true
        }else {
            continueTrack()
            isPaused = false
        }
    }
    
    func pauseTrack() {
        if let timer = self.timer{
            timer.invalidate()
            delegate?.playerPaused()
        }else{
            isPaused = false
        }
    }
    
    func continueTrack() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTrackProgress), userInfo: nil, repeats: true)
        delegate?.playerContinue()
    }

    func playTrack(track : Track) {
        currentTrack = track
        setupTimer()
        delegate?.currentTrack(track: track)
        
        if let index = nextTracks.firstIndex(of: track){
            nextTracks.remove(at: index)
        }
    }
    
    func playNextTrack() {
        guard let track = self.getNextTrack() else {return}
        self.playTrack(track: track)
    }
    
    func playPreviousTrack() {
        guard let track = self.getPreviousTrack() else {return}
        self.playTrack(track: track)
    }
    
    func playAgain(){
        self.nextTracks = self.playList
        self.playNextTrack()
    }

    @objc func updateTrackProgress(){
        // check if current track exists otherwise invalidate timer
        guard let track = self.currentTrack else {resetTimer(); return}
        
        if let duration = track.duration, currentTime < Int(duration) {
            currentTime += 1
            delegate?.updateTrackProgress(progress: Float(Float(currentTime)/Float(duration)), time: currentTime)
        }else {
            playNextTrack()
        }
    }
    
    func getPreviousTrack() -> Track? {
        if let lastTrack = previousTracks.last {
            previousTracks.removeLast()
            return lastTrack
        }
        return nil
    }
    
    func getNextTrack() -> Track? {
        
        if let track = currentTrack {
            previousTracks.append(track)
        }
        
        guard nextTracks.count > 0 else {
            // notify songs finished
            resetPlayer()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FinishedPlayList"), object: nil)
            return nil
        }
        
        var nextTrackIndex = Int.random(in: 0 ... nextTracks.count - 1)
        var nextTrack = nextTracks[nextTrackIndex]
        
        while currentTrack == nextTrack && (nextTracks.count > 1) {
            nextTrackIndex = Int.random(in: 0 ... nextTracks.count - 1)
            nextTrack = nextTracks[nextTrackIndex]
        }
        
        currentTrack = nextTrack
        nextTracks.remove(at: nextTrackIndex)
        return nextTrack
    }
    
    
    //MARK: PlayLists functions
    func addTrackToPlaylist(track: Track){
       self.playList.append(track)
       self.nextTracks.append(track)
    }
    
    func removeTrackfromPlayList(track: Track) -> Bool {
        if let trackIndex = self.playList.firstIndex(of: track) {
            self.playList.remove(at: trackIndex)
            
            if let nextTrackIndex = self.nextTracks.firstIndex(of: track){
                self.nextTracks.remove(at: nextTrackIndex)
            }
            
            return true
        }
    
        return false
    }
    

    //MARK: Player Reset
    func resetPlayer(){
        timer?.invalidate()
        currentTime = 0
        isPlaying = false
    }
    
    //MARK: Timer Functions
    fileprivate func setupTimer() {
        resetTimer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTrackProgress), userInfo: nil, repeats: true)
        isPaused = false
    }
    
    fileprivate func resetTimer() {
        if let timer = self.timer{
            timer.invalidate()
            currentTime = 0
        }
    }
}
