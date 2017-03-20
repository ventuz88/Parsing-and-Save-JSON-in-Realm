//
// Created by Stefano Venturin on 19/03/17.
// Copyright (c) 2017 Stefano Venturin. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

struct RealmQuery {

    /** Save the JSON file on Realm */
    static func saveObject(json: JSON, completion:@escaping () -> Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            autoreleasepool {
                
                guard let realm = RealmUtils.shared.realm else {
                    return DispatchQueue.main.async(execute: { completion() })
                }
                
                do {
                    try realm.write({
                        let realmObject = try DataWeather(json: json)
                        // print(json)
                        realm.add(realmObject, update: true)
                    })
                    
                    DispatchQueue.main.async(execute: { completion() })
                    
                } catch let error {
                    print(error)
                    DispatchQueue.main.async(execute: { completion() })
                }
            }
        }
    }
    
    
    /** Retrieve the object with the given predicate */
    static func getObject(withId: String) -> Results<WeatherResponse>? {
        let realm = RealmUtils.shared.realm!
        let predicate = NSPredicate(format: "id == %@", argumentArray: [withId])
        return realm.objects(WeatherResponse.self).filter(predicate)
    }

}
