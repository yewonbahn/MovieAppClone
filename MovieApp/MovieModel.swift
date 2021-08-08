//
//  MovieModel.swift
//  MovieApp
//
//  Created by 반예원 on 2021/08/07.
//

import Foundation

struct MovieModel: Codable {
    let resultCount : Int
//    let results : [XXXX]
    let results : [Result]
}
struct Result : Codable {
    
    let trackName : String
    let previewUrl : String
    let image : String
    
    enum CodingKeys : String, CodingKey{
        case image = "artworkUrl100"
        case trackName
        case previewUrl 
    }
}
