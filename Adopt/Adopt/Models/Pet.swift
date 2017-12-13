//
//  Pet.swift
//  Adopt
//
//  Created by Chuang Boris on 11/12/2017.
//  Copyright © 2017 Chuang Boris. All rights reserved.
//
import UIKit
import Foundation
import CoreData

struct DataTaipei: Codable {
    var result: PetResults
}

struct PetData: Codable {
    var _id: String
    var Name: String
    var Sex: String
    var `Type`: String
    var Build: String
    var Age: String
    var Variety: String
    var Reason: String
    var AcceptNum: String
    var ChipNum: String
    var IsSterilization: String
    var HairType: String
    var Note: String
    var Resettlement: String
    var Phone: String
    var Email: String
    var ChildreAnlong: String
    var AnimalAnlong: String
    var Bodyweight: String
    var ImageName: String
    
}

struct PetResults: Codable {
    var offset: Int
    var limit: Int
    var count: Int
    var sort: String
    var results: [PetData]
}
