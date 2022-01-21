//
//  DetailProgramme.swift
//  OCS
//
//  Created by aymen braham on 21/01/2022.
//

import Foundation

struct ResponsDetailProgramme: Decodable {
    let contents: Seasons?
    
    private enum CodingKeys: String, CodingKey {
        case contents = "contents"
    }
}

struct Seasons: Decodable {
    let seasons: [DetailProgramme?]?
    let pitch: String?
    
    private enum CodingKeys: String, CodingKey {
        case seasons = "seasons"
        case pitch
        
    }
}

struct DetailProgramme: Decodable {
    let pitch: String
    
    private enum CodingKeys: String, CodingKey {
        case pitch
    }
    
}
