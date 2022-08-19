//
//  ManageMovieImage.swift
//  MockingMovieApp
//
//  Created by Tan Tan on 8/11/22.
//
//

import Foundation
import CoreData

@objc(ManageMovie)
public class ManageMovie: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManageMovie> {
        return NSFetchRequest<ManageMovie>(entityName: "ManageMovie")
    }

    @NSManaged public var data: Data?
    @NSManaged public var posterPath: String
    @NSManaged public var url: URL?
    @NSManaged public var title: String
    @NSManaged public var id: Int32
    
    static func data(with url: URL, in context: NSManagedObjectContext) throws -> Data? {
        if let data = context.userInfo[url] as? Data { return data }

        return try first(with: url, in: context)?.data
    }

    static func first(with url: URL, in context: NSManagedObjectContext) throws -> ManageMovie? {
        let request = NSFetchRequest<ManageMovie>(entityName: ManageMovie.entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManageMovie.url), url])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
}
