//
//  Alarm.swift
//  Commute Clock
//
//  Created by Alec Rodgers on 1/15/17.
//  Copyright © 2017 Alec Rodgers. All rights reserved.
//

import Foundation
import GooglePlaces

class Alarm {
	
    private var _prepTime: Int!
    private var _destination: GMSPlace
    private var _arrivalTime: Int!
    private var _transportationType: String!
    private var _activeDays: [Bool]
    
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
    
    func setActiveDays(days: [Bool]) {
        if days.count == 7 {
            _activeDays = days
        }
    }
    
    var activeDays: [Bool] {
        return _activeDays
    }
    
    init(prepTime: Int, destination: GMSPlace, arrivalTime: Int, transportationType: String, activeDays: [Bool]) {
        self._prepTime = prepTime
        self._destination = destination
        self._arrivalTime = arrivalTime
        self._transportationType = transportationType
        self._activeDays = activeDays
    }
    
}
