//
//  ViewController.swift
//  NewsApp
//
//  Created by 鶴田拓也 on 2016/10/26.
//  Copyright © 2016年 Takuya Tsuruda. All rights reserved.
//

import UIKit
import PagingMenuController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let page_1 = self.storyboard?.instantiateViewController(withIdentifier: "PagingMenuController_1") as! PagingMenuController_1
        page_1.title = "1ページ目"
        
        let page_2 = self.storyboard?.instantiateViewController(withIdentifier: "PagingMenuController_2") as! PagingMenuController_2
        page_2.title = "2ページ目"
        
        let page_3 = self.storyboard?.instantiateViewController(withIdentifier: "PagingMenuController_3") as! PagingMenuController_3
        page_3.title = "3ページ目"
        
        let viewControllers = [page_1, page_2, page_3]
        
        
        let options = PagingMenuOptions()   //オプションをインスタンス化
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

