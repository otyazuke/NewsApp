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
import SafariServices

class PagingMenuController_1: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var lists : Results<Entry>!
    var entries : [(Entry)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")

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
        if let listEntries = lists{
            return listEntries.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        let entry = lists[indexPath.row] as Entry
        cell.configure(entry: entry)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "セクションタイトル"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        return cell.bounds.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let entry = lists[indexPath.row] as Entry
        let entry = lists[indexPath.row] as Entry
        let svc = SFSafariViewController(url: NSURL(string: entry.link)! as URL)
        self.present(svc, animated: true, completion: nil)
//        reloadRowsAtIndexPath(indexPath)
    }
    
    func updateTableView() {
        let predicate = NSPredicate(format: "category == %@", "top")
        lists = uiRealm.objects(Entry).filter(predicate)
        
        self.tableView.reloadData()
    }

}
