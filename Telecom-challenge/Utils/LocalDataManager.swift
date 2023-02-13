//
//  LocalDataManager.swift
//  Telecom-challenge
//
//  Created by Natalia MR on 2/13/23.
//

import Foundation

class LocalDataManager {
	func store(coords: [CoordModel]) {
		let defaults = UserDefaults.standard
		let encoder = JSONEncoder()
		if let encoded = try? encoder.encode(coords){
			UserDefaults.standard.set(encoded, forKey: "coords")
		}
	}
	
	func retrieveCoords() -> [CoordModel]? {
		if let coordsData = UserDefaults.standard.value(forKey: "coords") as? Data {
			let decoder = JSONDecoder()
			if let coords = try? decoder.decode(Array.self, from: coordsData) as [CoordModel] {
				return coords
			}
		}
		return nil
	}
}
