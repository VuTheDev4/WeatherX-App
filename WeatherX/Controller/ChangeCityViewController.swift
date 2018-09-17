//
//  ChangeCityViewController.swift
//  WeatherX
//
//  Created by Vu Duong on 9/11/18.
//  Copyright © 2018 Vu Duong. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    
    func userEnteredNewCityName(city: String)
}

class ChangeCityViewController: UIViewController {
    

    
    var delegate : ChangeCityDelegate?
    
    @IBOutlet weak var changeCityTextField: UITextField!
    
    
    @IBAction func getWeatherPressed(_ sender: Any) {
        
        let cityName = changeCityTextField.text!
        delegate?.userEnteredNewCityName(city: cityName)

        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
