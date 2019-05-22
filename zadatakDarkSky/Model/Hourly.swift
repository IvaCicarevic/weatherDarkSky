//
//  Hourly.swift
//  zadatakDarkSky
//
//  Created by Iva Cicarevic on 5/7/19.
//  Copyright © 2019 Iva Cicarevic. All rights reserved.
//

import Foundation

class Hourly: Decodable {
    
    var summary: String?
    var icon: String?
    var data: [HourData]?
    
}
