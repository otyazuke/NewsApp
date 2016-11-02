//
//  ViewController.swift
//  NewsApp
//
//  Created by 鶴田拓也 on 2016/10/26.
//  Copyright © 2016年 Takuya Tsuruda. All rights reserved.
//

import UIKit
import PagingMenuController
import Alamofire
import SwiftyJSON
import RealmSwift

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Dev News"
        
        let options = PagingMenuOptions()   //オプションをインスタンス化
        
        let pagingMenuController = PagingMenuController(options: options)
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
        
        
        var feeds: [Dictionary<String, String>] = [
            [
                "link": "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://menthas.com/top/rss",
                "title": "top"
            ],
            [
                "link": "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://menthas.com/ruby/rss",
                "title": "ruby"
            ],
            [
                "link": "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://menthas.com/ios/rss",
                "title": "ios"
            ],
            [
                "link": "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://menthas.com/infrastructure/rss",
                "title": "infrastructure"
            ]
        ]
        
        
        Alamofire.request("https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://menthas.com/ios/rss").responseJSON { response in
            guard let object = response.result.value else {
                return
            }
            let json = JSON(object)
            let entries = json["responseData"]["feed"]["entries"]
            
            let uiRealm = try! Realm()
            try! uiRealm.write {
                entries.forEach({ (_, entry) in
                    print("+++++++++")
                    print(entry["title"].string)
                    print("+++++++++")
                })
            }
        }
        
        
//        Alamofire.request(.GET, fetchFrom).responseObject("responseData") { (response: Alamofire.Response<FeedResponse, NSError>) in
//            
//            guard let entries = response.result.value?.feed?.entries else {
//                return
//            }
//            
//            print(entries)
//            print("Our default realm is located at \(RLMRealm.defaultRealm().path)")
//            
//            //この後、取得した記事をRealmに保存
//            
//        }
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


struct PagingMenuOptions: PagingMenuControllerCustomizable {
    var componentType: ComponentType {
        let page_1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PagingMenuController_1") as! PagingMenuController_1
        
        let page_2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PagingMenuController_2") as! PagingMenuController_2
        
        let page_3 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PagingMenuController_3") as! PagingMenuController_3
        
        let viewControllers = [page_1, page_2, page_3]
        
        return .all(menuOptions: MenuOptions(), pagingControllers: viewControllers)
    }
    
    struct MenuOptions: MenuViewCustomizable {
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2(), MenuItem3()]
        }
    }
    
    internal struct MenuItem1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "1ページ目"))
        }
    }
    internal struct MenuItem2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "2ページ目"))
        }
    }
    internal struct MenuItem3: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "3ページ目"))
        }
    }
}
