//
//  ViewController.swift
//  FuckingA
//
//  Created by Kristian Rosland on 31.05.2017.
//  Copyright © 2017 Kristian Rosland. All rights reserved.
//

import UIKit

enum Status {
    case NEW, QUESTION_ASKED, HINT_SHOWN, ANS_SHOWN, IMAGE_SHOWN
}

class ViewController: UIViewController {

    var model:Model!
    var currentQuestion:Question?
    var questionsCopy:[Question]?
    var status:Status = Status.NEW
    var colors:[UIColor] = [UIColor]()
    var currentColor:UIColor = UIColor(colorLiteralRed: 1, green: 1, blue: 204/255, alpha: 1)

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var subjectLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addColors()
        
        model = Model(jsonFile:"questions")
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.backgroundTapped)))
        
        questionsCopy = model.getQuestionsCopy()
        backgroundTapped()
    }
    
    func backgroundTapped() {
        switch(self.status) {
        case Status.NEW, Status.IMAGE_SHOWN, Status.ANS_SHOWN:
            clear();
            if (questionsCopy == nil || questionsCopy!.isEmpty) {
                questionsCopy = model.getQuestionsCopy()
            }
            
            self.currentQuestion = questionsCopy?.remove(at: 0)
            self.questionLabel.text = currentQuestion?.question
            if let sub = currentQuestion?.subject {
                self.subjectLabel.text = sub
            }
            self.status = Status.QUESTION_ASKED
            break;
    
        case Status.QUESTION_ASKED:
            self.hintLabel.text = currentQuestion?.hint
            self.status = Status.HINT_SHOWN
            
            if (currentQuestion?.hint == "-") {
                backgroundTapped()
            }
            break;
        
        case Status.HINT_SHOWN:
            if let ans = self.currentQuestion?.answer {
                self.answerLabel.text = ans
            } else if let img = self.currentQuestion?.image {
                self.image.image = img
            }
            
            self.status = Status.ANS_SHOWN
            break;
        }
        
    }
    
    func clear() {
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        if (color == currentColor) {
            clear()
            return
        }
        
        currentColor = color

        self.view.backgroundColor = color
        self.questionView.backgroundColor = color
        self.subjectLabel.text = "";
        self.questionLabel.text = ""
        self.hintLabel.text = ""
        self.answerLabel.text = ""
        self.image.image = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addColors() {
        colors.append(UIColor(colorLiteralRed: 1, green: 1, blue: 204/255, alpha: 1))
        colors.append(UIColor(colorLiteralRed: 204/255, green: 1, blue: 204/255, alpha: 1))
        colors.append(UIColor(colorLiteralRed: 153/255, green: 204/255, blue: 1, alpha: 1))
        colors.append(UIColor(colorLiteralRed: 1, green: 153/255, blue: 102/255, alpha: 1))
        colors.append(UIColor(colorLiteralRed: 204/255, green: 153/255, blue: 1, alpha: 1))
    }


}

