//
//  AllTracksViewController.swift
//  MyMusic
//
//  Created by Tarun Kaushik on 07/11/20.
//

import UIKit

class AllTracksViewController: UIViewController {
    
    private lazy var trackView: AllTracksView = {
        let view = Bundle.main.loadNibNamed("AllTracksView", owner: self, options: nil)?.first  as! AllTracksView
        view.setup()
        return view
    }()
    
    private var viewModel: AllTrackViewModel!
    
    override func loadView() {
        self.view = trackView
        viewModel = AllTrackViewModel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()

        // Do any additional setup after loading the view.
        viewModel.viewDidLoad()
        
        trackView.tracksTableView.dataSource = self
        trackView.tracksTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        trackView.updateState(.update)
    }
    
    private func setupViewModel() {
        
        viewModel.updateState = { [weak self] state in
            DispatchQueue.main.async {
                self?.trackView.updateState(state)
            }
        }
    }
}

extension AllTracksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.itemCounts()
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TrackTableViewCell
        if let track = viewModel.itemAt(index: indexPath.row) {
            cell.setTimeDuration(viewModel.getTrackTimeDuration(track: track))
            cell.inPlayList = viewModel.trackPresentInPlayList(track: track)
            cell.setupWith(track: track, index: indexPath.row)
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

extension AllTracksViewController: TrackCellDelegate {
    func didAddTrackAtIndex(track: Track, index: Int) {
        viewModel.addTrackToPlayList(track: track, index: index)
    }
    
    func didRemoveTrackAt(track: Track, index: Int) {
        viewModel.removeTrackFromPlayList(track: track, index: index)
    }
    
    func isPresentInPlaylist(track: Track) -> Bool {
        return viewModel.trackPresentInPlayList(track: track)
    }
}
