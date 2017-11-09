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
    
    var keywords: String = "单位转换计算器"
    var markSerial: Int32 = 24
    
    var pageIndex: Int32 = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNetworkData(appid: "xxx", page: pageIndex)
    }
    
    fileprivate func setupData() {
        
        let path = Bundle.main.path(forResource: "content", ofType: "txt")!
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let result = String.init(data: data, encoding: String.Encoding.utf8)
            readTextView.string = result
        } catch let error {
        }
    }
    
    fileprivate func setupNetworkData(appid: String, page: Int32) {
        
        var url = "https://itunes.apple.com/rss/customerreviews/page=\(page)/id=\(appid)/sortby=mostrecent/json?l=en&&cc=cn"
        
        var request = URLRequest(url: URL(string: url)!, cachePolicy: URLRequest.CachePolicy(rawValue: 1)!, timeoutInterval: 5)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: {[weak self] (data: Data?, response: URLResponse?, error: Error?) in
            
            NSLog("返回结果: \(self!.pageIndex) ")
            if error != nil {
                NSLog("error: \(error!.localizedDescription)")
                return
            }
            
            if let data = data {
                if let result = String(data: data, encoding: String.Encoding.utf8) {
                    
                    print("返回结果: \(result)")
                    
                    DispatchQueue.main.async {
                        self!.pageIndex += 1
                        if self!.pageIndex < 100 {
                            self?.setupNetworkData(appid: "1122050795", page: self!.pageIndex)
                        }
                        
                    }
                    
                }
            }
        }).resume()
        
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    @IBAction func readAction(_ sender: Any) {
        
        let commentData = CommentInfo.parse(from: readTextView.string, keywords: keywords, markSerial: markSerial)
        countLabel.stringValue = "有效记录：\(commentData.count)"
    }
    
    @IBAction func outAction(_ sender: Any) {
        
        let (commentData, result) = CommentInfo.parseToString(from: readTextView.string, keywords: keywords, markSerial: markSerial)
        
        countLabel.stringValue = "有效记录：\(commentData.count)"
        outTextView.string = result
        
        // 写入文件
        //NSLog("\(result)")
    }

}

