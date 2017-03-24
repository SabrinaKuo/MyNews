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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath)
        let article = self.Articles[indexPath.row]
        
        cell.textLabel?.text = article.heading
        cell.accessoryType = .disclosureIndicator
        
        let publishedDate = article.publishedDate
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell.detailTextLabel?.text = dateFormatter.string(from: publishedDate!)
        
        return cell
    }

    
    
}
