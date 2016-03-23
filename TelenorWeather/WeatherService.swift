//
//  WeatherService.swift
//  TelenorWeather
//
//  Created by ADNAN RIBIC on 21/03/16.
//  Copyright © 2016 ADNAN RIBIC. All rights reserved.
//

import Foundation

//Protocol describes features of something without telling what it is
protocol WeatherServiceDelegate{
    
    func setWeather(weather: Weather)
    func weatherErrorWithMessage(message: String)

}

class WeatherService {
    
    var delegate: WeatherServiceDelegate?
    
    func getWeather(city: String){
        
        //\(cityEscaped!)
        //If city has some special caracters which http prtocol cannot recognise, this function will convert it( space = %20)
        let cityEscaped = city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        let appid = "49a4f50db564a1de11f88186a06355ab"
        //raw link presented in string
        let path =  "http://api.openweathermap.org/data/2.5/weather?q=\(cityEscaped!)&appid=\(appid)"
        //string converted to URL
        let url = NSURL(string: path)
        //session for exchanging data
        let session = NSURLSession.sharedSession()
        //task for session
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if let httpResponse = response as? NSHTTPURLResponse{
            print(httpResponse.statusCode)
            }
            //print(data)
            let json = JSON(data: data!)
            
            var status = 0
            if let cod = json["cod"].int{
            status = cod
            }else if let cod = json["cod"].string{
            status = Int(cod)!
            }
            
            if status == 200 {
            let temperature = json["main"]["temp"].double
            let name = json["name"].string
            let description = json["weather"][0]["description"].string
            let icon = json["weather"][0]["icon"].string
                
            
            let weather = Weather(cityName: name!, temp: temperature!, desc: description!,icon: icon!)
            
            //Code for interface update. 
            if self.delegate != nil{
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.delegate?.setWeather(weather)
                })
                    
                
            }}
            
               //print("Lat: \(lat!) lon: \(lon!) temp: \(temperature!)")
            else if status == 400 {
            
                if self.delegate != nil{
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.delegate?.weatherErrorWithMessage("City not found!")
                    })
            
            }}else{
                
                    if self.delegate != nil{
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.delegate?.weatherErrorWithMessage("Unknown error")
                        })

                }}}
        task.resume()
        }
        
    }
