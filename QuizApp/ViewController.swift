//
//  ViewController.swift
//  QuizApp
//
//  Created by berk birkan on 16.06.2019.
//  Copyright © 2019 berk birkan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var categories = [String]()
    var ids = [Int]()
    var index = 0
    
    var translatedcat = [String]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "categories", for: indexPath) as! UITableViewCell
        cell.textLabel!.text = self.categories[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        self.performSegue(withIdentifier: "toquiz", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondvc = segue.destination as! QuizVC
        secondvc.title = categories[index]
        secondvc.id = String(ids[index])
    }
    
    @IBOutlet weak var tableview: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getCategory()
        tableview.delegate = self
        tableview.dataSource = self
        
        //print("DENEME:"+translate(text: "hello world what's up"))
        
        
    }
    
    func translatearray(){
        for i in self.categories{
            self.translate(text: i) { (text) in
                self.translatedcat.append(text)
            }
        }
        
        DispatchQueue.main.async {
            self.tableview.reloadData()
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
    
    
    
    func getCategory(){
        guard let url = URL(string: "https://opentdb.com/api_category.php")  else {return}
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
                let json = jsonResponse as! [String:Any]
                let result = json["trivia_categories"] as! [[String:Any]]
                for i in result{
                    let name = i["name"] as! String
                    let id = i["id"] as! Int
                    
                    self.categories.append(name)
                    self.ids.append(id)
                    
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                    }
                    
                    
                    
                    //self.categories.append(name)
                    
                    
                    
                    
                }
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
                
                
                
                
                
                
                
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    


}

