//
//  Date_extenshion.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 24.12.21.
//

import Foundation

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var year: Int {
        return Calendar.current.component(.year,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))" + "M".localized()    }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))" + "D".localized()    }
        if hours(from: date)   > 0 { return "\(hours(from: date))" + "hr".localized()   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))" + "min".localized() }
        if seconds(from: date) > 0 { return "\(seconds(from: date))" + "sec".localized()  }
        return ""
    }
    
    //New Year
    var christmasIconStartDay: Date? {
        var component = DateComponents()
        component.year = month == 1 ?  year - 1 : year
        component.month = 12
        component.day  = 20

        return Calendar.current.date(from: component)
    }

    var christmasIconEndDay: Date? {
        var component = DateComponents()
        component.year = month == 1 ? year : year + 1
        component.month = 1
        component.day  = 15
        return Calendar.current.date(from: component)
    }
    
    var isChristmasDay: Bool {
        guard let startDate = christmasIconStartDay, let endDate = christmasIconEndDay else { return false }
        return self >= startDate && self <= endDate
    }
}
