//
//  station.swift
//  TTBSwift
//
//  Created by Mohamed Belfekih on 05/02/2018.
//  Copyright © 2018 Mohamed Belfekih. All rights reserved.
//

import UIKit
import CoreData
class Station: NSObject {
    var idStation : String = "";
    var streetName : String = "";
    var city : String = "";
    var latitude : String = "";
    var longitude : String = "";

    
    func initWithDict(dict: NSDictionary) -> Station {
        self.idStation = (dict["id"] is NSNull) ? "AQF" : (dict["id"] as? String)!;
        self.streetName = (dict["street_name"] is NSNull) ? "AQF" : (dict["street_name"] as? String)!;
        self.city = (dict["city"] is NSNull) ? "AQF" : (dict["city"] as? String)!;
        self.latitude = (dict["lat"] is NSNull) ? "AQF" : (dict["lat"] as? String)!;
        self.longitude = (dict["lon"] is NSNull) ? "AQF" : (dict["lon"] as? String)!;
        return self;
    }

}

