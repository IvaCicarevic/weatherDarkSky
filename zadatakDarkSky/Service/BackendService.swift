//
//  BackendService.swift
//  zadatakDarkSky
//
//  Created by Iva Cicarevic on 5/7/19.
//  Copyright © 2019 Iva Cicarevic. All rights reserved.
//

import Foundation


protocol BackendServiceProtocol {
    
    func forecastRetrieved(_ forecast: Weather)
    func receivedError(_ message: String?)
}

class BackendService {
    
    //Singleton pattern
    static var shared = BackendService()
    private var urlSession: URLSession!
    
    private init(){
        urlSession = URLSession.shared
    }
    
    let basicURL = "https://api.darksky.net/forecast/"
    let apiKey = "e432474a4f1ef86bbd6db1dccf54bf9d"
    
    var delegate: BackendServiceProtocol?
    
    func getWeatherData(lat: Double, long: Double){
        let urlString = "\(basicURL)\(apiKey)/\(lat),\(long)?exclude=minutely,daily,alerts,flags"
        if let url = URL(string: urlString) {
            self.requestForWeatherData(url: url)
        }
        else{
            self.delegate?.receivedError("Could not create url object")
        }
    }
    
    private func requestForWeatherData(url: URL){
        
        let dataTask = urlSession.dataTask(with: url) { [weak self] (data, response, error) in
            
            if error == nil && data != nil {
                
                do {
                    let decoder = JSONDecoder()
                    
                    let result = try decoder.decode(Weather.self, from: data!)
                    
                    //Ovo ne treba da bude u main. U main ide samo prikaz na UI
//                    DispatchQueue.main.async {
                        self?.delegate?.forecastRetrieved(result)
                        print(result)
//                    }
                }
                catch {
                    self?.delegate?.receivedError("Bad data")
                }
            }
            else if error != nil {
                self?.delegate?.receivedError(error?.localizedDescription)
            }
        }
        
        dataTask.resume()
    }
}
/*
class WeatherData {
    
    //Mark:- Var
    var delegate: WeatherDataProtocol?
    

    //Mark:- function
    func getWeatherData(_ latitude: Double!,_ longtitude: Double!) {
        
        let stringUrl = "https://api.darksky.net/forecast/e432474a4f1ef86bbd6db1dccf54bf9d/\(latitude!),\(longtitude!)?exclude=minutely,daily,alerts,flags"
        
        let url = URL(string: stringUrl)
        
        guard url != nil else {
            print("Could not create url object")
            return
        }
     
        //Mark:- object
        
        
        
    }
}
*/
