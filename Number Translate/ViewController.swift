//
//  ViewController.swift
//  Number Translate
//
//  Created by xinyue-0 on 2016/12/16.
//  Copyright © 2016年 xinyue-0. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var chineseNum: String?
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapTranslate(_ sender: Any) {
        let translator = NumberAndChineseTranslator()
        if textField.text != "零" && (textField.text! as NSString).intValue == 0 {
            resultLabel.text = "\(translator.translateToNumber(in: textField.text!))"
        }else{
            resultLabel.text = translator.translateToChinese(in: textField.text!)
        }
    }
    
}




