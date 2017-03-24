//
//  Article.swift
//  MyNews
//
//  Created by Kuo Sabrina on 2017/3/20.
//  Copyright © 2017年 sabrinaApp. All rights reserved.
//

import UIKit

let apiURL = "https://hpd-iosdev.firebaseio.com/news/latest.json"
class Article {
    let heading: String?
    let content: String?
    let category: String?
    let imageURL: URL?
    let publishedDate: Date!
    let url: URL!
    
    init(rawData: [String: Any]){
        heading = rawData["heading"] as? String
        content = rawData["content"] as? String
        category = rawData["category"] as? String
        
        let imageString = rawData["imageUrl"] as? String
        if imageString != nil {
            imageURL = URL(string: imageString!)
        } else {
            imageURL = nil
        }
        
        let date = rawData["publishedDate"] as! Double
        publishedDate = Date(timeIntervalSince1970: date/1000)
        url = URL(string: rawData["url"] as! String)
    }
    
    class func downloadLatestArticles(compeleteHandler: @escaping ([Article]?, Error?) -> Void){
        
        let url = URL(string: apiURL)
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { data, response, error in
            
            if let error = error {
                print("download API error \(error)")
                compeleteHandler(nil, error)
                return
            }
            
            let data = data!
            if let jsonObject = try?JSONSerialization.jsonObject(with: data, options: .mutableContainers), let articles = jsonObject as? [[String: Any]] {
                
                if articles.count == 0 {
                    return
                }
                
                let newArticles = articles.map{Article(rawData: $0)}
                compeleteHandler(newArticles, nil)
            }
        }
        task.resume()
    }

}
