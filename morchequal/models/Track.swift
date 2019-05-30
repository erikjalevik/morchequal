//
//  Track.swift
//  morchequal
//
//  Created by Erik Jälevik on 29.05.19.
//  Copyright © 2019 Fileside. All rights reserved.
//

/* The API response for one track looks like this:
{
    artistId = 161916;
    artistName = Morcheeba;
    artistViewUrl = "https://music.apple.com/us/artist/morcheeba/161916?uo=4";
    artworkUrl100 = "https://is5-ssl.mzstatic.com/image/thumb/Music/v4/c3/8a/af/c38aafcc-4c03-2147-a445-14cbf26df561/source/100x100bb.jpg";
    artworkUrl30 = "https://is5-ssl.mzstatic.com/image/thumb/Music/v4/c3/8a/af/c38aafcc-4c03-2147-a445-14cbf26df561/source/30x30bb.jpg";
    artworkUrl60 = "https://is5-ssl.mzstatic.com/image/thumb/Music/v4/c3/8a/af/c38aafcc-4c03-2147-a445-14cbf26df561/source/60x60bb.jpg";
    collectionCensoredName = "Blood Like Lemonade";
    collectionExplicitness = notExplicit;
    collectionId = 399488301;
    collectionName = "Blood Like Lemonade";
    collectionPrice = "6.93";
    collectionViewUrl = "https://music.apple.com/us/album/blood-like-lemonade/399488301?i=399488316&uo=4";
    country = USA;
    currency = USD;
    discCount = 1;
    discNumber = 1;
    isStreamable = 1;
    kind = song;
    previewUrl = "https://audio-ssl.itunes.apple.com/apple-assets-us-std-000001/Music/6f/8e/61/mzm.ottyrdgx.aac.p.m4a";
    primaryGenreName = Pop;
    releaseDate = "2010-06-07T07:00:00Z";
    trackCensoredName = "Blood Like Lemonade";
    trackCount = 7;
    trackExplicitness = notExplicit;
    trackId = 399488316;
    trackName = "Blood Like Lemonade";
    trackNumber = 1;
    trackPrice = "0.99";
    trackTimeMillis = 291293;
    trackViewUrl = "https://music.apple.com/us/album/blood-like-lemonade/399488301?i=399488316&uo=4";
    wrapperType = track;
}
*/

struct Track: Decodable {
    let artist: String
    let name: String
    let artworkUrl: String
    let album: String
    let kind: String
    let releaseDate: String

    enum CodingKeys: String, CodingKey {
        case artist = "artistName"
        case name = "trackName"
        case artworkUrl = "artworkUrl100"
        case album = "collectionName"
        case kind = "kind"
        case releaseDate = "releaseDate"
    }
}
