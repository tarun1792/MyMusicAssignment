//
//  TrackTableViewCell.swift
//  MyMusic
//
//  Created by Tarun Kaushik on 07/11/20.
//

import UIKit

protocol TrackCellDelegate: class {
    func didAddTrackAtIndex(track: Track,index: Int)
    func didRemoveTrackAt(track: Track,index: Int)
    func isPresentInPlaylist(track: Track) -> Bool
}

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    weak var delegate: TrackCellDelegate?
    var index: Int?
    var inPlayList: Bool = false
    var track: Track?
    let plusCircleFill = "plus.circle.fill"
    let minusCircleFill = "minus.circle.fill"
    
    func setupWith(track: Track, index: Int) {
        self.title.text = track.title
        self.subtitle.text = track.genre
        self.trackImage.downloadImage(url: track.imageUrl)
        self.index = index
        self.track = track
        
        if inPlayList {
            let image = UIImage(systemName: minusCircleFill)
            self.actionBtn.setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: plusCircleFill)
            self.actionBtn.setImage(image, for: .normal)
        }
    }
    
    func setTimeDuration(_ time: String){
        self.timeLabel.text = time
    }
    
    func setupforPlayListWith(track: Track, index: Int) {
        self.title.text = track.title
        self.subtitle.text = track.genre
        self.trackImage.downloadImage(url: track.imageUrl)
        self.index = index
        self.track = track
        
        let image = UIImage(systemName: minusCircleFill)
        self.actionBtn.setImage(image, for: .normal)
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        if inPlayList {
            let image = UIImage(systemName: plusCircleFill)
            self.actionBtn.setImage(image, for: .normal)
            delegate?.didRemoveTrackAt(track: self.track!, index: index!)
        }else{
            let image = UIImage(systemName: minusCircleFill)
            self.actionBtn.setImage(image, for: .normal)
            delegate?.didAddTrackAtIndex(track: self.track!, index: index!)
        }
        self.inPlayList = ((delegate?.isPresentInPlaylist(track: track!)) != nil)
    }
}
