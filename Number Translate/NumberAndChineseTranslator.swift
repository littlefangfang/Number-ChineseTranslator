//
//  NumberAndChineseTranslator.swift
//  Number Translate
//
//  Created by xinyue-0 on 2016/12/17.
//  Copyright © 2016年 xinyue-0. All rights reserved.
//

import UIKit

class NumberAndChineseTranslator: NSObject {
    
    let numArr = ["0","1","2","3","4","5","6","7","8","9"]
    let chineseNumArr = ["零","一","二","三","四","五","六","七","八","九"]
    let unitArr = ["个","十","百","千"]
    let bigUnitArr = ["个","万","亿","兆"]
    
    // mark: - Helper
    /// 把数字转化成文字
    ///
    /// - Parameter string: 需要转化的数字字符串
    /// - Returns: 转化成的文字
    func translateToChinese(in string: String) -> String {
        let originString = string.trimmingCharacters(in: CharacterSet.whitespaces) as NSString
        var replaceArr = [String]()
        
        for i in 0..<originString.length {
            let singleNum = (originString.substring(with: NSMakeRange(i, 1)) as NSString).integerValue
            replaceArr.append(chineseNumArr[singleNum])
        }
        
        for index in 0..<replaceArr.count {
            if replaceArr[index] != "零" {
                replaceArr[index] += unitArr[(replaceArr.count - index - 1) % 4]
            }
            
            let idx = replaceArr.count - 1 - index
            if idx == 4 || idx == 8 || idx == 12 {
                let bigUnitIndex = idx / 4 - 1
                replaceArr[index] += bigUnitArr[bigUnitIndex + 1]
            }
        }
        
        var matchesStr = replaceArr.joined()
        var pattern = "零{1,}"
        matchesStr = matchesStr.replace(with: nil, length: nil, pattern: pattern, tempory: "零")!
        pattern = "零[万,亿,兆]|零$"
        matchesStr = matchesStr.replace(with: 0, length: 1, pattern: pattern, tempory: "r")!
        //        pattern = "[万,亿,兆]零"
        //        matchesStr = matchesStr.replace(with: 1, length: 1, pattern: pattern, tempory: "r")!
        matchesStr = (matchesStr as NSString).replacingOccurrences(of: "r", with: "")
        matchesStr = (matchesStr as NSString).replacingOccurrences(of: "亿万", with: "亿")
        matchesStr = (matchesStr as NSString).replacingOccurrences(of: "兆亿", with: "兆")
        matchesStr = (matchesStr as NSString).replacingOccurrences(of: "个", with: "")
        
        return matchesStr
    }
    
    
    /// 把中文转换成数字
    ///
    /// - Parameter string: 需要转换的文字
    /// - Returns: 转换后的数字
    func translateToNumber(in string: String) -> Int {
        var resultNum = 0
        let replacedString = string.replacingOccurrences(of: "两", with: "二")
        var str = replacedString.trimmingCharacters(in: CharacterSet.whitespaces) + "个" as NSString
        for i in 0..<bigUnitArr.count {
            if (str as String).range(of: bigUnitArr[bigUnitArr.count - 1 - i]) != nil {
                let index = str.range(of: bigUnitArr[bigUnitArr.count - 1 - i]).location
                let subString = str.substring(with: NSMakeRange(0, index))
                
                let bigUnitIndex = bigUnitArr.index(of: bigUnitArr[bigUnitArr.count - 1 - i]) as Int?
                
                resultNum += getBigUnitValue(string: subString, bigUnitIndex: bigUnitIndex)
                str = str.replacingCharacters(in: NSMakeRange(0, index + 1), with: "") as NSString
            }
        }
        return resultNum
    }
    
    private func getBigUnitValue(string: String, bigUnitIndex: Int?) -> Int {
        
        var num = 0
        for unit in unitArr {
            num += getValue(with: string + "个", unit: unit, isBigUnit: false)
        }
        
        if bigUnitIndex != nil {
            return num * NSDecimalNumber(decimal: pow(10000, bigUnitIndex!)).intValue
        }else{
            return num
        }
    }
    
    
    private func getValue(with string: String, unit: String, isBigUnit: Bool) -> Int {
        if (string.range(of: unit) != nil) {
            let idx = (string as NSString).range(of: unit).location
            
            var singleChineseNum: String
            
            if idx != 0 {
                if unitArr.contains((string as NSString).substring(with: NSMakeRange(idx - 1, 1)))  {
                    return 0
                }else{
                    singleChineseNum = (string as NSString).substring(with: NSMakeRange(idx - 1, 1))
                }
                
                let singleNum = (numArr[chineseNumArr.index(of: singleChineseNum)!] as NSString).integerValue
                
                let chineseUnitIndex = unitArr.index(of: unit) as Int?
                if (chineseUnitIndex != nil) {
                    return singleNum * NSDecimalNumber(decimal: pow(10, chineseUnitIndex!)).intValue
                }else{
                    return singleNum
                }
            }else{
                return 0
            }
            
        }else{
            return 0
        }
        
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

