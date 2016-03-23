//
//  ViewController.swift
//  TelenorWeather
//
//  Created by ADNAN RIBIC on 18/03/16.
//  Copyright © 2016 ADNAN RIBIC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var items = [String]()
    
    var NameToPass: String!
    
    
    
    
    @IBAction func startEditing(sender: UIBarButtonItem) {
        //Enabling and disabling editing of cells by clicking on edit button
        self.tableView.editing = !self.tableView.editing
    }
    
    
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = "Temperature app"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //It gives us number of rows in our "items" array.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        
        return items.count

        }
    
    //This function is copied from UITableViewDataSource. Then I made constant named cell
    // which i can reuse it and I gave it a identifier called "Cell". After that, I called array on specific row and pass name to cells label and I wanted for color to be red
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = UIColor(red: 73.0/255.0, green: 179.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        
        
        return cell
        }
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        let indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow!
        
        let DestViewController = segue.destinationViewController as! SecondViewController
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)
        
        NameToPass = String(currentCell!.textLabel!.text!)
        
        DestViewController.Name = NameToPass
    }
    
    
    
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true}
    
    
    
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    //Function for rearanging objects in tableview
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let movedObject = self.items[sourceIndexPath.row]
        items.removeAtIndex(sourceIndexPath.row)
        items.insert(movedObject, atIndex: destinationIndexPath.row)
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(items)")
    }
    
    
}

