//
//  MyTripsViewController.swift
//  GoU
//
//  Created by hjq on 11/5/16.
//  Copyright © 2016 SunYufan. All rights reserved.
//

import UIKit
import Firebase

class MyTripsViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    var ref: FIRDatabaseReference!
    var userRef: FIRDatabaseReference!
    var tripRequests = ""
    
    @IBOutlet weak var mySegment: UISegmentedControl!
    
    @IBOutlet weak var tripsTableView: UITableView!
    
    var userID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference(withPath: "messages")
        self.userRef = FIRDatabase.database().reference(withPath: "commonProfiles")
        
        
        
        
        
        userID = (FIRAuth.auth()?.currentUser?.uid)!
        self.ref.child("posts").observe(.value, with: { (snapshot) in
            myTrips = []
            myRequests = []
            
            let key  = snapshot.key as String
            let value = snapshot.value as? NSDictionary
            let tripKeys = value?.allKeys as! [String]
            let temp = tripKeys[0]
            debugPrint("hello")
            debugPrint(key)
            
            
            for currTrip in tripKeys{
                trip.from = (value![currTrip]! as! NSDictionary)["from"]! as! String
                trip.to = (value![currTrip]! as! NSDictionary)["to"]! as! String
                trip.date = (value![currTrip]! as! NSDictionary)["date"]! as! String
                trip.seats = (value![currTrip]! as! NSDictionary)["seats"]! as! String
                trip.notes = (value![currTrip]! as! NSDictionary)["notes"]! as! String
                trip.tripID = currTrip
                trip.ownerID = (value![currTrip]! as! NSDictionary)["ownerID"]! as! String
                trip.price = (value![currTrip]! as! NSDictionary)["price"]! as! String
                trip.pickUp = (value![currTrip]! as! NSDictionary)["pickUp"]! as! String
                trip.riderID = (value![currTrip]! as! NSDictionary)["riderID"]! as! String
                self.tripRequests = (value![currTrip]! as! NSDictionary)["requestList"]! as! String
                
                let requestArr = self.tripRequests.components(separatedBy: ",")
                print(requestArr)
                
                
                debugPrint(trip.ownerID)
                // TODO: DO linear search?
                
                if (trip.ownerID == self.userID) {
                    if (myTrips.isEmpty || myTrips[myTrips.endIndex - 1].tripID != trip.tripID) {
                        myTrips.append(trip)
                    }
                }
                
                if (requestArr.contains(self.userID)) {
                    if (myRequests.isEmpty || myRequests[myRequests.endIndex - 1].tripID != trip.tripID) {
                        myRequests.append(trip)
                    }
                }
                
                
            }

            self.tripsTableView.delegate = self
            self.tripsTableView.dataSource = self
            self.tripsTableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
        
        //tabBarController?.tabBar.items?[2].badgeValue = "2"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var numRows = 0
        
        if (mySegment.selectedSegmentIndex == 0){
            //My posts
            numRows = myTrips.count
            print(numRows)
            
            
        }
        if (mySegment.selectedSegmentIndex == 1){
            //My requests
            //TO DO
            numRows = myRequests.count
            print(numRows)
        }
        
        
        return numRows
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTripItem", for: indexPath)
        
        
        if (mySegment.selectedSegmentIndex == 0){
            //My posts
            cell.textLabel?.text = "\(myTrips[indexPath.row].from) - \(myTrips[indexPath.row].to) - \(myTrips[indexPath.row].date)"
            
            
            cell.detailTextLabel?.text = "\(requesters.count) Requesters"
            
            cell.detailTextLabel?.text = "View Requesters"
            
//            if(myRequests[indexPath.row].riderID != ""){
//                cell.detailTextLabel?.text = "Matched"
//            }
//            
//            if (requesters.count <= 1){
//                cell.detailTextLabel?.text = "\(requesters.count) Requester"
//            }
//            
//            if(myTrips[indexPath.row].riderID != ""){
//                cell.detailTextLabel?.text = "Matched"
//            }
            
        }
        if (mySegment.selectedSegmentIndex == 1){
            //My requests
            cell.textLabel?.text = "\(myRequests[indexPath.row].from) - \(myRequests[indexPath.row].to) - \(myRequests[indexPath.row].date)"
            
            //TO DO
            cell.detailTextLabel?.text = "No response"
            if(myRequests[indexPath.row].riderID == userID){
                cell.detailTextLabel?.text = "Accepted"
            }
            if(myRequests[indexPath.row].riderID != "" && myRequests[indexPath.row].riderID != userID){
                cell.detailTextLabel?.text = "Failed"
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //TO DO:
        
        if (mySegment.selectedSegmentIndex == 0){
            //My posts
            viewingCondition = 1
            tripViewing = myTrips[indexPath.row]
            
        }
        if (mySegment.selectedSegmentIndex == 1){
            //My requests
            viewingCondition = 2
            tripViewing = myRequests[indexPath.row]
            
        }
        
        NSLog(tripViewing.ownerID)
    }
    
    
    @IBAction func switchView(_ sender: AnyObject) {
        self.tripsTableView.reloadData()
    }
    
    
    
    @IBAction func refresh(_ sender: AnyObject) {
        self.tripsTableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
