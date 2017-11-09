//
//  CommentInfo.swift
//  DucomentConverter
//
//  Created by tony on 2017/11/6.
//  Copyright © 2017年 chengkaizone. All rights reserved.
//

import Cocoa

class CommentInfo: NSObject {
    
    var title: String!
    var content: String!
    var keywords: String = ""
    // 标记序号
    var markSerial: Int32 = 0
    
    // 根据一行数据初始化
    init(keywords: String, markSerial: Int32) {

        self.title = ""
        self.content = ""
        
        self.keywords = keywords
        self.markSerial = markSerial
        
        super.init()
    }
    
    // 根据一行数据初始化
    init(line: String, keywords: String, markSerial: Int32) {
        let arr = line.components(separatedBy: "\n")
        
        self.title = arr[0].replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "")
        self.content = arr[1].replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "")
        
        self.keywords = keywords
        self.markSerial = markSerial
        
        super.init()
    }
    
    init(title: String, content: String, keywords: String, markSerial: Int32) {
        
        self.title = title
        self.content = content
        self.keywords = keywords
        self.markSerial = markSerial
        super.init()
    }
    
    func lineString() -> String {
 
        let encodedLength = self.content.endIndex.encodedOffset - self.content.startIndex.encodedOffset
        // 插入mark和关键词的位置
        var pos0 = Int(arc4random()) % (encodedLength * 4 / 5)
        var pos1 = Int(arc4random()) % (encodedLength * 4 / 5)
        
        pos0 = pos0 < pos1 ? pos0 : pos1
        if pos0 == pos1 {
            pos1 += 2
        }
        
        let posIndex0 = self.content.index(content.startIndex, offsetBy: pos0)
        let posIndex1 = self.content.index(content.startIndex, offsetBy: pos1)
        let start = self.content.substring(to: posIndex0)
        let middle = self.content.substring(with: posIndex0 ..< posIndex1)
        let end = self.content.substring(from: posIndex1)
        
        let tmpContent = start + "\(self.keywords)" + middle + "\(markSerial)" + end

        return tmpContent + "\t" + self.title + "\n"
    }

}
