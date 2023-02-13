//
//  WeatherService.swift
//  Telecom-challenge
//
//  Created by Natalia MR on 2/10/23.
//

import Foundation

class WeatherService {
	let URL = "https://api.openweathermap.org/data/2.5/weather"
	let APP_ID = "24474049c0df391dbf7303f387e00f83"
	let UNIT = "metric"
	
	
	func retrieveWeather(withLat lat: String, andLong lon: String, onSucess: @escaping (MainModel) -> Void, onError: @escaping () -> Void) {
		retrieveWeather(withDict: ["lat" : lat,
								   "lon" : lon,
								   "appid" : APP_ID,
								   "units" : UNIT],
						onSucess: onSucess,
						onError: onError)
	}
	
	func retrieveWeather(withCityName city: String, onSucess: @escaping (MainModel) -> Void, onError: @escaping () -> Void) {
		retrieveWeather(withDict: ["q" : city,
								   "appid" : APP_ID,
								   "units" : UNIT],
						onSucess: onSucess,
						onError: onError)
	}
	
	func retrieveWeather(withStoredCoords coords: [CoordModel]) -> [MainModel] {
		let group = DispatchGroup()
		var weathers = [MainModel]()
		
		for coord in coords {
			group.enter()
			retrieveWeather(withDict: ["lat" : coord.lat ?? 0,
									   "lon" : coord.lon ?? 0,
									   "appid" : APP_ID,
									   "units" : UNIT],
							onSucess: { weather in
				weathers.append(weather)
				group.leave()
				
			}, onError: {
				group.leave()
			})
			group.wait()
		}
		return weathers
	}
	
	private func retrieveWeather(withDict dict: NSDictionary, onSucess: @escaping (MainModel) -> Void, onError: @escaping () -> Void) {
		BaseService().callService(URL, withModel: dict, onSucess: { data in
			do {
				let decoder = JSONDecoder()
				let weather = try decoder.decode(MainModel.self, from: data)
				onSucess(weather)
			} catch {
				print("Decode error:", error)
				onError()
				return
			}
		}, onError: {
			onError()
		})
	}
}
