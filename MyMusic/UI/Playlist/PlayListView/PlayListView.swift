//
//  PlayListView.swift
//  MyMusic
//
//  Created by Tarun Kaushik on 07/11/20.
//

import UIKit

class PlayListView: UIView {

    @IBOutlet weak var playListTableView: UITableView!
    
    enum State {
        case inital, refresh
    }
    
    func updateState(_ state: State) {
        switch state {
        case .inital:
            break
            
        case .refresh:
        playListTableView.reloadData()
        }
    }
    
    func setup() {
        let nib = UINib(nibName: "TrackTableViewCell", bundle: nil)
        playListTableView.register(nib, forCellReuseIdentifier: "Cell")
    }

}
