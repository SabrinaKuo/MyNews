//
//  ArticleConentViewController.swift
//  MyNews
//
//  Created by sabrina.kuo on 2017/3/21.
//  Copyright © 2017年 sabrinaApp. All rights reserved.
//

import UIKit

class ArticleConentViewController: UIViewController {
    
    var article: Article!
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headingLabel.text = article.heading
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        publishDateLabel.text = dateFormatter.string(from: article.publishedDate)
        contentLabel.text = article.content
        
        downloadImage()
    }
    
    func downloadImage(){
        let image = UIImage(data: NSData(contentsOf: article.imageURL!)as! Data)
        self.newsImage.image = image
        print("downimage finish")
    }

}
