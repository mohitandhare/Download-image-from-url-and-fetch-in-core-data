//
//  HomeData+CoreDataProperties.swift
//  Download image from url and fetch in core data
//
//  Created by Developer Skromanglobal on 14/07/22.
//
//

import Foundation
import CoreData


extension HomeData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HomeData> {
        return NSFetchRequest<HomeData>(entityName: "HomeData")
    }

    @NSManaged public var homeName: String?
    @NSManaged public var homeImage: String?
    @NSManaged public var imageUrl : URL?
}

extension HomeData : Identifiable {

}
