//
//  TableViewCell.swift
//  NewsApp
//
//  Created by 鶴田拓也 on 2016/11/03.
//  Copyright © 2016年 Takuya Tsuruda. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellText: UILabel!
    
    var link:String! {
        didSet{
            Alamofire.request(ArticleAPI.ogpImage + link).responseJSON {response in
                guard let ogpResponse = response.result.value else {
                    return
                }
                let ogpResponseJson = JSON(ogpResponse)
                if ogpResponseJson["image"] == nil {
                    return
                }
                let imageUrl: NSURL?
                imageUrl = NSURL(string: ogpResponseJson["image"].string!)
                self.setThumbnailWithFadeInAnimation(imageUrl: imageUrl)
            }
        }
    }
    
    func setThumbnailWithFadeInAnimation(imageUrl: NSURL!){
        do {
            var imageData = try Data(contentsOf: imageUrl as URL)
            var image = UIImage(data: imageData)
            self.cellImage.image = image
        }catch{
            print("サムネ取得失敗")
        }
        
        
    }
    
    func configure(entry: Entry){
        cellTitle.text = entry.title
        cellText.text = entry.contentSnippet
        self.link = entry.link
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}





//{ response in
//    var imageUrl: NSURL?
//    let ogpResponse = response.result.value
//    if let ogpResponseJson:JSON = JSON(ogpResponse)["image"] {
//        imageUrl = NSURL(ogpResponseJson as String)
//    }
//    
//}
