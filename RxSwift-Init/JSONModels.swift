//
// Created by Stefano Venturin on 18/03/17.
// Copyright (c) 2017 Stefano Venturin. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        return flatMap { $0 as? T }
    }
}


// 1
class DataWeather: Object, JSONDecodable {
    dynamic var data: String = "0"

    var dataList = List<WeatherResponse>()

    override class func primaryKey() -> String {
        return "data"
    }
    
    /// Creates an instance of the model with a `JSON` instance.
    /// - parameter json: An instance of a `JSON` value from which to
    ///             construct an instance of the implementing type.
    /// - throws: Any `JSON.Error` for errors derived from inspecting the
    ///           `JSON` value, or any other error involved in decoding.
    required convenience init(json value: JSON) throws {
        self.init()
        
        /// Array
        let toList = try value.getArray(at: "data").flatMap({ try WeatherResponse.init(json: $0) })
        self.dataList = List(toList)
    }
}


// 2
class WeatherResponse: Object, JSONDecodable  {
    
    dynamic var id: String? = ""
    dynamic var location: String? = ""
    var three_day_forecast = List<Forecast>()
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    required convenience init(json value: JSON) throws {
        self.init()
        
        /// Single values
        self.id = try value.getString(at: "id")
        self.location = try value.getString(at: "location")
        
        /// Array
        let toList = try value.getArray(at: "three_day_forecast").flatMap({ try Forecast.init(json: $0) })
        self.three_day_forecast = List(toList)
    }
}

// 3
class Forecast: Object, JSONDecodable {
   
    dynamic var day: String? = nil
    dynamic var temperature: Int = 0
    dynamic var conditions: String? = nil
    
    required convenience init(json value: JSON) throws {
        self.init()
        
        self.day = try value.getString(at: "day")
        self.temperature = try value.getInt(at: "temperature")
        self.conditions = try value.getString(at: "conditions")
    }
}


