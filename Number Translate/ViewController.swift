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
    
    let numArr = ["0","1","2","3","4","5","6","7","8","9"]
    let chineseNumArr = ["零","一","二","三","四","五","六","七","八","九"]
    let matchArr = ["","十","百","千"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapTranslate(_ sender: Any) {
//        resultLabel.text = TestNumTranslate.translationArabicNum(Int((textField.text! as NSString).intValue))
        if textField.text != "零" && (textField.text! as NSString).intValue == 0 {
            
        }else{
            resultLabel.text = translateToChinese()
        }
    }
    
    // mark: - Helper
    func translateToChinese() -> String {
        let originString = textField.text! as NSString
        var replaceArr = [String]()
        
        for i in 0..<originString.length {
            let singleNum = (originString.substring(with: NSMakeRange(i, 1)) as NSString).integerValue
            replaceArr.append(chineseNumArr[singleNum])
        }
        
        for index in 0..<replaceArr.count {
            if replaceArr[index] != "零" {
                replaceArr[index] += matchArr[(replaceArr.count - index - 1) % 4]
            }
            
            if replaceArr.count - 1 - index == 4 {
                replaceArr[index] += "万"
            }else if replaceArr.count - 1 - index == 8 {
                replaceArr[index] += "亿"
            }else if replaceArr.count - 1 - index == 12 {
                replaceArr[index] += "兆"
            }
        }
        
        var matchesStr = replaceArr.joined()
        var pattern = "零{1,}"
        matchesStr = matchesStr.replace(with: nil, length: nil, pattern: pattern, tempory: "零")!
        pattern = "零[万,亿,兆]|零$"
        matchesStr = matchesStr.replace(with: 0, length: 1, pattern: pattern, tempory: "f")!
//        pattern = "[万,亿,兆]零"
//        matchesStr = matchesStr.replace(with: 1, length: 1, pattern: pattern, tempory: "f")!
        matchesStr = (matchesStr as NSString).replacingOccurrences(of: "f", with: "")
        matchesStr = (matchesStr as NSString).replacingOccurrences(of: "亿万", with: "亿")
        matchesStr = (matchesStr as NSString).replacingOccurrences(of: "兆亿", with: "兆")
        
        return matchesStr
    }
    
    func translateToNumber() -> String {
        
    }
}



extension String {
    func replace(with offsite: Int?, length: Int?, pattern: String, tempory: String) -> String? {
        var str = self
        do{
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            if offsite == nil && length == nil{
                str = regex.stringByReplacingMatches(in: str, options: [], range: NSMakeRange(0, str.characters.count), withTemplate: tempory)
                return str
            }else{
                let results = regex.matches(in: str, options: [], range: NSMakeRange(0, str.characters.count))
                for result in results {
                    str = (str as NSString).replacingCharacters(in: NSMakeRange(result.range.location + offsite!, length!), with: tempory)
                }
                return str
            }
        }catch{
            print(error)
            return nil
        }
    }
}

