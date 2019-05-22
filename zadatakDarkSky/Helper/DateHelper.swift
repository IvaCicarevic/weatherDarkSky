//
//  DateHelper.swift
//  zadatakDarkSky
//
//  Created by Dusan Cucurevic on 5/8/19.
//  Copyright © 2019 Iva Cicarevic. All rights reserved.
//

import Foundation


class DateHelper{
    
    static func getLocalTime(unixTime: Double?, timezone: String?) -> String {
        
        guard let unixTime = unixTime, let timezone = timezone else {
            return ""
        }
        
        let date = Date(timeIntervalSince1970: unixTime)
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(identifier: timezone)
        
        return formatter.string(from: date)
    }
}
