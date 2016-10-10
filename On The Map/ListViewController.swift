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
    var studentStore = Student.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(refresh))
        parentViewController?.navigationItem.rightBarButtonItem = refreshButton
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        getStudentLocations()
    }

    
    func refresh() {
        self.studentStore.students.removeAll()
        getStudentLocations()
        print("updated with student locations")
        
    }
    
    //MARK: TABLEVIEW DELEGATE FUNCTIONS
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        cell.imageView?.image = UIImage(named: "pin")
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
       
        cell.textLabel?.text  = studentStore.students[indexPath.row].firstName! + " " + studentStore.students[indexPath.row].lastName!
        cell.detailTextLabel?.text = studentStore.students[indexPath.row].mediaURL
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studentStore.students.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var url: NSURL
        
        if let urlString = studentStore.students[indexPath.row].mediaURL {
            if urlString.hasPrefix("http") {
                url = NSURL(string: urlString)!
            } else {
                url = NSURL(string: "https://" + urlString)!
            }
            UIApplication.sharedApplication().openURL(url)
        }

        
    }
    
    func getStudentLocations() {
        ParseClient.sharedInstance().getStudentLocations { (student, errorString) in
            
            
            if let error = errorString {
                performUIUpdatesOnMain{
                let alert = UIAlertController(title: nil, message: error, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            } else {
                performUIUpdatesOnMain{
                    for item in student {
                        self.studentStore.students.append(item)
                    }
                    self.tableView.reloadData()
                }
            }
        }}

    
}

