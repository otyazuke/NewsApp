//
//  PagingMenuController_1.swift
//  NewsApp
//
//  Created by 鶴田拓也 on 2016/10/26.
//  Copyright © 2016年 Takuya Tsuruda. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import ObjectMapper

class PagingMenuController_1: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var lists : Results<Entry>!
    var entries : [(Entry)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self

        Alamofire.request("https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://menthas.com/top/rss").responseJSON { response in
            guard let object = response.result.value else {
                return
            }
            let json = JSON(object)
            let entries = json["responseData"]["feed"]["entries"]
            
//            print(Realm.Configuration.defaultConfiguration.fileURL!)
            
            
            try! uiRealm.write {
                for (_, subJson) in entries {
                    if let entry = Mapper<Entry>().map(JSONObject: subJson.dictionaryObject) {
                        entry.category = "top"
                        uiRealm.add(entry, update: true)
                    }
                }
            }
            self.updateTableView()
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let entries = entries {
            print("+++++++++++")
            print(entries)
            print("+++++++++++")
            return entries.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        
        let entry = entries![indexPath.row]
        //cell.textLabel?.text = entry["title"]
        print(entry)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "セクションタイトル"
    }
    
    
    
    func updateTableView() {
        
//        do {
//            self.entries = try Realm().objects(Entry.self).sorted(by: { (entry1, entry2) -> Bool in
//                let res = entry1.publishedDate.compare(entry2.publishedDate)
//                return (res == .orderedAscending || res == .orderedSame)
//            })
//        }catch {}
        
        tableView.reloadData()
    }

}
