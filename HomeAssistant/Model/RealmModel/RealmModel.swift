//
//  RealmModel.swift
//  HomeAssistant
//
//  Created by Alexey Burmistrov on 16.10.2021.
//

import UIKit
import RealmSwift

let realm = try! Realm()

class NewEntryModelRealm : Object {
    var devices = List<devicesRealm>()
    var user: userRealm?
}

class devicesRealm: Object{
    @objc dynamic var id = 0
    @objc dynamic var deviceName = ""
    @objc dynamic var intensity = 0
    @objc dynamic var position = 0
    @objc dynamic var temperature = 0
    @objc dynamic var mode: String?
    @objc dynamic var productType = ""
}

class userRealm: Object{
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    var address: addressRealm?
    @objc dynamic var birthDate = 0
}

class addressRealm: Object {
    @objc dynamic var city = ""
    @objc dynamic var postalCode = 0
    @objc dynamic var street = ""
    @objc dynamic var streetCode = ""
    @objc dynamic var country = ""
}
class selectedDevice: Object{
    @objc dynamic var id = 0
    @objc dynamic var deviceName = ""
    @objc dynamic var intensity = 0
    @objc dynamic var position = 0
    @objc dynamic var temperature = 0
    @objc dynamic var mode: String?
    @objc dynamic var productType = ""
}


class StorageManager {
    
    static func resetData() {
        let urlString = "http://storage42.com/modulotest/data.json"
        
        let json = try! Data(contentsOf: URL(string: urlString)!)
        
        let decoder = JSONDecoder()
        if let parsedData = try? decoder.decode(EntryData.self, from: json){
            
            try! realm.write{
                realm.deleteAll()
                let newUser = NewEntryModelRealm()
                for i in 0...parsedData.devices.count - 1 {
                    let newDeviceInfo = devicesRealm()
                    newDeviceInfo.id = parsedData.devices[i].id
                    newDeviceInfo.deviceName = parsedData.devices[i].deviceName
                    newDeviceInfo.intensity = parsedData.devices[i].intensity ?? 0
                    newDeviceInfo.position = parsedData.devices[i].position ?? 0
                    newDeviceInfo.temperature = parsedData.devices[i].temperature ?? 0
                    newDeviceInfo.mode = parsedData.devices[i].mode ?? ""
                    newDeviceInfo.productType = parsedData.devices[i].productType
                    newUser.devices.append(newDeviceInfo)
                }
                let userAdress = addressRealm()
                userAdress.city = parsedData.user.address.city
                userAdress.postalCode = parsedData.user.address.postalCode
                userAdress.street = parsedData.user.address.street
                userAdress.streetCode = parsedData.user.address.streetCode
                userAdress.country = parsedData.user.address.country
                
                let userInfo = userRealm()
                
                userInfo.address = userAdress
                userInfo.firstName = parsedData.user.firstName
                userInfo.lastName = parsedData.user.lastName
                userInfo.birthDate = parsedData.user.birthDate
                
                newUser.user = userInfo
                
                realm.create(NewEntryModelRealm.self, value: newUser)
            }
        }
    }
    
    static func deleteObject (_ device: devicesRealm){
        try! realm.write{
            realm.delete(device)
        }
    }
    
    static func saveCurrentDevice(_ device: devicesRealm) {
        let selected = selectedDevice()
        selected.id = device.id
        selected.deviceName = device.deviceName
        selected.intensity = device.intensity
        selected.position = device.position
        selected.temperature = device.temperature
        selected.mode = device.mode ?? ""
        selected.productType = device.productType
        
        try! realm.write{
            realm.delete(realm.objects(selectedDevice.self))
            realm.create(selectedDevice.self, value: selected)
        }
    }
    
    static func updateCurrentDevice(_ device: selectedDevice) {
        
        let selected = devicesRealm()
        selected.id = device.id
        selected.deviceName = device.deviceName
        selected.intensity = device.intensity
        selected.position = device.position
        selected.temperature = device.temperature
        selected.mode = device.mode ?? ""
        selected.productType = device.productType
        let deviceList = realm.objects(devicesRealm.self).filter({$0.id == selected.id})
        if let device = deviceList.first {
            try! realm.write {
                device.intensity = selected.intensity
                device.temperature = selected.temperature
                device.position = selected.position
                device.mode = selected.mode
                
            }
        }
    }
}

