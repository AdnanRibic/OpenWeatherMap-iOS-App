# Readme file

Demo video for this app:


```sh
https://youtu.be/LxmeKwyUQOA
```

This is readme file for OpenWeather app

  - Application is written in Swift 2.1 and Xcode 7.2
  - Aplication is made to work on Iphone
  - API use in this app is from OpenWeatherMap with uniqe key, so if you want to use this app plesae generete youe own
  - App can be run from .xcodeproj without any other actions, teverything is implemented inside file
  - For JSON parsing I used SwiftyJson which is opensource and available on github
  - As far as I know, pictures are not copyright protected, and they will be only used for presentational and educational purposes
  
Application is using array of strings to put data inside list view trough prototype cell: 

 - Cretaing array of strings
```sh
var items = [String]()
```  

 - Adding items in array
 ```sh
 @IBAction func addCity(sender: UIButton)
    {
        
        //By pressing addCity wou will add everything written inside textfield and append it to array
        let newItem = textField.text
        
        items.append(newItem!)
        
        //Those two fields are just cosmetical. First one brings keyboard back when you finish addint first element and the other one is "deleting" everything from textfield by giving it empty string :)
        textField.resignFirstResponder()
        textField.text = ""
        
        tableView.reloadData()
    }
``` 
 - Counting objects in array
  ```sh
 //It gives us number of rows in our "items" array.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return items.count

        }
``` 

 - Assining cell to row and providing it with name and color
 ```sh
// This function is copied from UITableViewDataSource. Then I made constant named cell
// which i can reuse it and I gave it a identifier called "Cell". After that, I called //array on specific row and pass name to cells label and I wanted for color to be red
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = UIColor(red: 73.0/255.0, green: 179.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        
        
        return cell
        }
``` 

- Function for deleting array items with left swipe
 ```sh
//This function is for deleting added cities. You swipe left and hit delete. 
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //Constant is made in particular row
        let deletedRow: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        //Removing item with animaton
        if editingStyle == UITableViewCellEditingStyle.Delete{
            items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            //If item has any styling, delete that as well(just in case if I add any other stuff, like temperature, icon, some selected state)
            deletedRow.accessoryType = UITableViewCellAccessoryType.None
        }
    }
``` 

 - Connecting two viewcontrollers and passing data between them
 ```sh 
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        let indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow!
        
        let DestViewController = segue.destinationViewController as! SecondViewController
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)
        
        NameToPass = String(currentCell!.textLabel!.text!)
        
        DestViewController.Name = NameToPass
    }
    
``` 
    
   - If I want to sort array I just need to call array.sort($0 < $1) which was to simple so I decided to implement function for user to sort it
```sh     
    //Function for rearanging objects in tableview
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let movedObject = self.items[sourceIndexPath.row]
        items.removeAtIndex(sourceIndexPath.row)
        items.insert(movedObject, atIndex: destinationIndexPath.row)
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(items)")
    }
``` 
 - In second viewcontroller I called WeatherService class and provide it with city name
```sh  
override func viewDidLoad() {
        //super.viewDidLoad()
        //Call WeatherService class and passing string
        self.weahterService.delegate = self
        self.weahterService.getWeather(Name)
        cityLabel.text = Name
    }
```
 - In this function, I set weather data to objects where needed, convert it for roundup, add celsius sign, gave very iboutlet its value
```sh
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
```

- Aceppting error message and presenting it as alert popup window
```sh
//error message if something is not ok in weather service
    func weatherErrorWithMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(ok)
        
        self.presentViewController(alert , animated: true, completion: nil)
    }
```
```sh
- This function is for parsing data from JSON using SwiftyJson, and handling errors

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
```

- Weather class made as struct 
```sh
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
```


There are lot of other thing that need to be configured inside app. There is transport security protocols which app nowdays do not accept so I needed to enable it bymyself. Now app can accept regular Http data. UI is just there for presentation and autolayout can be better with little work. If you have any other quesions just give me a call! :)