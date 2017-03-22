//
// Created by Stefano Venturin on 18/03/17.
// Copyright (c) 2017 Stefano Venturin. All rights reserved.
//

import UIKit

class Main: UIViewController {

    internal var methodStart: Date?
    internal var allTime : Date?
    internal var realmDate:Date?
    
    ///  Path where is JSON's file for test
    ///  Value are: 100, 1000, 10000, 50000
    private lazy var JSONdata: Data = {
        let path = Bundle(for: type(of: self)).url(forResource: "weather_forecast_1000", withExtension: "json")
        let data = try! Data(contentsOf: path!)
        return data
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Start JSON Parse
        self.parseJSON(fromLocal: true)
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    /// Save JSON in Realm and download it based on 'paramerer' inserted.
    /// - parameter fromLocal: Boolean value, if FALSE the JSON file is download
    ///             from Github.
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
    
    /// --- Stop the timer to see how many time take to serialize ad save in Realm --- 
    /// - parameters start: Boolean value, if TRUE start the timer. When switched to
    ///              FALSE the timer were stopped and total time printed (in seconds),
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
    
    
    internal func goToRxController() {
        let controller = RxURLSession.instantiate(fromAppStoryboard: .RxURLSession)
        self.navigationController?.show(controller, sender: self)
    }
    
    // ****************************************************************************
    // MARK: Action
    // ****************************************************************************
    @IBAction func goAhead(_ sender: UIButton) {
        self.goToRxController()
    }
    
}

