//
//  DataService.swift
//  Commute Clock
//
//  Created by Alec Rodgers on 2/23/17.
//  Copyright © 2017 Alec Rodgers. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class DataService {
    
    static let shared = DataService()
    
    var BASE_REF: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    var CURRENT_USER_REF: FIRDatabaseReference {
        return BASE_REF.child("users/\(USER_UUID)")
    }
    
    func saveAlarmToDatabase(alarm: Alarm) {
        let alarmId = CURRENT_USER_REF.childByAutoId()
        alarmId.child("arrivalTime").setValue(alarm.arrivalTime)
        alarmId.child("prepTime").setValue(alarm.prepTime)
        alarmId.child("transportation").setValue(alarm.transportationType)
        alarmId.child("daysActive").setValue(alarm.activeDays)
        
        let locationData = alarmId.child("location")
        locationData.child("latitude").setValue(alarm.destination.coordinate.latitude)
        locationData.child("longitude").setValue(alarm.destination.coordinate.longitude)
        locationData.child("address").setValue(alarm.destination.formattedAddress)
        locationData.child("name").setValue(alarm.destination.name)
    }
    
}
