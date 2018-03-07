//
//  MobileInterface.swift
//  TTBSwift
//
//  Created by Mohamed Belfekih on 07/02/2018.
//  Copyright © 2018 Mohamed Belfekih. All rights reserved.
//

import UIKit

class MobileInterface: NSObject, URLSessionDelegate {
    
    func requestStations(url:String, completion: @escaping (_ dict: [String : Any], _ error: Error? ) -> Void) {
        let urlStation = URL(string: url)
        let urlRequest = URLRequest(url: urlStation!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                do {
                    let dictionnary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                    completion(dictionnary!, error)
                }catch {
                    
                }
            } else {
                completion([:], error)
            }
       
        }
        task.resume()
    }
}

