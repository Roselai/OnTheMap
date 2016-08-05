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
    
    //MARK: OUTLETS
    @IBOutlet var studentsTableView: UITableView!
    
    //MARK: VIEWS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(logout))
        parentViewController!.navigationItem.leftBarButtonItem = button
        
    }
    
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
        cell.textLabel?.text  = students[indexPath.row].firstName + " " + students[indexPath.row].lastName
        //+ " - \(linkText)"
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return students.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let urlString = students[indexPath.row].mediaURL
        if let url = NSURL(string: urlString) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    // MARK: Logout
    
    func logout() {
        
        
        udacityClient.logOutOfUdacity { (success, errorString) in
            
            
            if let error = errorString {
                print(error)
            } else {
                
                performUIUpdatesOnMain{
                    self.dismissViewControllerAnimated(true, completion: {print("Successfully logged out")})
                }
            }
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
                    self.studentsTableView.reloadData()
                    }
                    
                }
                
            
        }
        
        
    }
}

