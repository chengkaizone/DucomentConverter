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
    
    /** 转换成为可直接拷贝到excel的文本 */
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
    
    /** 从自己准备好的文本中读取, 文本格式如下
     * title
     * content
     *
     * title
     * content
     */
    class func parse(text: String?, splitStr: String = "\n\n", keywords: String, markSerial: Int32) ->[CommentInfo] {
        
        guard let str = text else {
            return [CommentInfo]()
        }
        
        var commentData = [CommentInfo]()
        let lineStrs = str.components(separatedBy: "\n\n")

        for i in 0 ..< lineStrs.count {
            
            let lineStr = lineStrs[i]
            
            if lineStr == "" {
                continue
            }
            
            NSLog("line result:  \(i)   >>|\(lineStr)|<")
            let info = CommentInfo(line: lineStr, keywords: keywords, markSerial: markSerial)
            
            commentData.append(info)
        }
        
        var tmpData: [CommentInfo] = [CommentInfo]()
        for info in commentData {
            if info.content.characters.count < 10 || info.content.contains("该条评论已经被删除") {
                tmpData.append(info)
            }
        }
        NSLog("获取到的无效效记录数：\(tmpData.count)")
        
        for info in tmpData {
            
            if let index = commentData.index(of: info) {
                commentData.remove(at: index)
            }
        }
        
        NSLog("获取到的有效记录数：\(commentData.count)")
        
        return commentData
    }
    
    
    // 从excel中获取的数据读取
    class func parse(from excelString: String?, splitStr: String = "\n", keywords: String, markSerial: Int32) -> [CommentInfo] {
        
        guard let str = excelString else {
            return [CommentInfo]()
        }
        
        var commentData = [CommentInfo]()
        
        let lineStrs = str.components(separatedBy: splitStr)
        
        var lineCount: Int32 = 0
        
        var title: String!
        var content: String!
        
        for i in 0 ..< lineStrs.count {
            let lineStr = lineStrs[i]
            if lineStr == "" {
                continue
            }
            
            NSLog("line result:  \(i)   >>|\(lineStr)|<")
            if lineCount % 2 == 0 {// 获取到title
                title = lineStr
            } else {
                content = lineStr
            }
            
            
            if title != nil && content != nil {
                let info = CommentInfo(keywords: keywords, markSerial: markSerial)
                info.title = title
                info.content = content
                
                commentData.append(info)
                title = nil
                content = nil
            }
            
            lineCount += 1
        }
        
        var tmpData: [CommentInfo] = [CommentInfo]()
        for info in commentData {
            if info.content.characters.count < 10 || info.content.contains("该条评论已经被删除") {
                tmpData.append(info)
            }
        }
        
        NSLog("获取到的无效效记录数：\(tmpData.count)")
        
        for info in tmpData {
            
            if let index = commentData.index(of: info) {
                commentData.remove(at: index)
            }
        }
        
        NSLog("获取到的有效记录数：\(commentData.count)")
        
        return commentData
    }
    
    /** 直接导出 */
    class func parseToString(from excelString: String?, keywords: String, markSerial: Int32) -> ([CommentInfo], String) {
        
        guard let str = excelString else {
            return ([CommentInfo](), "")
        }
        
        var commentData = CommentInfo.parse(from: excelString, keywords: keywords, markSerial: markSerial)
        
        var result: String = ""
        for info in commentData {
            result.append(info.lineString())
        }
        
        return (commentData, result)
    }
    
    class func parse(from itunesString: String) ->[CommentInfo] {
        
        
//        {
//            "feed": {
//                "entry": [
//                {
//                "attributes": {
//                "amount": "0.00000",
//                "currency": "CNY"
//                }
//                },
//                {
//                "author": {
//                "uri": {
//                "label": "https://itunes.apple.com/cn/reviews/id633600581?l=en"
//                },
//                "name": {
//                "label": "无言情话_"
//                },
//                "label": ""
//                },
//                "title": {
//                "label": "可以用，不错。"
//                },
//                "content": {
//                "label": "现在每天必开的应用之一  我不解释了，就是好",
//                "attributes": {
//                "type": "text"
//                }
//                }
//                }
//                ]
//            }
//        }
        
        return [CommentInfo]()
    }

}
