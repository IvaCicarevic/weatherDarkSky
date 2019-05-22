//
//  CitySearch.swift
//  zadatakDarkSky
//
//  Created by Iva Cicarevic on 5/7/19.
//  Copyright © 2019 Iva Cicarevic. All rights reserved.
//

import Foundation
import MapKit


protocol CitySearchDelegate {

    func citySelected(city: MKMapItem)
}

class CitySearchTable: UITableViewController {
    
    //Mark:- Vars
    var matchingArray:[MKMapItem] = []
    var delegate: CitySearchDelegate?
    
}


extension CitySearchTable: UISearchResultsUpdating {
  
    func updateSearchResults(for searchController: UISearchController) {
       
        guard let searchBarText = searchController.searchBar.text else {
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        
        let search = MKLocalSearch(request: request)
        search.start { (response, _ ) in
            guard let response = response else {
                return
            }
            
           
            self.matchingArray = response.mapItems
            self.tableView.reloadData()
        }
    }
}

// MARK:- Table View protocol methods

extension CitySearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return matchingArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingArray[indexPath.row].placemark
        
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = ""
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.citySelected(city: matchingArray[indexPath.row])
        self.dismiss(animated: true,completion: nil)
        
    }
}
