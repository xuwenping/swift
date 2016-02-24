//
//  Location+CoreDataProperties.swift
//  MyLocations
//
//  Created by devinxu on 2/21/16.
//  Copyright © 2016 devinxu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData
import CoreLocation

extension Location {

    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var date: NSDate
    @NSManaged var locationDescription: String?
    @NSManaged var category: String?
    @NSManaged var placemark: CLPlacemark?

}
