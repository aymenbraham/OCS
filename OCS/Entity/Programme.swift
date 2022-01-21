//
//  Programme.swift
//  OCS
//
//  Created by aymen braham on 19/01/2022.
//

import Foundation

struct Programme: Decodable {
    let id: String
    let title: [Title]?
    let subtitle: String
    let imageURL: String?
    let fullScreenImageUrl: String?
    let detailLink: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title = "title"
        case subtitle = "subtitle"
        case imageURL = "imageurl"
        case fullScreenImageUrl = "fullscreenimageurl"
        case detailLink = "detaillink"
    }
}

struct Title: Decodable {
    let value: String
    private enum CodingKeys: String, CodingKey {
        case value
    }
}

struct ResponseProgrammes: Decodable {
    let template: String?
    let parentalrating : Int?
    let title: String?
    let offset: Int?
    let limit: String?
    let total: Int?
    let count: Int?
    let contents: [Programme]?
    
    private enum CodingKeys: String, CodingKey {
        case template
        case parentalrating
        case title
        case offset
        case limit
        case total
        case count
        case contents = "contents"
    }
}
