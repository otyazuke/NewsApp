//
//  Entry.swift
//  NewsApp
//
//  Created by 鶴田拓也 on 2016/11/03.
//  Copyright © 2016年 Takuya Tsuruda. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class Entry: Object, Mappable {
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    dynamic var title = ""
    dynamic var link = ""
    dynamic var contentSnippet = ""
    dynamic var category = ""
    
    
    required convenience init?(map: ObjectMapper.Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        link <- map["link"]
        contentSnippet <- map["contentSnippet"]
    }
    
    override class func primaryKey() -> String {
        return "link"
    }

    
}

class EntryDateTransform : DateTransform {
    override func transformFromJSON(_ value: Any?) -> Date? {
        if let dateStr = value as? String {
            return Date.dateWithString(
                dateStr,
                format: "E, dd MMM yyyy HH:mm:ss zzzz" ,
                locale : Locale(identifier: "en_US"))
        }
        return nil
    }
}

extension Date {
    public static func dateWithString(_ dateStr : String? , format : String, locale : Locale) ->Date? {
        
        guard let dateStr = dateStr else {
            return nil
        }
        let df : DateFormatter = DateFormatter()
        df.locale = Locale(identifier: "en_US")
        df.timeZone = TimeZone.current
        df.dateFormat = format
        return df.date(from: dateStr)
    }
}
