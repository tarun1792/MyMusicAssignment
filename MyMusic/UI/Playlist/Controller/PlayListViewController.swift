//
//  PlayListViewController.swift
//  MyMusic
//
//  Created by Tarun Kaushik on 07/11/20.
//

import UIKit

class PlayListViewController: UIViewController {
    
    private lazy var playlistView: PlayListView = {
        let view = Bundle.main.loadNibNamed("PlayListView", owner: self, options: nil)?.first  as! PlayListView
        view.setup()
        return view
    }()
    
    private var viewModel: PlayListViewModel!

    override func loadView() {
        self.view = playlistView
        viewModel = PlayListViewModel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup delegates
        playlistView.playListTableView.dataSource = self
        playlistView.playListTableView.delegate = self
        
        // Setup View Model
        setupViewModel()
    }
    
    func setupViewModel(){
        viewModel.updateState = {[weak self] state in
            self?.playlistView.updateState(state)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        playlistView.updateState(.refresh)
    }

}

extension PlayListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCounts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TrackTableViewCell
        if let track = viewModel.itemAt(index: indexPath.row) {
            cell.setTimeDuration(viewModel.getTrackTimeDuration(track: track))
            cell.setupforPlayListWith(track: track, index: indexPath.row)
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = viewModel.itemAt(index: indexPath.row)
        viewModel.playTrack(track: track)
    }
}

extension PlayListViewController: TrackCellDelegate {
    func didAddTrackAtIndex(track: Track, index: Int) {}
    
    func didRemoveTrackAt(track: Track, index: Int) {
        viewModel.removeTrackFromPlayList(track: track, index: index)
    }
    
    func isPresentInPlaylist(track: Track) -> Bool {
        return viewModel.trackPresentInPlayList(track: track)
    }
}


