//
//  EntryData.swift
//  HomeAssistant
//
//  Created by Alexey Burmistrov on 16.10.2021.
//

import Foundation

struct EntryData: Codable {
    var devices: [devices]
    var user: user
}

struct devices: Codable{
    let id: Int
    let deviceName: String
    let intensity: Int?
    let position: Int?
    let temperature: Int?
    let mode: String?
    let productType: String
}

struct user: Codable{
    let firstName: String
    let lastName: String
    let address: address
    let birthDate: Int
}

struct address: Codable{
    let city: String
    let postalCode: Int
    let street: String
    let streetCode: String
    let country: String
}
