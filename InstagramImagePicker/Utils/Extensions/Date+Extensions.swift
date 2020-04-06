//
//  Date+Extensions.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/04/06.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

extension Date {
    
    /// Get local time
    public func localTime() -> Date {
        let timeZone = TimeZone.current
        let seconds = TimeInterval(timeZone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    /// Get elapsed interval
    public func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        
        if self.isYesterday() {
            return "Yesterday"
        }
        
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current) + " " + "ago"
    }
    
    public func isToday() -> Bool {
        return NSCalendar.autoupdatingCurrent.isDateInToday(self)
    }
    
    public func isYesterday() -> Bool {
        return NSCalendar.autoupdatingCurrent.isDateInYesterday(self)
    }
}
