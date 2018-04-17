//
//  DetailsViewController.swift
//  SampleProj
//
//  Created by SUBRAT on 3/17/18.
//  Copyright © 2018 Olive Crypto Systems LLP. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var profImage: UIImageView!
    @IBOutlet var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var FButtonOutlet: UIButton!
    @IBOutlet weak var mButtonOutlet: UIButton!
    @IBOutlet weak var id: UITextField!
    var dictReceived : Any?
    var dict : [String : AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let JSON = self.dictReceived as? [String:Any] {
            if let response = JSON["picture"] as? [String:Any]{
                guard let dt = response["data"] as! [String : AnyObject]! else {return}
                let url = dt["url"] as! String
                self.profImage.downloadedFrom(link: url)
        }
    }

        self.name.text = self.dict["name"] as! String
        self.id.text = self.dict["id"] as! String
        let gender = self.dict["gender"] as! String
        
        UserDefaults.standard.set(self.name.text, forKey: "UNAME")
        UserDefaults.standard.set(self.id.text, forKey: "ID")
        UserDefaults.standard.set(gender, forKey: "GENDER")
        
        if gender.contains("male") {
            mButtonOutlet.setImage(UIImage(named: "tick_solid_enabled"), for: .normal)
            FButtonOutlet.setImage(UIImage(named: "tick_solid_disabled"), for: .normal)
        }else{
            FButtonOutlet.setImage(UIImage(named: "tick_solid_enabled"), for: .normal)
            mButtonOutlet.setImage(UIImage(named: "tick_solid_disabled"), for: .normal)
        }
        
        
    }
    @IBAction func fButtonClicked(_ sender: Any) {
        FButtonOutlet.setImage(UIImage(named: "tick_solid_enabled"), for: .normal)
        mButtonOutlet.setImage(UIImage(named: "tick_solid_disabled"), for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func buttonClicked(_ sender: Any) {
        let ctrl = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        self.navigationController?.pushViewController(ctrl, animated: true)
    }

    @IBAction func mButtonClicked(_ sender: Any) {
        mButtonOutlet.setImage(UIImage(named: "tick_solid_enabled"), for: .normal)
        FButtonOutlet.setImage(UIImage(named: "tick_solid_disabled"), for: .normal)
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
