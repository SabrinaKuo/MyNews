//
//  ArticleListTableViewController.swift
//  MyNews
//
//  Created by Kuo Sabrina on 2017/3/20.
//  Copyright © 2017年 sabrinaApp. All rights reserved.
//

import UIKit


class ArticleListTableViewController: UITableViewController {
    
    let dateFormatter = DateFormatter()
    var selectArticle: Article!
    
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
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            
            let contentVC = segue.destination as! ArticleConentViewController
            contentVC.article = Articles[(indexPath?.row)!]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadLatestArticles()
    }
    
    @IBAction func pullRefreshArticles(_ sender: Any) {
        print("Refresh Articles")
        
        downloadLatestArticles()
    }
    
    func downloadLatestArticles(){
        
        Article.downloadLatestArticles { articles, error in
            if error != nil {
                return
            }
            
            self.refreshControl?.endRefreshing()
            self.Articles = articles!
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleTableViewCell
        let article = self.Articles[indexPath.row]
        
        cell.titleLabel.text = article.heading
        
        let publishedDate = article.publishedDate
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell.timeLabel?.text = dateFormatter.string(from: publishedDate!)
        
        if let url = article.imageURL {
            
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    debugPrint(error)
                    return
                }
                
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    cell.newsImageView.image = image
                }
            }
            task.resume()
        }
        
        return cell
    }
}

class ArticleTableViewCell: UITableViewCell {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
}
