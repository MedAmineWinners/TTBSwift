//
//  HomeViewController.swift
//  TTBSwift
//
//  Created by Mohamed Belfekih on 05/02/2018.
//  Copyright © 2018 Mohamed Belfekih. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: MainViewController, UITableViewDelegate, UITableViewDataSource, HomeTableViewCellDelegate, MKMapViewDelegate {
    func firstDelegate(string: String) {
        print(string)
    }
    

    @IBOutlet weak var switcher: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    var mobileInterface = MobileInterface()
    var stationsArray : NSMutableArray = []
    let URL = "http://barcelonaapi.marcpous.com/bus/nearstation/latlon/41.3985182/2.1917991/1.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "HomeTableViewCell", bundle:nil)
        self.title = Bundle.main.infoDictionary!["CFBundleName"] as? String
        self.mapView.delegate = self;
        self.tableView.register(nibName,forCellReuseIdentifier: "HomeTableViewCell")
        self.retrieveStations()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stationsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell?
        let station = self.stationsArray[indexPath.row] as! Station
        cell?.delegate = self
       cell?.setStation(station: station)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stationDetail : DetailViewController = (storyboard?.instantiateViewController(withIdentifier: "DetailViewController")) as! DetailViewController
        stationDetail.station = self.stationsArray[indexPath.row] as! Station
        self.navigationController?.pushViewController(stationDetail, animated: true)
    }
    
    
    // MARK: Map
    func showLocationsOnMap(list : [Station]) {

        let regionRadius: CLLocationDistance = 5000
        for station in list {
            let artwork = MapAnnotation(title: station.streetName,
                                  locationName: station.streetName,
                                  discipline: "",
                                  coordinate: CLLocationCoordinate2D(latitude: Double(station.latitude)!, longitude: Double(station.longitude)!))
            let coordinateRegion  = MKCoordinateRegionMakeWithDistance(artwork.coordinate, regionRadius, regionRadius);
            mapView.addAnnotation(artwork)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? MapAnnotation else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! MapAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking];
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    @IBAction func switcherSelected(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.tableView.isHidden = true
            self.mapView.isHidden = false
        } else {
            self.tableView.isHidden = false
            self.mapView.isHidden = true
        }
    }
    
    func retrieveStations () {
        self.mobileInterface.requestStations(url: URL) { (stationDict, error) in
            if error == nil {
                let items = (stationDict["data"]! as! NSDictionary)["nearstations"] as! NSArray
                for station in items {
                    let stationDict:NSDictionary = station as! NSDictionary
                    let station = Station()
                    self.stationsArray.add(station .initWithDict(dict: stationDict))
                    
                }
                DispatchQueue.main.async {
                    self.tableView .reloadData()
                    self.showLocationsOnMap(list: self.stationsArray as! [Station])
                }
            } else {
                //TODO: new popup
            }
        }

    }
}

