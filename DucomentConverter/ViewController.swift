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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupData()
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

