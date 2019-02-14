//
//  PeopleTableViewController.swift
//  DailyPlanet
//
//  Created by Ruhsane Sawut on 2/12/19.
//  Copyright © 2019 Make School. All rights reserved.
//

import UIKit

struct Person: Codable{
    let name: String
    let birthYear: String
    let gender: String
    
    init?(dict: [String: Any]) {
        self.name = dict["name"] as? String ?? ""
        self.birthYear = dict["birth_year"] as? String ?? ""
        self.gender = dict["gender"] as? String ?? ""
    }
}

class PeopleTableViewController: UITableViewController {

    var peopleArray = [Person]() {
        didSet {
            DispatchQueue.main.async {
            //            self.perform(#selector(self.loadTable), with: nil, afterDelay: 2.0)
                self.tableView.reloadData()
            }
        }
    }
    
    var index = 2
    let totalEntries = 90
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        fetchStarshipPeopleData(pageNumber: 1)
    }
    
    func fetchStarshipPeopleData(pageNumber: Int) {
        let defaultSession = URLSession(configuration: .default)
        
        //TODO: Create URL (...and send request and process response in closure...)
        if let url = URL(string: "https://swapi.co/api/people/?page=\(pageNumber)") {
            
            // TODO: Create Request here
            let request = URLRequest(url: url)
            
            //  Create Data Task...
            let dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                
//                print("data is: ", data!)
//                print("response is: ", response!)
//
                if let data = data {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        print(jsonObject)
                        
//                        self.peopleArray = jsonObject
                        if let results = jsonObject["results"] as? [[String: Any]] {
                            for entry in results {
                                let person = Person(dict: entry)
                                self.peopleArray.append(person!)
                            }
                        }
//                        DispatchQueue.main.async {
//                            //            self.perform(#selector(self.loadTable), with: nil, afterDelay: 2.0)
//                            self.tableView.reloadData()
//                        }
                    } catch {
                        print("JSON error: \(error.localizedDescription)")
                    }
                }
            })
            dataTask.resume()

        }

        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return peopleArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonTableViewCell

        // Configure the cell...
        cell.nameLabel.text = peopleArray[indexPath.row].name
        cell.birthYearLabel.text = peopleArray[indexPath.row].birthYear
        cell.genderLabel.text = peopleArray[indexPath.row].gender
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == peopleArray.count - 1 {
            // we are at last cell, load more data
            if peopleArray.count < totalEntries {
                if index <= 9 {
                    fetchStarshipPeopleData(pageNumber: index)
                    index += 1

                }
            }
        }
    }
//
//    @objc func loadTable(){
//            self.tableView.reloadData()
//    }
    
    
}
