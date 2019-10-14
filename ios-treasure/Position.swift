//
//  Position.swift
//  ios-treasure
//
//  Created by Mario Holper on 13.10.19.
//  Copyright © 2019 Mario Holper. All rights reserved.
//

import Foundation

struct Position: Codable, CustomStringConvertible {
    var name: String //Name des Ortes
    var time: Date //Speicherzeitpunkt
    var lat: Double //geogr. Breite
    var long: Double //geogra. Längee
    
    init(_ name: String, _ time: Date, _ lat: Double, _ long: Double) {
        self.name = name
        self.time = time
        self.lat = lat
        self.long = long
    }
    //für die CustomStringConvertible
    var description: String {
        return name + "\(time) \(lat) \(long)"
    }
    
    //dauerhaftes speichern bzw. laden des Array von Positions-Struktur
    static func saveArray(_ data: [Position]) {
        if data.count == 0 {return}
        
        let enc = JSONEncoder()
        if let url = docURL(for: "position.json") {
            do {
                let jsondata = try enc.encode(data)
                try jsondata.write(to: url)
            } catch {
                print(error)
            }
        }
    }
    
    //Arry von Positions-Strukturen aus json-Dateil lesen
    static func readArray() -> [Position] {
        let dec = JSONDecoder()
        if let url = docURL(for: "position.json") {
            do {
                let jsondata = try Data(contentsOf: url)
                return try dec.decode([Position].self, from: jsondata)
            } catch {
                print(error)
            }
        }
        //wenn etwas nicht klappt: leeres Array zurückgeben
        return [Position]()
    }
    
    //liefert URL für Datei im Documents-Verzeichnis
    private static func docURL(for filename: String) -> URL? {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let docDir = urls.first {
            return docDir.appendingPathComponent(filename)
        }
        return nil
    }
}
