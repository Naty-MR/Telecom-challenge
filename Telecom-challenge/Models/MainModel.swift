//
//  WeatherModel.swift
//  Telecom-challenge
//
//  Created by Natalia MR on 2/9/23.
//

import Foundation
class MainModel: Decodable {
	var weather: [WeatherModel]?
	var main: WeatherMainModel?
	var coord: CoordModel?
	var name: String?
}

class WeatherModel: Decodable {
	var icon: String?
}

class WeatherMainModel: Decodable {
	var temp: Double?
	var temp_min: Double?
	var temp_max: Double?
}

class CoordModel: Codable {
	var lon: Double?
	var lat: Double?
}
