//
//  ArticleDataSource.swift
//  MyNews
//
//  Created by Kuo Sabrina on 2017/3/21.
//  Copyright © 2017年 sabrinaApp. All rights reserved.
//

import UIKit

let API_URL = "https://hpd-iosdev.firebaseio.com/news/latest.json"
class ArticleDataSource: NSObject, UITableViewDataSource {
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath)
        
        return cell
    }
}
