//
//  MainContract.swift
//  Telecom-challenge
//
//  Created by Natalia MR on 2/9/23.
//

import Foundation

protocol MainViewContract: NSObject {
	func updateView()
	func showLoading()
	func stopLoading()
	func showErrorMessage()
}

protocol MainPresenterContract {
	func setMainPresenter(withView view: MainViewContract)
	func getNumberOfRows() -> Int
	func getCity(atIndex index: Int) -> String
	func getTemp(atIndex index: Int) -> String
	func getMinTemp(atIndex index: Int) -> String
	func getMaxTemp(atIndex index: Int) -> String
	func getWeatherImgURL(atIndex index: Int) -> URL?
	func fetchWeather(withCityName city: String)
	func deleteWeather(atIndex index: Int)
	func updateWeather()
}
