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
    
    @IBOutlet weak var contentTitle: UINavigationItem!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headingLabel.text = article.heading
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        publishDateLabel.text = dateFormatter.string(from: article.publishedDate)
        
        if let content = article.content {
            let newsContent = NSMutableAttributedString(string:content)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 5
            style.paragraphSpacing = 15;
            newsContent.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, newsContent.length))
            contentLabel.attributedText = newsContent
        } else {
            contentLabel.attributedText = nil
        }
        
        contentTitle.title = article.heading
        
        downloadImage()
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        createAlertSheet()
    }
    
    func createAlertSheet(){
        
        let actionSheet = UIAlertController()

        if let articleUrl = self.article.url {
            // share Line
            let shareLineAction = UIAlertAction(title: "Share on Line", style: .default) { (action) in
                print("Share Line button tapped")
                
                if let appUrl = URL(string: "line://msg/text/" + "\(articleUrl)") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
                    }
                } else {
                    let itunesURL = URL(string: "itms-apps://itunes.apple.com/app/id443904275")!
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(itunesURL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                }
                
            }
            // share Facebook
            let shareFBAction = UIAlertAction(title: "Share on Facebook", style: .default) { (action) in
                
                print("Share FB button tapped")
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                    let fbComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    fbComposeVC?.setInitialText("\(articleUrl)")
                    self.navigationController?.present(fbComposeVC!, animated: true, completion: nil)
                } else {
                    print("Please Login Facebook")
                }
                
            }
            // cancel
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                print("cancel button tapped")
            }
            
            actionSheet.addAction(shareLineAction)
            actionSheet.addAction(shareFBAction)
            actionSheet.addAction(cancelAction)
            
            self.navigationController?.present(actionSheet, animated: true) {
                
            }

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
