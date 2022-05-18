//
//  Track.swift
//  MyMusic
//
//  Created by Tarun Kaushik on 07/11/20.
//

import Foundation

struct Track: Codable {

    let title: String?
    let imageUrl: String?
    let duration: Double?
    let genre: String?

    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case title
        case duration
        case genre
    }

}

extension Track: Equatable {
    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.title == rhs.title && lhs.duration == rhs.duration && lhs.imageUrl == rhs.imageUrl && lhs.genre == rhs.genre
    }
}
