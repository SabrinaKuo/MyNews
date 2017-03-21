//
//  ArticleListTableViewController.swift
//  MyNews
//
//  Created by Kuo Sabrina on 2017/3/20.
//  Copyright © 2017年 sabrinaApp. All rights reserved.
//

import UIKit

let apiURL = "https://hpd-iosdev.firebaseio.com/news/latest.json"
class ArticleListTableViewController: UITableViewController {
    
    let dateFormatter = DateFormatter()
    var Articles = [Article]()
        {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewsContent" {
            print("showNewsContent")
            let contentVC = segue.destination as! ArticleConentViewController
            contentVC.article = Articles[0]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayArticle()
    }
    
    func displayArticle(){
        let session = URLSession.shared
        let url = URL(string: apiURL)
        let task = session.dataTask(with: url!) { data, response, error in
            
            if let error = error {
                print("download API error \(error)")
                return
            }
            let data = data!
            if let jsonObject = try?JSONSerialization.jsonObject(with: data, options: .mutableContainers), let articles = jsonObject as? [[String: Any]] {
                
                if articles.count == 0 {
                    return
                }
                
                for article in articles {
                    let data = Article.init(data: article)
                    self.Articles.append(data)
                }
            }
            
            print("Download Finish!!")
        }
        
        task.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath)
        
        
        let article = self.Articles[indexPath.row]
        cell.textLabel?.text = article.heading
        
        let publishedDate = article.publishedDate
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell.detailTextLabel?.text = dateFormatter.string(from: publishedDate)
        
        return cell
    }
    
}
