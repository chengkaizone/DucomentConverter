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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    @IBAction func readAction(_ sender: Any) {
        
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
    
    @IBAction func outAction(_ sender: Any) {
        
        if self.data.count == 0 {
            
            return
        }
        
        var result: String = ""
        
        for site in self.data {
            
            result.append(site.htmlString())
        }
        
        outTextView.string = result
        
        // 写入文件
        
        
    }

}

