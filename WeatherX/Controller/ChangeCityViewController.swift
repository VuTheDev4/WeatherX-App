//
//  ChangeCityViewController.swift
//  WeatherX
//
//  Created by Vu Duong on 9/11/18.
//  Copyright © 2018 Vu Duong. All rights reserved.
//

import UIKit

class ChangeCityViewController: UIViewController {
    
    @IBOutlet weak var changeCityTextField: UITextField!

    @IBAction func getWeatherPressed(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
