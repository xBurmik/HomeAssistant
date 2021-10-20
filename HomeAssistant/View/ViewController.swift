//
//  ViewController.swift
//  HomeAssistant
//
//  Created by Alexey Burmistrov on 08.10.2021.
//

import UIKit
import RealmSwift

class ViewController: UITableViewController {
    
    var devices: [devicesRealm] = Array(realm.objects(devicesRealm.self))

    private var filtered = [devicesRealm]()
    private var searchText = String()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchController.searchBar.accessibilityIdentifier = "SearchBar"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.returnKeyType = .done
        searchController.automaticallyShowsCancelButton = false
        
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home Assistant"
        //temp button for data refresh
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                           target: self,
                                                           action: #selector(ButtonPress))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
        
        searchController.searchBar.isTranslucent = false
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        filtered = devices
    }
    
    @objc func ButtonPress() {
        StorageManager.resetData()
        devices = Array(realm.objects(devicesRealm.self))
        filtered = devices
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        let device = filtered[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row + 1)) \(device.deviceName)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = filtered[indexPath.row]
        
        var newVC = UIViewController()
        
        switch device.productType{
        case "Light":
            newVC = LightsViewController()
        case "RollerShutter":
            newVC = RollerShutterViewController()
        case "Heater":
            newVC = HeaterViewController()
        default:
            print("I dont know this devise")
        }
        
        StorageManager.saveCurrentDevice(device)
        newVC.title = device.deviceName
        
        
        navigationItem.backButtonTitle = "Home"
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let device = filtered[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            StorageManager.deleteObject(device)
            self.devices.remove(at: indexPath.row)
            self.filtered = self.devices
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeActions
    }
}

extension ViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.lowercased()
        let filtered = Array(devices.filter({$0.deviceName.lowercased().contains(searchText) || $0.productType.lowercased().contains(searchText)}))
        self.filtered = filtered.isEmpty ? devices : filtered
        tableView.reloadData()
    }
}


