//
//  ViewController.swift
//  zadatakDarkSky
//
//  Created by Iva Cicarevic on 5/7/19.
//  Copyright © 2019 Iva Cicarevic. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    // MARK:- Ref
    let locationManager = CLLocationManager()
    
    // Nema potrebe da postoji referenca sa VC na ovaj forecast, jer sve to moze da se zavrsi kroz input u metodi
    var forecast: Weather?
    var hours:[HourData]?
    
    let weatherIconImage = SKYIconView(frame: CGRect(x: 0, y: 0, width: 160, height: 90))
    
    var searchBar:UISearchBar?
  
    var locationString: String?
   
    var fahrenheitIsSelected: Bool = true
    
    var backgroundColor:UIColor?
    var textColor:UIColor?
    
    var resultSearchController: UISearchController? = nil
    

    // MARK:-  IB Outlet properties
 
    @IBOutlet weak var backgorundImage: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temperature: UILabel!

    // Reference to UIButton objects
    @IBOutlet weak var celsius: UIButton!
    @IBOutlet weak var fahrenheit: UIButton!
    
    // Detail Stack View Label Outlets
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var precipProbability: UILabel!
    
    
    //MARK:- UIViewController override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Ove cemo da setuje delegat za backend request servis
        BackendService.shared.delegate = self
        
        // Ove stvari mogu da se setuju u jednu fuknciju setupLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
      
        //Ovo je vezano za UI, i treba da bude grupisano na jendom mestu
        weatherIconImage.backgroundColor = UIColor.clear
      
        // Ovo je setup search-a. Isto ga treba grupisati u jednu fuknciju
        let citySearchTable = storyboard!.instantiateViewController(withIdentifier: "CitySearchTable") as! CitySearchTable
      
        resultSearchController = UISearchController(searchResultsController: citySearchTable)
        resultSearchController?.searchResultsUpdater = citySearchTable
        citySearchTable.delegate = self
        
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "See weather in..."
        searchBar.backgroundColor = UIColor.clear
        navigationItem.titleView = resultSearchController?.searchBar
        
      
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
      
        // Ovo je UI
        fahrenheit.alpha = 0.3
        celsius.setTitleColor(textColor, for: .normal)
        celsius.setTitleColor(textColor, for: .selected)
    }
    
    //MARK:- Config UI
    private func configUI(){
        
    }
    
    //MARK:- View Controller Custom Methods
    
    private func setCurrentWeather(weatherData: Weather){

        let localTime = DateHelper.getLocalTime(unixTime: weatherData.currently?.time, timezone: weatherData.timezone)
    }
    //OVa metoda treba da bude setCurrentWeather(weatherData: Weather)
    func setCurrentWeatherUI() {

        let localTime = getLocalTime(unixTime: forecast!.currently!.time!, timezone: forecast!.timezone!)

        cityName.text = locationString!
        currentTime.text = "\(localTime) local time"
        setCurrentIcon()
        weatherDescription.text = forecast!.currently!.summary!
        precipProbability.text = "Precipitation Probability: \(forecast!.currently!.precipProbability!)"
        humidity.text = "Humidity: \(forecast!.currently!.humidity!)"
        
        setTemp()
        
    }
  
    //Temperatura isto tako treba da primi parametar weather
    private func setTemperature(weatherData: Weather){
        
    }
    func setTemp() {
        if fahrenheitIsSelected == true {
            temperature.text = "\(forecast!.currently!.temperature!)"
        } else if fahrenheitIsSelected == false {
            let tempF = forecast!.currently!.temperature!
            let tempC = (tempF - 32)*(5/9)
            temperature.text = String(format: "%.2f", tempC)
        }
    }
    
    private func setIcon(weatherData: Weather){
        guard let icon = weatherData.currently?.icon else {return}
        
        switch icon{
        case "clear-day":
            weatherIconImage.setType = .clearDay
            backgroundColor = UIColor.blue
            textColor = UIColor.white
        case "clear-night":
            weatherIconImage.setType = .clearNight
//            ...
        default:
            break
        }
    }
    func setCurrentIcon() {
        
        //Ovo je bolje uraditi kroz switch. Iznad sam zapoceo metodu
        
        if forecast!.currently!.icon! == "clear-day" {
            weatherIconImage.setType = .clearDay
            
            // nema potrebe imati referencu bacgroundColor i textColor. Moze se odmah pozvati funcija
//            setColors(foreground: UIColor.white, background: UIColor.blue)
            backgroundColor = UIColor.blue
            textColor = UIColor.white
            
        } else if forecast!.currently!.icon! == "clear-night" {
            weatherIconImage.setType = .clearNight
            backgroundColor = UIColor.purple
            textColor = UIColor.yellow
            
        } else if forecast!.currently!.icon! == "rain" {
            weatherIconImage.setType = .rain
            backgroundColor = UIColor.lightGray
            textColor = UIColor.blue
            
        } else if forecast!.currently!.icon! == "sleet" {
            weatherIconImage.setType = .sleet
            backgroundColor = UIColor.lightGray
            textColor = UIColor.cyan
            
        } else if forecast!.currently!.icon! == "wind" {
            weatherIconImage.setType = .wind
            backgroundColor = UIColor.lightGray
            textColor = UIColor.black
            
        } else if forecast!.currently!.icon! == "fog" {
            weatherIconImage.setType = .fog
            backgroundColor = UIColor.lightGray
            backgroundColor = UIColor.white
            
        } else if forecast!.currently!.icon! == "cloudy" {
            weatherIconImage.setType = .cloudy
            backgroundColor = UIColor.lightGray
            textColor = UIColor.black
            
        } else if forecast!.currently!.icon! == "partly-cloudy-day" {
            weatherIconImage.setType = .partlyCloudyDay
            backgroundColor = UIColor.lightGray
            textColor = UIColor.black
            
        } else if forecast!.currently!.icon! == "partly-cloudy-night" {
            weatherIconImage.setType = .partlyCloudyNight
            backgroundColor = UIColor.purple
            textColor = UIColor.yellow
            
            
        } else if forecast!.currently!.icon! == "snow" {
            weatherIconImage.setType = .snow
            backgroundColor = UIColor.cyan
            textColor = UIColor.white
            
        }
        
        setColors(foreground: textColor!, background: backgroundColor!)
        weatherIcon.addSubview(weatherIconImage)
        
    }
   
    //Ovo je dobro napraviti helper classu (Napravio sam DateHelper, pa pogledaj kako bi to moglo da izgleda)
    func getLocalTime(unixTime: Double, timezone: String) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(identifier: timezone)
        
        return formatter.string(from: date)
    }
 
    // Ovo treba prebaciti u deo ispod MARK:- Config UI 
    func setColors(foreground: UIColor, background: UIColor) {
        
        // Set the label colors in the header stack views
        temperature.textColor = foreground
        weatherDescription.textColor = foreground
        cityName.textColor = foreground
        currentTime.textColor = foreground
        
    
        precipProbability.textColor = foreground
        humidity.textColor = foreground
        fahrenheit.titleLabel!.textColor = foreground
        celsius.titleLabel!.textColor = foreground
        
        weatherIconImage.setColor = foreground
        
        backgorundImage.backgroundColor = background
    }
    
    
    // MARK:- IBAction Methods
    
    @IBAction func chooseFahrenheit(_ sender: UIButton) {
        
        if fahrenheitIsSelected == true {
            return
        } else if fahrenheitIsSelected == false {
            // Make fahrenheit selected and celsisus unselected, reload temp label and collectionview cells
            fahrenheit.alpha = 1
            celsius.alpha = 0.3
            fahrenheitIsSelected = true
            setTemp()
            
        }
    }
 

    @IBAction func chooseCelsius(_ sender: UIButton) {
    
        if fahrenheitIsSelected == true {
            fahrenheit.alpha = 0.3
            celsius.alpha = 1
            fahrenheitIsSelected = false
            setTemp()
           
            
        } else if fahrenheitIsSelected == false {
            return
        }
    }
}


// Delegate methods for CLLocation manager
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            print("location: \(location)")
    
            locationString = "Your current location"
            
            if let lat = locationManager.location?.coordinate.latitude, let long = locationManager.location?.coordinate.longitude{
                getWeatherData(long: long, lat: lat)
            }
        }
    }
   
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:\(error)")
    }
    
    
    //MARK:- Server request
    private func getWeatherData(long: Double, lat: Double){
        BackendService.shared.getWeatherData(lat: lat, long: long)
    }
}

// Delegate methods for the WeatherDataProtocol
extension ViewController : BackendServiceProtocol{
    func receivedError(_ message: String?) {
        let alertVC = UIAlertController(title: "Error", message: message ?? "Unknown message", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func forecastRetrieved(_ forecast: Weather) {
        
        self.forecast = forecast
        
        // Ova metoda treba da se promeni u setWeather(weather: forecast) U njoj treba da se setuje sve
        DispatchQueue.main.async {
            self.setCurrentWeatherUI()
            
            self.fahrenheit.setTitleColor(self.textColor, for: .normal)
            self.fahrenheit.setTitleColor(self.textColor, for: .selected)
            self.celsius.setTitleColor(self.textColor, for: .normal)
            self.celsius.setTitleColor(self.textColor, for: .selected)
        }
    }
}

// Delegate methods for the CitySearchTable.
extension ViewController: CitySearchDelegate {
  
    func citySelected(city: MKMapItem) {
        locationString = city.name
        if let long = city.placemark.location?.coordinate.longitude, let lat = city.placemark.location?.coordinate.latitude{
            getWeatherData(long: long, lat: lat)
        }
    }
}




