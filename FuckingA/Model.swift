//
//  Model.swift
//  Mineraloda
//
//  Created by Kristian Rosland on 22.11.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

class Model: NSObject {
    
    var questions:[Question] = [Question]()
    
    init(jsonFile:String) {
        super.init();
        
        let jsonObjects:[NSDictionary] = getLocalJSONFile(file: jsonFile)
        
        for dict in jsonObjects {
            let question = dict["question"] as! String
            let hint = dict["hint"] as! String
            let ans = dict["ans"] as? String
            let img = dict["img"] as? String
            let sub = dict["sub"] as? String

            var q:Question?
            
            if let answer = ans {
                q = Question(q: question, h: hint, ans: answer)
            } else if let imgName = img, let image = UIImage(named: imgName) {
                q = Question(q: question, h: hint, img: image)
            }
            
            if let subject = sub {
                q?.setSubject(s: subject)
            }
            
            if let actualQuestion = q {
                self.questions.append(actualQuestion)
            } else {
                NSLog("Could not parse question: \(question)")
            }
        }
    }
    
    func getQuestionsCopy() -> [Question] {
        shuffleInPlace()
        
        var copy:[Question] = []
        for q in self.questions {
            copy.append(q)
        }
        return copy
    }
    
    func shuffleInPlace() {
        guard questions.count > 0 else { return; }
        let c = self.questions.count
        for i in 0..<(c - 1) {
            let j = Int(arc4random_uniform(UInt32(c - i))) + i
            if i == j { continue; }
            swap(&questions[i], &questions[j])
        }
    }
    
    
    func getLocalJSONFile(file:String) -> [NSDictionary] {
        // URL
        let bundlepath:String? = Bundle.main.path(forResource: file, ofType: "json")
    
        
        if let actualBundlepath = bundlepath {
            let URL:Foundation.URL = Foundation.URL(fileURLWithPath: actualBundlepath)
            let jsonData:Data? = try? Data(contentsOf: URL)
            
            if let actualJsonData = jsonData {
                
                do {
                    let arrayOfDictionaries:[NSDictionary] = try JSONSerialization.jsonObject(with: actualJsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
                    return arrayOfDictionaries
                } catch {
                    // Exception
                }
            } else {
                NSLog("Error: jsonData does not exist")
            }
        } else {
            NSLog("ERROR: BUNDLEPATH = NIL, \(file) not found!")
        }
        
        return [NSDictionary]()
    }
}
