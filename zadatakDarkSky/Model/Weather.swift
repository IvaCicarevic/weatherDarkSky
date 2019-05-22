//
//  Weather.swift
//  zadatakDarkSky
//
//  Created by Iva Cicarevic on 5/7/19.
//  Copyright © 2019 Iva Cicarevic. All rights reserved.
//

import Foundation


struct Weather: Decodable {
    
    var latitude: Float?
    var longtitude: Float?
    var timezone: String?
    var currently: Currently?
    var hourly: Hourly?
    var offset: Float?
}
