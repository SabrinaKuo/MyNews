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
    
    @IBOutlet weak var newsImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downNewImage()
    }
    
    func downNewImage(){
        
        let image = UIImage(data: NSData(contentsOf: article.imageURL!)as! Data)
        self.newsImage.image = image
        print("downimage finish")
    }

}
