//
//  NotificationExtensions.swift
//  Commute Clock
//
//  Created by Alec Rodgers on 3/2/17.
//  Copyright © 2017 Alec Rodgers. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    enum Names {
        static let ToAlarms = Notification.Name(rawValue: "toAlarms")
        static let DisplayCreatedAlarmMessage = Notification.Name(rawValue: "displayCreatedAlarmMessage")
        static let KeyboardDidShow = Notification.Name(rawValue: "keyboardDidShow")
        static let KeyboardDidHide = Notification.Name(rawValue: "keyboardDidHide")
    }
}
