//
//  SpaceObject.swift
//  SpaceImage
//
//  Created by Михаил Иванов on 18.02.2022.
//

import Foundation

struct SpaceObject: Codable {
    let copyright: String?
    let date: String?
    let explanation: String?
    let hdurl: String?
    let title: String?
    
    init(objectsData: [String: Any]) {
        copyright = objectsData["copyright"] as? String
        date = objectsData["date"] as? String
        explanation = objectsData["explanation"] as? String
        hdurl = objectsData["hdurl"] as? String
        title = objectsData["title"] as? String
    }
    
    static func getSpaceObjects(from value: Any) -> [SpaceObject] {
        var spaceObjects:[SpaceObject] = []
        guard let objectsData = value as? [[String: Any]] else {
            return spaceObjects
        }
        
        for objectData in objectsData {
            let spaceObject = SpaceObject(objectsData: objectData)
            spaceObjects.append(spaceObject)
        }
        return spaceObjects
    }
}
