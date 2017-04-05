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
        
        if let url = article.imageURL {
            
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    debugPrint(error)
                    return
                }
                
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    cell.imageView?.image = image
                    cell.imageView?.contentMode = .scaleAspectFit
                    
                    let itemSize = CGSize(width: 64, height: 36)
                    UIGraphicsBeginImageContextWithOptions(itemSize, false, 0.0)
                    let imageRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
                    image?.draw(in: imageRect)
                    cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
//                    let sw=50/(cell.imageView?.image?.size.width)!
//                    let sh=50/(cell.imageView?.image?.size.height)!
//                    cell.imageView?.transform=CGAffineTransform(scaleX: sw,y: sh)
                }
            }
            task.resume()
        }
        
        return cell
    }

    
    
}
