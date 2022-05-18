//
//  AllTracksView.swift
//  MyMusic
//
//  Created by Tarun Kaushik on 07/11/20.
//

import UIKit

class AllTracksView: UIView {

    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    private var isInitiated: Bool = false
    
    enum State: Int {
        case initial, loading, update
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if !isInitiated{
            setup()
            isInitiated = true
        }
    }
    
    func updateState(_ state: State) {
        switch state {
        case .initial:
            self.setup()
            self.tracksTableView.isHidden = true
            self.progressIndicator.isHidden = true
            break
        
        case .loading:
            self.tracksTableView.isHidden = true
            self.progressIndicator.isHidden = true
            self.progressIndicator.startAnimating()
            break
            
        case .update:
            updateResults()
            self.tracksTableView.isHidden = false
            self.progressIndicator.isHidden = true
            self.progressIndicator.stopAnimating()
            break
        }
    }
    
    func updateResults() {
        DispatchQueue.main.async {
            self.tracksTableView.reloadData()
        }
    }
    
    func setup() {
        let nib = UINib(nibName: "TrackTableViewCell", bundle: nil)
        tracksTableView.register(nib, forCellReuseIdentifier: "Cell")
    }

}
