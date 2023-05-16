//
//  ViewController.swift
//  Project8
//
//  Created by Kanyin Aje on 28/06/2020.
//  Copyright © 2020 Kanyin Aje. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView()//UIView is the parent class of all of UIKit’s view types: labels, buttons, progress views, and more.
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0  //0 – a magic value that means “as many lines as it takes
        view.addSubview(cluesLabel)

        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        view.addSubview(answersLabel)
        
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)//1 prefers to be stretched
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical) //determines how happy we are for this view to be made smaller than its intrinsic content size.
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        view.addSubview(submit)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside) //touchUpInside,that’s UIKit’s way of saying that the user pressed down on the button and lifted their touch while it was still inside.
       

        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        view.addSubview(clear)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 5
        buttonsView.layer.borderColor = UIColor.gray.cgColor ////cgcolor to convert it to calayer type as it doesnt understand UiColor

        view.addSubview(buttonsView)
       
        
        NSLayoutConstraint.activate([
        scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
        scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
        // pin the top of the clues label to the bottom of the score label
        cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),

        // pin the leading edge of the clues label to the leading edge of our layout margins, adding 100 for some space
        cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),

        // make the clues label 60% of the width of our layout margins, minus 100
        cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),

        // also pin the top of the answers label to the bottom of the score label
        answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),

        // make the answers label stick to the trailing edge of our layout margins, minus 100
        answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),

        // make the answers label take up 40% of the available space, minus 100
        answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),

        // make the answers label match the height of the clues label
        answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
        
        currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
        currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
        
        submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
        submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
        submit.heightAnchor.constraint(equalToConstant: 44),

        clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
        clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),//This means both buttons will remain aligned even if we move one.
        clear.heightAnchor.constraint(equalToConstant: 44),
        
        buttonsView.widthAnchor.constraint(equalToConstant: 750),
        buttonsView.heightAnchor.constraint(equalToConstant: 320),
        buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
        buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
        ])
        
        let width = 150
        let height = 80

        // create 20 buttons as a 4x5 grid
        for row in 0..<4 {
            for col in 0..<5 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)

                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle("WWW", for: .normal)

                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame

                // add it to the buttons view
                buttonsView.addSubview(letterButton)

                // and also to our letterButtons array
                letterButtons.append(letterButton)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }

    @objc func letterTapped(_ sender: UIButton) {
        
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }

    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }

        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()

            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
    
            

            currentAnswer.text = ""
            score += 1
            
           
                  
            if splitAnswers! == solutions {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
            
        }
        else {
        let ac = UIAlertController(title: "Wrong!", message: nil, preferredStyle: .alert)
         ac.addAction(UIAlertAction(title: "Try Again" , style: .cancel))
         present(ac, animated: true)
            
            score -= 1
        }
    }

    @objc func clearTapped(_ sender: UIButton) {
        
        currentAnswer.text = ""

        for btn in activatedButtons {
            btn.isHidden = false
        }

        activatedButtons.removeAll()
        
    }
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)

        loadLevel()

        for btn in letterButtons {
            btn.isHidden = false
        }
    }
    func loadLevel() {
        
       
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
               DispatchQueue.global(qos: .userInitiated).async {
            if let levelFileURL = Bundle.main.url(forResource: "level\(self.level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                //var lines = levelContents.components(separatedBy: "\n")
                var lines = levelContents.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
                //This change will trim off any blank lines at the end of the file before trying to split it into an array.
                lines.shuffle()
               
                DispatchQueue.main.async {
                for (index, line) in lines.enumerated() {//this method gives back value and position from array
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    
                    clueString += "\(index + 1). \(clue)\n"
                
                    

                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    self.solutions.append(solutionWord)

                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                    
                    
                   }
                }
                
             }
          }
                
        
                DispatchQueue.main.async {
                self.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
                self.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)

         letterBits.shuffle()

                if letterBits.count == self.letterButtons.count {
                    for i in 0 ..< self.letterButtons.count {
                        self.letterButtons[i].setTitle(letterBits[i], for: .normal)
                    }
             }
         }
        
        }//dis
    }

}

//Calculating positions of views by hand isn’t something we’ve done before, because we’ve been relying on Auto Layout for everything. However, it’s no harder than sketching something out on graph paper: we create a rectangular frame that has X and Y coordinates plus width and height, then assign that to the frame property of our view. These rectangles have a special type called CGRect, because they come from Core Graphics.
