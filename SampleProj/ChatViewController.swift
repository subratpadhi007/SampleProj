//
//  ChatViewController.swift
//  SampleProj
//
//  Created by SUBRAT on 3/17/18.
//  Copyright © 2018 Olive Crypto Systems LLP. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyJSON

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var anserTestField: UITextField!
    @IBOutlet weak var sendOutlet: UIButton!
    var quest = [String]()
    var idArray = [Int]()
    var dataTypeArray = [String]()
    var finalQuestion = [String]()
    var count = 0
    var countForQuest = 0
    var answers : Array<Answer>?
    let cellSpacingHeight: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.anserTestField.delegate = self
        
        self.callNetwork { (data) in
            if let dt = data as? String{
                let questions = Mapper<Questions>().mapArray(JSONString: dt)
//                let questions = Mapper<Questions>().map(JSONString: dt)
                
                questions?.forEach({ (qs) in
                    let dt = qs.data
                    dt?.forEach({ (d) in
                        self.idArray.append(d.id)
                        self.quest.append(d.question)
                        self.dataTypeArray.append(d.dataType)
                    })
                })
                self.finalQuestion.append(self.quest[0])
                self.count = 1
                
                self.tableView.reloadData()
            }
        }
        
    }
    
    func callNetwork(completionHandler: @escaping (Any?)->()){
        let urlString = "https://api.wheelstreet.org/v1/test/questions"
        

        Alamofire.request(urlString, method: .get, parameters: [:], encoding: URLEncoding.default, headers: nil)
            .responseString { response in
            }
            .responseJSON { response in
                if let data = response.result.value{
                    let json = JSON(data).rawString()
                    completionHandler(json)
                }
        }
    }
    
    func sendDataToServer(completionHandler: @escaping (Any?)->()){
        let urlString = "https://api.wheelstreet.com/v1/test/answers"
        let send = SendingData()
        send.age = "45"
        send.email = "abc@gmail.com"
        send.fbUserName = UserDefaults.standard.string(forKey: "UNAME")!
        send.mobile = UserDefaults.standard.string(forKey: "ID")!
        send.gender = UserDefaults.standard.string(forKey: "GENDER")!
        send.id = 2342938
        send.name = UserDefaults.standard.string(forKey: "UNAME")!
        send.questions = self.answers
        let extras: Parameters = ["data": send.toJSONString()]
        print(extras)
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        
        Alamofire.request(urlString, method: .post, parameters: extras, encoding: URLEncoding.default, headers: headers)
            .responseString { response in
            }
            .responseJSON { response in
                if let data = response.result.value{
                    let json = JSON(data).rawString()
                    completionHandler(json)
                }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    
    @IBAction func sendClicked(_ sender: Any) {
        
        if self.sendOutlet.titleLabel?.text == "Submit"{
            self.sendDataToServer(completionHandler: { (dt) in
                print(dt)
            })
        }else{
            var answers : Array<Answer>?
            let ans = Answer()
            self.finalQuestion.append(self.anserTestField.text!)
            ans.answer = self.anserTestField.text!
            ans.id = self.idArray[countForQuest]
            print(ans.id)
            print(ans.answer)
            self.countForQuest += 1
            print(countForQuest)
            print(self.quest.count)
            if countForQuest == 5 {
            }else{
                self.finalQuestion.append(self.quest[countForQuest])
            }
            self.count = self.finalQuestion.count
            self.anserTestField.text = ""
            if countForQuest == self.quest.count {
                self.sendOutlet.setTitle("Submit", for: .normal)
                self.anserTestField.isUserInteractionEnabled = false
            }
            
            answers?.append(ans)
            self.answers = answers
            
            self.tableView.reloadData()
        }
        
    }
    
    func checkValidation(type: String){
        switch type {
        case "integer":
            self.anserTestField.keyboardType = UIKeyboardType.numberPad
            break;
        case "string":
            self.anserTestField.keyboardType = .default
            break;
        case "boolean":
            self.anserTestField.keyboardType = .default
            break;
        case "float":
            self.anserTestField.keyboardType = UIKeyboardType.decimalPad
            break;
        default:
            break;
        }
        
        if self.quest[0].contains("age"){
            self.anserTestField.keyboardType = .namePhonePad
        }else if self.quest[1].contains("hobbies"){
            self.anserTestField.keyboardType = .namePhonePad
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! tableCell
        
        cell.label.text = self.finalQuestion[indexPath.row]
        cell.labelLeadingConstraints.isActive = true
        cell.layoutMargins = UIEdgeInsets.zero
        cell.separatorInset = UIEdgeInsets.zero
        cell.trailingConstraints.isActive = true
        cell.trailingConstraints.constant = 15
        
        cell.outerView.layer.borderColor = UIColor.black.cgColor
        cell.outerView.layer.cornerRadius = 8
        cell.outerView.layer.borderWidth = 1
        cell.outerView.clipsToBounds = true
        
        
        
        

        if indexPath.row % 2 == 0 {
            cell.trailingConstraints.isActive = false
            cell.label.textAlignment = .left
        }else{
            cell.labelLeadingConstraints.isActive = false
            cell.label.textAlignment = .right
        }
        

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }


}


class tableCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet var labelLeadingConstraints: NSLayoutConstraint!
    
    @IBOutlet var outerView: UIView!
    @IBOutlet var trailingConstraints: NSLayoutConstraint!
    
}

class Questions: Mappable {
    var status = 0
    var data: Array<Data>?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        data <- map["data"]
    }
}

class Data: Mappable {
    var id = 0
    var question = "null"
    var dataType = "null"
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        question <- map["question"]
        dataType <- map["dataType"]
    }
}

class SendingData: Mappable {
    var id = 0
    var name = "null"
    var fbUserName = "null"
    var mobile = "null"
    var gender = "null"
    var age = "null"
    var email = "null"
    var questions: Array<Answer>?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    public func getInput() -> String{
        return String(format: "%@%@%@%@%@%@%@%@",id, name, fbUserName, mobile, gender, age, email, questions!);
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        fbUserName <- map["fbUserName"]
        mobile <- map["mobile"]
        gender <- map["gender"]
        age <- map["age"]
        email <- map["email"]
        questions <- map["Answer"]
        
    }
}

class Answer: Mappable {
    var id = 0
    var answer = "null"
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        answer <- map["answer"]
    }
}


