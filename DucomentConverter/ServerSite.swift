//
//  ServerSite.swift
//  DucomentConverter
//
//  Created by tony on 2017/7/6.
//  Copyright © 2017年 chengkaizone. All rights reserved.
//

import Cocoa

class ServerSite: NSObject {
    
    
    var name: String!
    var type: String!
    // 社区街道
    var street: String!
    var contact: String!
    var telephone: String!
    var addr: String!
    var latitude: String!
    var longitude: String!
    
    override init() {
        super.init()
        
        
    }
    
    // 根据一行数据初始化
    convenience init(line: String) {
        self.init()
        
        let arr = line.components(separatedBy: "\t")

        self.name = arr[0]
        self.type = arr[1]
        self.street = arr[2]
        self.contact = arr[3]
        self.telephone = arr[4]
        self.addr = arr[5]
        self.latitude = arr[6]
        self.longitude = arr[7]
        
//        self.name = arr[0]
//        self.type = arr[1]
//        //self.street = arr[2]
//        self.contact = arr[2]
//        self.telephone = arr[3]
//        self.addr = arr[4]
//        self.latitude = arr[5]
//        self.longitude = arr[6]
        
    }
    
    func htmlString() -> String {
        
        var phone: String = telephone
        
        if phone == "11111111" {
            phone = " "
        }
        return "[\(longitude!),\(latitude!), \"\(name!) <br>地址: \(addr!) <br>电话: \(phone) \", \"\(name!)\"], \r\n"
    }
    
    
    
    func frameString() -> String {
        
        return "<IFRAME></IFRAME>\r\n<li><a href=\"javascript:void(0)\" onclick=\"LocalSet(0)\">\(name!) </a></li>\r\n"
    }
    
}
