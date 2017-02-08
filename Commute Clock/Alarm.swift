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
	
    var prepTime: Int!
    var destination: GMSPlace
    var arrivalTime: Int!
    
    init(prepTime: Int, destination: GMSPlace, arrivalTime: Int) {
        self.prepTime = prepTime
        self.destination = destination
        self.arrivalTime = arrivalTime
    }
	
}
