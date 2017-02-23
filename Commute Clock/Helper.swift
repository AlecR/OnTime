//
//  Helper.swift
//  Commute Clock
//
//  Created by Alec Rodgers on 2/22/17.
//  Copyright © 2017 Alec Rodgers. All rights reserved.
//

import Foundation

class Helper {
    
    // Converts a string representation of the time ("H:MM a" format) to an integer of total minutes
    static func timeToMinutes(selectedTime: String) -> Int? {
        var minutes = 0
        
        if let colonIndex = selectedTime.range(of: ":"), let spaceIndex = selectedTime.range(of: " ") {
            if selectedTime.substring(from: spaceIndex.upperBound) == "PM" {
                minutes += 720
            }
            
            let clockHours = (selectedTime.substring(to: colonIndex.lowerBound) as NSString).integerValue
            let clockMinutes = (selectedTime.substring(from: colonIndex.upperBound).substring(to: colonIndex.upperBound) as NSString).integerValue
            
            if selectedTime.substring(from: spaceIndex.upperBound) == "AM" && clockHours == 12 {
                return clockMinutes
            } else {
                minutes += clockHours * 60
                minutes += clockMinutes
            }
        }
        return minutes
    }
    
    // Converts an integer representing total minutes to a string representation of the time ("H:MM a" format)
    static func minutesToTime(minutes: Int) -> String? {
        var totalMinutes = minutes
        var isAM = true
        var timeString = ""
        var hours: Int
        
        if minutes > 720 {
            isAM = false
            totalMinutes -= 720
        }
        
        if totalMinutes/60 == 0 {
            hours = 12
        }else {
            hours = totalMinutes/60
        }
        
        timeString = "\(hours):\(String(format: "%02d", totalMinutes%60)) "
        
        if isAM {
            return timeString + "AM"
        } else {
            return timeString + " PM"
        }
        
    }
    
    static func isTimeFormat(string: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        if dateFormatter.date(from: string) != nil {
            return true
        }
        return false
    }
    
}
