//
//  DetailViewController.swift
//  TTBSwift
//
//  Created by Mohamed Belfekih on 09/02/2018.
//  Copyright © 2018 Mohamed Belfekih. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource, HomeTableViewCellDelegate {
    func firstDelegate(string: String) {
        print("3asba l swiden")
    }
    

    
    var station = Station();
    var managedContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    var stationsArray : NSMutableArray = []
    
    
    
    
    @IBOutlet weak var favoritTableView: UITableView!
    @IBOutlet weak var stationName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedContext = appDelegate.persistentContainer.viewContext
        self.stationName.text = station.streetName
        let butt = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveStationToCoreData as () -> Void))
        self.navigationItem.rightBarButtonItem  = butt
        
        // set table view cell
        let nibName = UINib(nibName: "HomeTableViewCell", bundle: nil)
        self.favoritTableView.register(nibName, forCellReuseIdentifier: "HomeTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveStationAction(_ sender: Any) {
        self .saveStationToCoreData(station: station)
    }
    
    @objc func saveStationToCoreData() {
        self .saveStationToCoreData(station: station)
    }
    
    func saveStationToCoreData(station : Station) {
        let stationEntity = NSEntityDescription.entity(forEntityName:"StationData", in: managedContext)!
        let stationO = NSManagedObject(entity : stationEntity, insertInto : managedContext);
        stationO .setValue(station.streetName, forKey: "streetName");
        stationO .setValue(station.city, forKey: "city");
        stationO .setValue(station.latitude, forKey: "latitude");
        stationO .setValue(station.longitude, forKey: "longitude");
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func showSavedStations (){
        self.favoritTableView.isHidden = false
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "StationData")
        let stations = try! managedContext.fetch(userFetch)
        for stationO in stations {
            let s = stationO as! StationData
            self.stationsArray .add(s)
            
        }
        self.favoritTableView.reloadData()
    }
    
    
    @IBAction func showSavedStations(_ sender: Any) {
        self .showSavedStations()
        print("zebi")
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        let facStation = self.stationsArray[indexPath.row] as! StationData
        cell.delegate = self
        cell.stationName.text = facStation.streetName
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            self.managedContext.delete(self.stationsArray[indexPath.row] as! StationData)
            self.stationsArray.removeObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print(self.favoritTableView)
        }
        
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            // share item at indexPath
            print("I want to share: \(self.stationsArray[indexPath.row])")
        }
        
        share.backgroundColor = UIColor.lightGray
        
        return [delete, share]
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            self.showSavedStations()
            print("")
        }
        if item.tag == 1 {
            self.favoritTableView.isHidden = true
        }
    }

}
