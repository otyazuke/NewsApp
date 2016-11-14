//
//  OGPResponse.swift
//  NewsApp
//
//  Created by 鶴田拓也 on 2016/11/07.
//  Copyright © 2016年 Takuya Tsuruda. All rights reserved.
//

import Foundation
import ObjectMapper

class OGPResponse: Mappable {
    var image: String?
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        image <- map["image"]
    }
    
}
