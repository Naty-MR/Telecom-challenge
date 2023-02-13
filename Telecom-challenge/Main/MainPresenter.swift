//
//  MainPresenter.swift
//  Telecom-challenge
//
//  Created by Natalia MR on 2/9/23.
//

import Foundation

class MainPresenter {
	weak var view: MainViewContract?
	var weatherModels = [MainModel]()
	var locationManager: LocationManager?
	let imageURL = "https://openweathermap.org/img/w/"
	
	func getLocation() {
		self.locationManager = LocationManager(self)
	}
	
	func getCoords() -> [CoordModel] {
		var coords = [CoordModel]()
		for weather in weatherModels {
			if let coord = weather.coord {
				coords.append(coord)
			}
		}
		return coords
	}
	
	func fetchModel(byCityName city: String) {
		let city = city.replacingOccurrences(of: " ", with: "+")
		WeatherService().retrieveWeather(withCityName: city, onSucess: { weather in
			self.addWeather(weather)
		}, onError: {
			self.onErrorRetrieveData()
		})
	}
	
	func onErrorRetrieveData() {
		DispatchQueue.main.async {
			self.view?.stopLoading()
			self.view?.showErrorMessage()
		}
	}
	
	func addWeather(_ weather: MainModel) {
		self.weatherModels.append(weather)
		let dataManager = LocalDataManager()
		dataManager.store(coords: getCoords())
		DispatchQueue.main.async {
			self.view?.stopLoading()
			self.view?.updateView()
		}
	}
	
	func getWeathers(withStoredCoords coords: [CoordModel]) {
		DispatchQueue.main.async {
			self.view?.showLoading()
		}
		self.weatherModels = WeatherService().retrieveWeather(withStoredCoords: coords)
		DispatchQueue.main.async {
			self.view?.stopLoading()
			self.view?.updateView()
		}
	}
}

//MARK: - MainContract Implementation
extension MainPresenter: MainPresenterContract {
	func deleteWeather(atIndex index: Int) {
		DispatchQueue.main.async {
			self.view?.showLoading()
		}
		weatherModels.remove(at: index)
		let dataManager = LocalDataManager()
		dataManager.store(coords: getCoords())
		DispatchQueue.main.async {
			self.view?.stopLoading()
			self.view?.updateView()
		}
	}
	
	func updateWeather() {
		getLocation()
	}
	
	
	func getNumberOfRows() -> Int {
		return self.weatherModels.count
	}
	
	func setMainPresenter(withView view: MainViewContract) {
		self.view = view
		let dataManager = LocalDataManager()
		let coords = dataManager.retrieveCoords()
		if let coords = coords, !coords.isEmpty {
			getWeathers(withStoredCoords: coords)
		} else {
			getLocation()
		}
	}
	
	func getCity(atIndex index: Int) -> String {
		return weatherModels[index].name ?? ""
	}
	
	func getTemp(atIndex index: Int) -> String {
		return String(format: "%.0f", (weatherModels[index].main?.temp ?? 0 ))
	}
	
	func getMinTemp(atIndex index: Int) -> String {
		return String(format: "%.0f", (weatherModels[index].main?.temp_min ?? 0 ))
	}
	
	func getMaxTemp(atIndex index: Int) -> String {
		return String(format: "%.0f", (weatherModels[index].main?.temp_max ?? 0 ))
	}
	
	func getWeatherImgURL(atIndex index: Int) -> URL? {
		let imageId = weatherModels[index].weather?[0].icon ?? ""
		return URL(string: imageURL + imageId + ".png")
	}
	
	func fetchWeather(withCityName city: String) {
		DispatchQueue.main.async {
			self.view?.showLoading()
		}
		self.fetchModel(byCityName: city)
	}
}

//MARK: - Location Delegate
extension MainPresenter: LocationDelegate {
	func didGetLocation(lat: Double, lon: Double) {
		DispatchQueue.main.async {
			self.view?.showLoading()
		}
		locationManager = nil
		WeatherService().retrieveWeather(withLat: String(lat), andLong: String(lon), onSucess: { weather in
			if self.weatherModels.isEmpty {
				self.addWeather(weather)
			} else {
				self.weatherModels[0] = weather
			}
			DispatchQueue.main.async {
				self.view?.stopLoading()
				self.view?.updateView()
			}
		}, onError: {
			self.onErrorRetrieveData()
		})
	}
}
