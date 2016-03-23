//
//  SecondViewController.swift
//  TelenorWeather
//
//  Created by ADNAN RIBIC on 21/03/16.
//  Copyright © 2016 ADNAN RIBIC. All rights reserved.
//

import Foundation
import UIKit

class SecondViewController: UIViewController, WeatherServiceDelegate {
    
    let weahterService = WeatherService()
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    
    
    var Name = String()
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        //Call WeatherService class and passing string
        self.weahterService.delegate = self
        self.weahterService.getWeather(Name)
        cityLabel.text = Name
    }
    
    //MARK: - Weather serivce delegate - implemetation of method - this is must have because of protocol
    
    func setWeather(weather: Weather) {
        
        print("***Set weather")
        let formater = NSNumberFormatter()
        formater.numberStyle = .DecimalStyle
        formater.roundingMode = NSNumberFormatterRoundingMode.RoundUp
        let f = formater.stringFromNumber(weather.tempC)!
        print("City: \(weather.cityName) temp: \(weather.tempC) desc: \(weather.desc)")
        self.descLabel.text = weather.desc
        self.tempLabel.text = "\(f)ºC"
        weatherIcon.image = UIImage(named: weather.icon)
        }
    
    //error message if something is not ok in weather service
    func weatherErrorWithMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(ok)
        
        self.presentViewController(alert , animated: true, completion: nil)
    }
    
}
