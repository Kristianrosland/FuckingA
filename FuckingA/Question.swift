//
//  Question.swift
//  FuckingA
//
//  Created by Kristian Rosland on 31.05.2017.
//  Copyright © 2017 Kristian Rosland. All rights reserved.
//

import UIKit

class Question: NSObject {
    
    var question:String!
    var hint:String!
    var answer:String?
    var image:UIImage?
    var subject:String?
    
    init(q: String, h: String, ans:String) {
        self.question = q
        self.hint = h
        self.answer = ans
    }
    
    init(q: String, h: String, img:UIImage) {
        self.question = q
        self.hint = h
        self.image = img
    }
    
    func setSubject(s:String) {
        self.subject = s;
    }
}
