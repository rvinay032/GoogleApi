//
//  ViewController.swift
//  GoogleApi
//
//  Created by appinventiv on 12/09/17.
//  Copyright © 2017 appinventiv. All rights reserved.
//

import UIKit
import Foundation
class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    
    
    //    // variable---------------
    
    var latitudeArrayStart = [Any]()
    var longitudeArrayStart = [Any]()
    var latitudeArrayEnd = [Any]()
    var longitudeArrayEnd = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromApi()
        
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
           self.tableViewOutlet.delegate = self
            self.tableViewOutlet.dataSource = self
            
            let nibCell = UINib(nibName: "CellOnTableView", bundle: nil)
            self.tableViewOutlet.register(nibCell, forCellReuseIdentifier: "CellOnTableViewId")
        })
        
        
        
    
    
}
    func getDataFromApi() {
        let headers = [
            "cache-control": "no-cache",
            "postman-token": "d7059bb0-abf9-32ba-58d8-c6e6bf8b8cc3",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        let postData = NSMutableData(data: "AIzaSyDxHKZZqpazgzcMfYKiVUpJP55ksPdowfM".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=75%209th%20Ave%20New%20York%2C%20NY&destination=MetLife%20Stadium%201%20MetLife%20Stadium%20Dr%20East%20Rutherford%2C%20NJ%2007073&destination=MetLife%20Stadium%201%20MetLife%20Stadium%20Dr%20East%20Rutherford%2C%20NJ%2007073&key%2Fhttps%3A%2F%2Fmaps.googleapis.com%2Fmaps%2Fapi%2Fdirections%2Fjson%3Forigin=75%209th%20Ave%20New%20York%2C%20NY&key=")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                
                
                let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.init(rawValue: 0))
                
                // print response code which was received from server*********************
                
                //                let httpResponse = response as! HTTPURLResponse
                //                print("My HTTP Response is = = = \(httpResponse)")
                /////////////////////************/////////////////////////////
                
                //   Serialization of Json data************----------
                guard let dict = json as? [String:Any] else {
                    return
                }
                ////////////*****************///////////////////
                
                //  strore Route data in RoutesData dictionary**********
                guard let routesData = dict["routes"] as? [[String : AnyObject]] else {return}
                // print("My routes is ==== \(routes)")
                /////************************************
                
                
                ///////////  Store Bounds in bounds dictionary*****************
                //  guard let bounds = routes[0]["bounds"] as? [[String : AnyObject]] else {return}
                // guard let northest = bounds["northeast"] as? [String : AnyObject] else {return}
                ////////************************************************
                
                // Store " legs " data in a dictioanry legsData******************
                
                guard let legsData = routesData[0]["legs"] as? [[String : AnyObject]] else {return}
                
                guard let startLocation = legsData[0] ["start_location"] as? [String : AnyObject] else {return}
                // print(startLocation)
                guard let latitudeOfStartLegs = startLocation["lat"] else {return}
                guard let longitudeOfStartLegs = startLocation["lng"] else {return}
                
                guard let endLocation = legsData[0] ["end_location"] as? [String : AnyObject] else {return}
                
                guard let latitudeOfEndLegs = endLocation["lat"] else {return}
                guard let longitudeOfEndLegs = endLocation["lng"] else {return}
                
                self.latitudeArrayStart.append(latitudeOfStartLegs)
                self.longitudeArrayStart.append(longitudeOfStartLegs)
                self.latitudeArrayEnd.append(latitudeOfEndLegs)
                self.longitudeArrayEnd.append(longitudeOfEndLegs)
                
                // print(latitudeOfStartLegs)
                // print("Start Location of legs data \(ldata)")
                ////************************************
                
                
                
                
                
                ////// Store steps data in datastep dictioanry****************
                guard let datastep = legsData[0] ["steps"] as? [[String : AnyObject]] else {return}
                
                //%%%%%%%%%%%%%%%%%%%% For loop for latitude of start location in a array %%%%%%%%%%%%%%%%%%%%%%
                
                for temIndex in 0..<datastep.count{
                    let start = datastep[temIndex]["start_location"] as! [String: AnyObject]
                    //  let end = datastep[temIndex]["end_location"] as! [String: AnyObject]
                    guard let latitudeOfStart = start["lat"] else {fatalError("not Found")}
                    self.latitudeArrayStart.append(latitudeOfStart)
                    
                    
                    let start1 = datastep[temIndex]["start_location"] as! [String: AnyObject]
                    guard let longitudeOfStart = start1["lng"]  else {fatalError("not Found")}
                    self.longitudeArrayStart.append(longitudeOfStart)
                    
                    
                    
                    let end = datastep[temIndex]["end_location"] as! [String: AnyObject]
                    guard let latitudeOfend = end["lat"] else {fatalError("not Found")}
                    self.latitudeArrayEnd.append(latitudeOfend)
                    
                    
                    let end1 = datastep[temIndex]["end_location"] as! [String: AnyObject]
                    guard let longitudeOfend = end1["lng"] else {fatalError("not Found")}
                    self.longitudeArrayEnd.append(longitudeOfend)
                    
                    
                    //                  print("Latitude of start is  \(latitudeOfStart)" as Any)
                    //                   guard let longitudeOfStart = start["lng"]  else {fatalError("not Found")}
                    //                    print("Longitude of start \(longitudeOfStart)" as Any)
                    //                    print("start loacion of Steps data is \(start)")
                    //                    print("end loacion of Steps data is \(end)")
                }
                
                
                print("My latitude Array data of STEPS is \(self.latitudeArrayStart.count)")
                
                print("My Longitude Array data of STEPS is \(self.longitudeArrayStart.count)")
                
                print("My Latitude Array data of of STEPS End is \(self.latitudeArrayEnd.count)")
                
                print("My Longitude Array data end of STEPS is \(self.longitudeArrayEnd.count)")
                
                
                
                
                //                  //%%%%%%%%%%%%%%%%%%%% For loop for Longitude of start location in a array %%%%%%%%%%%%%%%%%%%%%%
                //
                //                for temIndex in 0..<datastep.count {
                //
                //                   // print("Longitude of start \(longitudeOfStart)" as Any)
                //                }
                //
                //
                //
                //                  //%%%%%%%%%%%%%%%%%%%% For loop for latitude of end location in a array %%%%%%%%%%%%%%%%%%%%%%
                //                for temIndex in 0..<datastep.count {
                //
                //                    //print("Latitude of end is  \(latitudeOfend)" as Any)
                //                }
                //
                //
                //
                //                for temIndex in 0..<datastep.count {
                //
                //                    //print("Longitude of end is  \(longitudeOfend)" as Any)
                //                }
                //
                //
                
                
                
                
                //////////////////////////
                // print("My legs are ==== \(legs["legs"])")
                //print("My latitude is ==== \(northest["lat"])")
                //  print("My bounds are ==== \(latitude)")
                //print("My routes is ==== \(dict["bounds"] ?? 0)")
                
                
            }
        })
        
        dataTask.resume()
        
        
    }
    }


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return latitudeArrayStart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellOnTableViewId", for: indexPath) as? CellOnTableView
            else {
                fatalError("unable to make cell")
                }
        cell.startLatitudeLabel.text = String(describing: latitudeArrayStart[indexPath.row])
        cell.endLatitudeLabel.text = String(describing: latitudeArrayEnd[indexPath.row])
        cell.startLomgitudeLabel.text = String(describing: longitudeArrayStart[indexPath.row])
        cell.endLongitudeLabel.text = String(describing: longitudeArrayEnd[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    }

