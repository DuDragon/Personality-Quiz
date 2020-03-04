//
//  QuestionViewController.swift
//  PersonalityQuiz
//
//  Created by Bailey Baskett on 2/25/20.
//  Copyright © 2020 Bailey Baskett. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var singleStackView: UIStackView!
    @IBOutlet var singleButton1: UIButton!
    @IBOutlet var singleButton2: UIButton!
    @IBOutlet var singleButton3: UIButton!
    @IBOutlet var singleButton4: UIButton!
    
    @IBOutlet weak var multipleStackView: UIStackView!
    @IBOutlet weak var multiLabel1: UILabel!
    @IBOutlet weak var multiLabel2: UILabel!
    @IBOutlet weak var multiLabel3: UILabel!
    @IBOutlet weak var multiLabel4: UILabel!
    @IBOutlet var multiSwitch1: UISwitch!
    @IBOutlet var multiSwitch2: UISwitch!
    @IBOutlet var multiSwitch3: UISwitch!
    @IBOutlet var multiSwitch4: UISwitch!
    
    @IBOutlet weak var rangedStackView: UIStackView!
    @IBOutlet weak var rangedLabel1: UILabel!
    @IBOutlet weak var rangedLabel2: UILabel!
    @IBOutlet weak var rangedSlider: UISlider!
    
    @IBOutlet weak var questionProgressView: UIProgressView!
    
    
    var questions: [Question] = [
        Question(text: "Which activities do you enjoy?", type: .multiple, answers: [
            Answer(text: "Swimming", type: .turtle),
            Answer(text: "Cuddling", type: .rabbit),
            Answer(text: "Sleeping", type: .cat),
            Answer(text: "Eating", type: .dog)]),
        Question(text: "How much do you enjoy car rides?", type: .ranged, answers: [
            Answer(text: "I dislike them", type: .cat),
            Answer(text: "I get a little nervous", type: .rabbit),
            Answer(text: "I barely notice them", type: .turtle),
            Answer(text: "I love them", type: .dog)]),
        Question(text: "Which food do you like the most?", type: .single, answers: [
            Answer(text: "Steak", type: .dog),
            Answer(text: "Fish", type: .cat),
            Answer(text: "Carrot", type: .rabbit),
            Answer(text: "Corn", type: .turtle)])
    ]
    
    var questionIndex = 0
    var answersChosen: [Answer] = []

    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        let currentAnswers = questions[questionIndex].answers
        
        switch sender {
        case singleButton1:
            answersChosen.append(currentAnswers[0])
        case singleButton2:
            answersChosen.append(currentAnswers[1])
        case singleButton3:
            answersChosen.append(currentAnswers[2])
        case singleButton4:
            answersChosen.append(currentAnswers[3])
        default:
            break
        }
        print(answersChosen[0])
        nextQuestion()
        print(answersChosen[0])
    }
    
    @IBAction func multipleAnswerButtonPressed() {
        let currentAnswers = questions[questionIndex].answers
        print("multo press")
        if multiSwitch1.isOn {
            print("switch1 on")
            answersChosen.append(currentAnswers[0])
        }
        if multiSwitch2.isOn {
            print("switch2 on")
            answersChosen.append(currentAnswers[1])
        }
        if multiSwitch3.isOn {
            answersChosen.append(currentAnswers[2])
        }
        if multiSwitch4.isOn {
            answersChosen.append(currentAnswers[3])
        }
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let currentAnswers = questions[questionIndex].answers
        let index = Int(round(rangedSlider.value * Float(currentAnswers.count - 1)))
        answersChosen.append(currentAnswers[index])
        nextQuestion()
    }
    
    func nextQuestion() {
        print("nectstart")
        questionIndex += 1
        if questionIndex < questions.count {
            updateUI()
        } else {
            print("segue b4")
            performSegue(withIdentifier: "ResultsSegue", sender: nil)
            print("segue after")
        }
    }
    
    func updateUI() {
        singleStackView.isHidden = true
        multipleStackView.isHidden = true
        rangedStackView.isHidden = true
        
        let currentQuestion = questions[questionIndex]
        let currentAnswers = currentQuestion.answers
        let totalProgress = Float(questionIndex) / Float(questions.count)
        navigationItem.title = "Question #\(questionIndex+1)"
        questionLabel.text = currentQuestion.text
        questionProgressView.setProgress(totalProgress, animated: true)
        
        switch currentQuestion.type {
        case .single:
            print("switch single")
            updateSingleStack(using: currentAnswers)
        case .multiple:
            print("switch multi")
            updateMultipleStack(using: currentAnswers)
        case .ranged:
            print("switch ranged")
            updateRangedStack(using: currentAnswers)
        }
        print("end update ui")
    }
 
    func updateSingleStack(using answers: [Answer]) {
        multipleStackView.isHidden = true
        rangedStackView.isHidden = true
        singleStackView.isHidden = false
        print("revealed single")
        singleButton1.setTitle(answers[0].text, for: .normal)
        singleButton2.setTitle(answers[1].text, for: .normal)
        singleButton3.setTitle(answers[2].text, for: .normal)
        singleButton4.setTitle(answers[3].text, for: .normal)
        print("end set up single")
    }
    
    func updateMultipleStack(using answers: [Answer]) {
        multipleStackView.isHidden = false
        print("revealed multi")
        multiSwitch1.isOn = false
        multiSwitch2.isOn = false
        multiSwitch3.isOn = false
        multiSwitch4.isOn = false
        multiLabel1.text = answers[0].text
        multiLabel2.text = answers[1].text
        multiLabel3.text = answers[2].text
        multiLabel4.text = answers[3].text
        print("end set up multi")
    }
    
    func updateRangedStack(using answers: [Answer]) {
        rangedStackView.isHidden = false
        print("revealed range")
        rangedSlider.setValue(0.5, animated: false)
        rangedLabel1.text = answers.first?.text
        rangedLabel2.text = answers.last?.text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultsSegue" {
            let resultsViewController = segue.destination as! ResultsViewController
            resultsViewController.responses = answersChosen
        }
    }
    
}
