//
//  ListViewController.swift
//  On The Map
//
//  Created by Shukti Shaikh on 7/13/16.
//  Copyright © 2016 Shukti Shaikh. All rights reserved.
//

import UIKit


class ListViewController: UITableViewController{
    
    //MARK: PROPERTIES
    let udacityClient = UdacityClient.sharedInstance()
    var students: [StudentInformation] = [StudentInformation]()
    
    
    //MARK: VIEWS
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        getStudentInfo()
        
    }
    
    
    //MARK: TABLEVIEW DELEGATE FUNCTIONS
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        cell.imageView?.image = UIImage(named: "pin")
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        if self.students[indexPath.row].firstName != nil  && self.students[indexPath.row].lastName != nil {
        cell.textLabel?.text  = students[indexPath.row].firstName! + " " + students[indexPath.row].lastName!
        } else {
        cell.textLabel?.text = ""
        }
        cell.detailTextLabel?.text = students[indexPath.row].mediaURL
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return students.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let urlString = students[indexPath.row].mediaURL
        if let url = NSURL(string: urlString!) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    

    
    
    func getStudentInfo () {
        ParseClient.sharedInstance().getStudentLocations { (student, errorString) in
            
            if let error = errorString {
                
                let alert = UIAlertController(title: nil, message: error, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                performUIUpdatesOnMain{
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            } else {
                
                self.students = student!
                performUIUpdatesOnMain{
                    self.tableView.reloadData()
                }
                
            }
            
            
        }
        
        
    }
}

