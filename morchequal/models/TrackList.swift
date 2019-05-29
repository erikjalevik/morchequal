//
//  TrackList.swift
//  morchequal
//
//  Created by Erik Jälevik on 29.05.19.
//  Copyright © 2019 Fileside. All rights reserved.
//

import Foundation

struct TrackList: Decodable {
    let results: [Track]
    let resultCount: Int
}
