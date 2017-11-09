//
//  ViewController.swift
//  DucomentConverter
//
//  Created by tony on 2017/7/6.
//  Copyright © 2017年 chengkaizone. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var readTextView: NSTextView!
    @IBOutlet weak var outTextView: NSTextView!
    
    @IBOutlet weak var countLabel: NSTextField!
    
    var data: [ServerSite]!
    
    var keywords: String = "单位转换计算器"
    var markSerial: Int32 = 24
    var commentData: [CommentInfo]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.readComment()
    }
    
    fileprivate func readComment() {
        
        self.commentData = [CommentInfo]()
        let path = Bundle.main.path(forResource: "content", ofType: "txt")!
        NSLog("path: \(path)")
        do {
            
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let result = String.init(data: data, encoding: String.Encoding.utf8)
            
            readTextView.string = result
        } catch let error {
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    fileprivate func readCommentStr() {
        
        guard let str = readTextView.string else {
            
            return
        }
        
        self.commentData.removeAll()
        
        let lineStrs = str.components(separatedBy: "\n\n")
        
        countLabel.stringValue = String(lineStrs.count)
        
        for i in 0 ..< lineStrs.count {
            
            let lineStr = lineStrs[i]
            
            if lineStr == "" {
                continue
            }
            
            NSLog("line result:  \(i)   >>|\(lineStr)|<")
            let info = CommentInfo(line: lineStr, keywords: keywords, markSerial: markSerial)
            
            self.commentData.append(info)
        }
    }
    
    // 从excel中获取的数据读取
    fileprivate func readCommentStr2() {
        
        guard let str = readTextView.string else {
            
            return
        }
        
        self.commentData.removeAll()
        
        let lineStrs = str.components(separatedBy: "\n")
        
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
                
                self.commentData.append(info)
                
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
        
        countLabel.stringValue = String(commentData.count)
    }

    
    @IBAction func readAction(_ sender: Any) {
        
        self.readCommentStr2()
    }
    
    @IBAction func outAction(_ sender: Any) {
        
        if self.commentData.count == 0 {
            
            return
        }
        
        var result: String = ""
        for info in self.commentData {
            result.append(info.lineString())
        }
        outTextView.string = result
        // 写入文件
        
        //NSLog("\(result)")
    }
    
    fileprivate func readServerSite() {
        
        guard let str = readTextView.string else {
            
            return
        }
        
        self.data.removeAll()
        
        let lineStrs = str.components(separatedBy: "\r\n")
        
        countLabel.stringValue = String(lineStrs.count)
        
        for i in 0 ..< lineStrs.count {
            
            let lineStr = lineStrs[i]
            
            if lineStr == "" {
                continue
            }
            
            NSLog("line result:  \(i)   >|\(lineStr)|<")
            let obj = ServerSite(line: lineStr)
            
            self.data.append(obj)
        }
        
    }
    
    fileprivate func testServerSite() {
        self.data = [ServerSite]()
        
        let path = Bundle.main.path(forResource: "serversite", ofType: "txt")!
        
        NSLog("path: \(path)")
        
        do {
            
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            
            let result = String.init(data: data, encoding: String.Encoding.utf8)
            
            NSLog("result: \(result)")
            
            readTextView.string = result
            
            
            //readTextView.textStorage?.append(result)
        } catch let error {
            
        }
    }
    
    fileprivate func exportServerSite() {
        if self.data.count == 0 {
            
            return
        }
        
        var result: String = ""
        
        for site in self.data {
            
            result.append(site.htmlString())
        }
        
        outTextView.string = result
    }

}

