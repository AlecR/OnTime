//
//  Alarm.swift
//  Commute Clock
//
//  Created by Alec Rodgers on 1/15/17.
//  Copyright © 2017 Alec Rodgers. All rights reserved.
//

import Foundation
import GooglePlaces
import FirebaseDatabase
import Firebase

class Alarm {
	
    private var _prepTime: Int!
    private var _destination: GMSPlace
    private var _arrivalTime: Int!
    private var _transportationType: String!
    
    var prepTime: Int! {
        return _prepTime
    }
    
    var destination: GMSPlace {
        return _destination
    }
    
    var arrivalTime: Int! {
        return _arrivalTime
    }
    
    var transportationType: String! {
        return _transportationType
    }
    
    init(prepTime: Int, destination: GMSPlace, arrivalTime: Int, transportationType: String) {
        self._prepTime = prepTime
        self._destination = destination
        self._arrivalTime = arrivalTime
        self._transportationType = transportationType
    }
	
    
    func saveAlarmToDatabase(ref: FIRDatabaseReference) {
        let alarmId = ref.child("users/\(USER_UUID)").childByAutoId()
        alarmId.child("arrivalTime").setValue(arrivalTime)
        alarmId.child("prepTime").setValue(prepTime)
        alarmId.child("transportation").setValue(transportationType)
        
        let locationData = alarmId.child("location")
        locationData.child("latitude").setValue(destination.coordinate.latitude)
        locationData.child("longitude").setValue(destination.coordinate.longitude)
        locationData.child("address").setValue(destination.formattedAddress)
        locationData.child("name").setValue(destination.name)
    }

    
}
