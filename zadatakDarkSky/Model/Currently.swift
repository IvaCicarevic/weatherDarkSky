//
//  Currently.swift
//  zadatakDarkSky
//
//  Created by Iva Cicarevic on 5/7/19.
//  Copyright © 2019 Iva Cicarevic. All rights reserved.
//

import Foundation

struct Currently: Decodable {
    
    var time: Double?
    var summary: String?
    var icon: String?
    var precipIntensity: Float?
    var precipProbability: Float?
    var temperature: Float?
    var humidity: Float?
    var windSpeed: Float?
    var pressure: Float?
    var uvIndex: Float?
    
}
