//
// Created by Stefano Venturin on 19/03/17.
// Copyright (c) 2017 Stefano Venturin. All rights reserved.
//

import Foundation
import Alamofire
import Freddy

struct JSONParsing {
    
    /// From LocalDatastore
    static func testJSONFromLocal(jsonData: Data, completion: @escaping (_ result: Bool) -> Void) {
        do {
            let json = try JSON(data: jsonData)
            
            RealmQuery.saveObject(json: json, completion: {
                completion(true)
            })
            
        } catch let error as NSError {
            completion(false)
            print("Failed to load: \(error.localizedDescription)")
        }
    }
    
    /// From Remote
    static func testDownloadJSON(completion: @escaping (_ result: Bool) -> Void) {
        let URL = "https://gist.githubusercontent.com/ventuz88/91f0e37d40f6d80641ca8d9f2c11f039/raw/5a7c67ff3221d0796a735cb0c0e0eccc12d23fca/weather_forecast_100.json"
        
        /// Download JSON
        Alamofire.request(URL).responseJSON { (response) in
            let data = response.data
            
            do {
                /**
                 /// Transform the downloaded data to a Dictonary file
                 /// Extract an array of 'Data'
                 let dict = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                 */
                
                let json = try JSON(data: data!)
                /// print("testDownloadJSON ", json)
                
                RealmQuery.saveObject(json: json, completion: {
                    completion(true)
                })
                
            } catch let error as NSError {
                completion(false)
                print("Failed to load: \(error.localizedDescription)")
            }
        }
    }

}
