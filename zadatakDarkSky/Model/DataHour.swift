//
//  DataHour.swift
//  zadatakDarkSky
//
//  Created by Iva Cicarevic on 5/7/19.
//  Copyright © 2019 Iva Cicarevic. All rights reserved.
//

import Foundation


class HourData: Decodable {
    
    var time: Double?
    var summary: String?
    var icon: String?
    var temperature: Float?
    
}
