//
//  Weather.swift
//  TelenorWeather
//
//  Created by ADNAN RIBIC on 21/03/16.
//  Copyright © 2016 ADNAN RIBIC. All rights reserved.
//

import Foundation

struct Weather {
    
    let cityName : String
    let temp: Double
    let desc: String
    let icon: String
    
    var tempC: Double{
    get{
        return temp - 273.15
        }
    }
    
    //Let are constans so I am initiliazing them here so I can acces and set them another values
    init(cityName: String, temp: Double, desc: String, icon: String){
    
        self.cityName = cityName
        self.temp = temp
        self.desc = desc
        self.icon = icon
    }
}