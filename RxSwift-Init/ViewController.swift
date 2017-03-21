//
// Created by Stefano Venturin on 18/03/17.
// Copyright (c) 2017 Stefano Venturin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    internal var methodStart: Date?
    internal var allTime : Date?
    internal var realmDate:Date?
    
    ///  Path where is JSON's for test
    ///  Value are: 100, 1000, 10000, 50000
    private lazy var JSONdata: Data = {
        let path = Bundle(for: type(of: self)).url(forResource: "weather_forecast_100", withExtension: "json")
        let data = try! Data(contentsOf: path!)
        return data
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Start JSON Parse
        self.parseJSON(fromLocal: true)
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }

    
    /**
      --  --
     */
    private func parseJSON(fromLocal: Bool) {
        /// Where to bring the JSON to Serialize
        if fromLocal {
            /// Start timer
            self.timer(start: true)
            
            JSONParsing.testJSONFromLocal(jsonData: JSONdata, completion: { (result) in
                self.timer(start: false)
                
                let objetc = RealmQuery.getObject(withId: "22")
                print(objetc ?? "*** The Object(s) does NOT exist(s) ***")
            })
        } else {
            /// Start timer
            self.timer(start: true)
            
            /** Call the download JSON method */
            JSONParsing.testDownloadJSON { (result) in
                if result {
                    self.timer(start: false)
                    
                    let objetc = RealmQuery.getObject(withId: "22")
                    print(objetc ?? "*** The Object(s) does NOT exist(s) ***")
                }
            }
        }
    }
    
    
    /**
     --- Stop the timer to see how many time take to serialize ad save in Realm ---
     */
    private func timer(start: Bool) {
        if start {
            /// Start timer
            self.methodStart = Date()
        } else {
            let end = Date()
            let time = end.timeIntervalSince(self.methodStart!)
            print("TOTAL TIME: ", time)
        }
    }
    
}

