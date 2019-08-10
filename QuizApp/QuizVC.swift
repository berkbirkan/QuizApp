//
//  QuizVC.swift
//  QuizApp
//
//  Created by berk birkan on 16.06.2019.
//  Copyright © 2019 berk birkan. All rights reserved.
//

import UIKit

class QuizVC: UIViewController {
    
    var id = ""
    
    var score = 0
    var questioncount = 0
    
    var questions = [String]()
    var answers = [[String]]()
    var correct_answers = [String]()
    var translatedanswers = [String]()
    
    
    @IBOutlet weak var previusbutton: UIButton!
    
    
    @IBOutlet weak var nextbutton: UIButton!
    
    
    
    @IBOutlet weak var scorelabel: UILabel!
    
    
    @IBOutlet weak var question: UITextView!
    
    
    @IBOutlet weak var answera: UIButton!
    
    
    @IBOutlet weak var answerb: UIButton!
    
    
  
    
    @IBAction func previous(_ sender: UIButton) {
        if questioncount == 2{
            previusbutton.isEnabled = false
        }
        questioncount = questioncount - 1
        getQuestion(index: questioncount)
        
    }
    
    
    @IBAction func startquiz(_ sender: UIButton) {
        getQuestion(index: questioncount)
    }
    
    @IBAction func showAnswer(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "ANSWER", message: self.correct_answers[questioncount], preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    
    @IBAction func nextQuest(_ sender: Any) {
        
        if questioncount != 0{
            previusbutton.isHidden = false
        }
        
        if questioncount == 8{
            nextbutton.isHidden = true
        }
        
        questioncount = questioncount + 1
        print(questioncount)
        getQuestion(index: questioncount)
        
    }
    
    
    @IBAction func clicka(_ sender: Any) {
        
        if (answera.currentTitle?.contains("Click start to start"))!{
            getQuestion(index: questioncount)
        }
        
        if answera.currentTitle == "A) "+self.correct_answers[questioncount]{
            score = score + 1
            scorelabel.text = "Score: " + String(score)
            answera.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        }else{
            answera.setTitleColor(UIColor.red, for: UIControl.State.normal)
            
        }
        
    }
    
    
    @IBAction func clickb(_ sender: Any) {
        
        if answerb.currentTitle == "B) "+self.correct_answers[questioncount]{
            score = score + 1
            scorelabel.text = "Score: " + String(score)
            answerb.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        }else{
            answerb.setTitleColor(UIColor.red, for: UIControl.State.normal)
        }
        
    }
    
    

    
    
    
    
    
    

    override func viewDidLoad() {
        loadQuiz()
        print("COUNT: ",self.questions.count)
        
        super.viewDidLoad()
        
        //getQuestion(index: questioncount)
        scorelabel.text = "Score: " + String(score)
        
        if questioncount == 0{
            previusbutton.isHidden = true
        }

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func translatearray(array:[String],completion: @escaping (_ translatedarray: [String]) -> Void){
        var translatedarray = [String]()
        for i in array{
            self.translate(text: i) { (text) in
                translatedarray.append(text)
            }
        }
        completion(translatedarray)
        //return translatedarray
    }
    
    func getQuestion(index: Int){
        if self.questions.count == 0 && self.questioncount == 0{
            
            loadgeneralquiz()
            
            
            let alert = UIAlertController(title: "Error", message: "There is no question now in this category , click again to load general quiz!", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
 
        }else{
            answera.setTitleColor(UIColor.black, for: UIControl.State.normal)
            answerb.setTitleColor(UIColor.black, for: UIControl.State.normal)
            // answerc.setTitleColor(UIColor.black, for: UIControl.State.normal)
            // answerd.setTitleColor(UIColor.black, for: UIControl.State.normal)
            
            
            question.text = self.questions[index]
            var answers = self.answers[index]
            answers.shuffle()
            //var correct_answer = self.correct_answers[index]
            print("answers count: ",answers.count)
            answera.setTitle("A) " + answers[0], for: UIControl.State.normal)
            answerb.setTitle("B) " + answers[1], for: UIControl.State.normal)
            // answerc.setTitle("C) " + answers[2], for: UIControl.State.normal)
            // answerd.setTitle("D) " + answers[3], for: UIControl.State.normal)
        }
        
        
        
    }
    
    func translate(text:String, completion: @escaping (_ returnString: String) -> Void)  {
        var returnstring = ""
        let url =  "https://translate.yandex.net/api/v1.5/tr.json/translate?key=" + denemeapikey + "&text=" + text + "&lang=" + langdirection
        var urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let yeniurl = URL(string: urlString!)
        
        
        let task = URLSession.shared.dataTask(with: yeniurl!) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                //print(jsonResponse) //Response result
                let deneme = jsonResponse as! [String:Any]
                let result = deneme["text"] as! [String]
                //print("json: " + result[0])
                returnstring = result[0]
                completion(returnstring)
                //print("string: " + returnstring)
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
    }
    
    func loadgeneralquiz(){
        guard let url = URL(string: "https://opentdb.com/api.php?amount=10"+"&type=boolean"+"&encode=base64") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
                let result = jsonResponse as! [String:Any]
                let questions = result["results"] as! [[String:Any]]
                for i in questions{
                    let question = i["question"] as! String
                    let question2 = question.decodingHTMLEntities()
                    
                    
                    let correct_answer = i["correct_answer"] as! String
                    
                    let correct2 = correct_answer.decodingHTMLEntities()
                    
                    let incorrect_answers = i["incorrect_answers"] as! [String]
                    var incorrect2 = [String]()
                    
                    
                    for incorrect in incorrect_answers{
                        incorrect2.append(incorrect.decodingHTMLEntities())
                    }
                    
                    
                    //let answers = [correct_answer,incorrect_answers] as! [String]
                    let answers = [correct2] + incorrect2
                    //let translate = self.translatearray(array: answers, completion
                    var newanswers = [String]()
                    for i in answers{
                        newanswers.append(i.fromBase64()!)
                    }
                    
                    self.questions.append(question.fromBase64()!)
                    self.correct_answers.append(correct_answer.fromBase64()!)
                    self.answers.append(newanswers )
                    
                    
                    
                    
                    
                    //
                    /*
                     self.translate(text: question, completion: { (text) in
                     self.questions.append(text)
                     })
                     
                     self.correct_answers.append(correct_answer)
                     self.answers.append(answers)
                     */
                    //
                    
                    
                    
                    
                    
                }
                
                
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    func loadQuiz(){
        guard let url = URL(string: "https://opentdb.com/api.php?amount=10&category="+id+"&type=boolean"+"&encode=base64") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
                let result = jsonResponse as! [String:Any]
                let questions = result["results"] as! [[String:Any]]
                for i in questions{
                    let question = i["question"] as! String
                    let question2 = question.decodingHTMLEntities()
                    
                    
                    let correct_answer = i["correct_answer"] as! String
                    
                    let correct2 = correct_answer.decodingHTMLEntities()
                    
                    let incorrect_answers = i["incorrect_answers"] as! [String]
                    var incorrect2 = [String]()
                    
                    
                    for incorrect in incorrect_answers{
                        incorrect2.append(incorrect.decodingHTMLEntities())
                    }
                   
                    
                    //let answers = [correct_answer,incorrect_answers] as! [String]
                    let answers = [correct2] + incorrect2
                    //let translate = self.translatearray(array: answers, completion
                    var newanswers = [String]()
                    for i in answers{
                        newanswers.append(i.fromBase64()!)
                    }
                    
                    self.questions.append(question.fromBase64()!)
                    self.correct_answers.append(correct_answer.fromBase64()!)
                    self.answers.append(newanswers )
                    
                    
                    
                    
                    
                    //
                    /*
                    self.translate(text: question, completion: { (text) in
                        self.questions.append(text)
                    })
                    
                    self.correct_answers.append(correct_answer)
                    self.answers.append(answers)
 */
                    //
                   
                    
                    
                    
                    
                }
                
                
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
    }
    
    
    
    

    

}

extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
