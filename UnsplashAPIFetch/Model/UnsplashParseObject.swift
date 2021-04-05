//
//  UnsplashParseObject.swift
//  UnsplashAPIFetch
//
//  Created by Ayu Filippova on 21/11/2019.
//  Copyright © 2019 Dmitry Filippov. All rights reserved.
//

import UIKit

struct UnsplashParseObject: Decodable {
    let total: Int
    let total_pages: Int
    let results: [UnsplashItem]
    
    enum CodingKeys: String, CodingKey {
        case total
        case total_pages
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.total = try container.decode(Int.self, forKey: .total)
        self.total_pages = try container.decode(Int.self, forKey: .total_pages)
        self.results = try container.decode([UnsplashItem].self, forKey: .results)
    }
}

class UnsplashItem: Decodable {
    let id: String
    let created_at: String
    let description: String?
    let alt_description: String?
    let urls: SizeUrl
    let user: UnsplashUser
    var image: UIImage?
    var searchQuery: String!
    
    enum CodingKeys: String, CodingKey {
        case id
        case created_at
        case description
        case alt_description
        case urls
        case user
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.created_at = try container.decode(String.self, forKey: .created_at)
        self.description = try? container.decode(String.self, forKey: .description)
        self.alt_description = try? container.decode(String.self, forKey: .alt_description)
        self.urls = try container.decode(SizeUrl.self, forKey: .urls)
        self.user = try container.decode(UnsplashUser.self, forKey: .user)
//        self.image = UIImage(named: "defaultImage")
    }
}
    
class SizeUrl: NSObject, NSCoding, Decodable {
    
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String

    enum CodingKeys: String, CodingKey {
        case raw
        case full
        case regular
        case small
        case thumb
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(raw, forKey: SizeUrl.CodingKeys.raw.rawValue)
        coder.encode(full, forKey: SizeUrl.CodingKeys.full.rawValue)
        coder.encode(regular, forKey: SizeUrl.CodingKeys.regular.rawValue)
        coder.encode(small, forKey: SizeUrl.CodingKeys.small.rawValue)
        coder.encode(thumb, forKey: SizeUrl.CodingKeys.thumb.rawValue)
    }
    
    required init?(coder: NSCoder) {
        self.raw = coder.decodeObject(forKey: CodingKeys.raw.rawValue) as! String
        self.full = coder.decodeObject(forKey: CodingKeys.full.rawValue) as! String
        self.regular = coder.decodeObject(forKey: CodingKeys.regular.rawValue) as! String
        self.small = coder.decodeObject(forKey: CodingKeys.small.rawValue) as! String
        self.thumb = coder.decodeObject(forKey: CodingKeys.thumb.rawValue) as! String
    }
    
//    func encode(to encoder: Encoder) {
//        var container = encoder.container(keyedBy: SizeUrl.CodingKeys.self)
//
//        do {
//            try container.encode(self.raw, forKey: SizeUrl.CodingKeys.raw)
//            try container.encode(self.full, forKey: SizeUrl.CodingKeys.full)
//            try container.encode(self.regular, forKey: SizeUrl.CodingKeys.regular)
//            try container.encode(self.small, forKey: SizeUrl.CodingKeys.small)
//            try container.encode(self.thumb, forKey: SizeUrl.CodingKeys.thumb)
//        } catch let error as NSError? {
//            print(#line, #function, "Error while encoding \(self): \(error)")
//        }
//    }

//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: SizeUrl.CodingKeys.self)
//
//        self.raw = try container.decode(String.self, forKey: .raw)
//        self.full = try container.decode(String.self, forKey: .full)
//        self.regular = try container.decode(String.self, forKey: .regular)
//        self.small = try container.decode(String.self, forKey: .small)
//        self.thumb = try container.decode(String.self, forKey: .thumb)
//    }
}

class UnsplashUser: NSObject, NSCoding, Decodable {
    
    let name: String
    let portfolio_url: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case portfolio_url
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: CodingKeys.name.rawValue)
        coder.encode(portfolio_url, forKey: CodingKeys.portfolio_url.rawValue)
    }
    
    required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: CodingKeys.name.rawValue) as! String
        self.portfolio_url = coder.decodeObject(forKey: CodingKeys.portfolio_url.rawValue) as? String
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.portfolio_url = try? container.decode(String.self, forKey: .portfolio_url)
    }
}
