//
//  ArticleConentViewController.swift
//  MyNews
//
//  Created by sabrina.kuo on 2017/3/21.
//  Copyright © 2017年 sabrinaApp. All rights reserved.
//

import UIKit
import Social

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
        
        let newsContent = NSMutableAttributedString(string:article.content!)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.paragraphSpacing = 15;
        newsContent.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, newsContent.length))
        contentLabel.attributedText = newsContent
        
        
        downloadImage()
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        createAlertSheet()
    }
    
    func showActionSheet() {
        
    }
    
    func createAlertSheet(){
        let alertController = UIAlertController()
        let shareLineButton = UIAlertAction(title: "Share on Line", style: .default) { (action) in
            print("Share Line button tapped")
            
        }
        
        let shareFBButton = UIAlertAction(title: "Share on Facebook", style: .default) { (action) in
            print("Share FB button tapped")
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                let fbComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                //fbComposeVC?.setInitialText(String(url: article.url))
            }
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("cancel button tapped")
        }
        
        alertController.addAction(shareLineButton)
        alertController.addAction(shareFBButton)
        alertController.addAction(cancelButton)
        
        self.navigationController?.present(alertController, animated: true) { 
            
        }
    }
    
    func downloadImage(){
        
        let imageUrl = article.imageURL
        
        if let url = imageUrl {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, response, error in
                
                if let image = UIImage(data: data!){
                    DispatchQueue.main.async{
                        self.newsImage.image = image
                    }
                }
            }
            task.resume()
        }
        
    }

}
