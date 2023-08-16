//
//  BasicHelper.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import Foundation

/**
 A struct that provides utility methods.
 */
struct BasicHelper {
    
    // A static function that returns a string representation of the given value.
    static func toString(_ val: Any?) -> String? {
        if val == nil {
            return nil
        }
        
        if (val is String){
            return (val as! String)
        } else if (val is Int){
            return String(val as! Int)
        } else if (val is Double ) {
            return String(val as! Double)
        } else if (val is Float ) {
            return String(val as! Float)
        }
        return nil
    }
    
    // A static function that returns an integer representation of the given value.
    static func toInt(_ val: Any?) -> Int? {
        if val == nil {
            return nil
        }
        if (val is Int){
            return (val as! Int)
        }else if (val is String){
            return Int(val as! String)
        }
        return nil
    }
    
    // A static function that returns a double representation of the given value.
    static func toDouble(_ val: Any?) -> Double? {
        if val == nil {
            return nil
        }
        if (val is Double){
            return (val as! Double)
        }else if (val is String){
            return Double(val as! String)
        }
        return nil
    }
    
    // A static function that returns a bool representation of the given value.
    static func toBool(_ val: Any?) -> Bool {
        if val == nil {
            return false
        }
        if (val is Bool){
            return (val as! Bool)
        }
        return false
    }
    
    static func getInitials(from name: String) -> String {
        let components = name.components(separatedBy: " ")
        let initials = components.compactMap { component in
            if let firstLetter = component.first {
                return String(firstLetter)
            }
            return nil
        }
        return initials.joined().uppercased()
    }
    
    static func getFormattedDateForCard(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
            
            if let year = components.year, year > 0 {
                return "\(year) year\(year > 1 ? "s" : "") ago"
            } else if let month = components.month, month > 0 {
                return "\(month) month\(month > 1 ? "s" : "") ago"
            } else if let day = components.day {
                if(day > 7){
                    let week = day / 7
                    return "\(week) week\(week > 1 ? "s" : "") ago"
                } else if(day == 0 && components.hour == 0 &&  (components.minute ?? 0) < 5){
                    return "Just now"
                }
                else{
                    dateFormatter.dateFormat = "EEEE, hh:mma"
                    dateFormatter.amSymbol = "am"
                    dateFormatter.pmSymbol = "pm"
                    return "\(dateFormatter.string(from: date))"
                }
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
}
