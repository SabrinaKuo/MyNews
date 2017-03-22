//
//  Article.swift
//  MyNews
//
//  Created by Kuo Sabrina on 2017/3/20.
//  Copyright © 2017年 sabrinaApp. All rights reserved.
//

import UIKit

class Article {
    let heading: String?
    let content: String?
    
    let category: String?
    let imageURL: URL?
    let publishedDate: Date!
    let url: URL!
    
    init(data: [String: Any]){
        heading = data["heading"] as? String
        content = data["content"] as? String
        category = data["category"] as? String
        
        imageURL = URL(string: data["imageUrl"] as! String)
        
        let date = data["publishedDate"] as! Double
        publishedDate = Date(timeIntervalSince1970: date/1000)
        
        url = URL(string: data["url"] as! String)
    }
}
