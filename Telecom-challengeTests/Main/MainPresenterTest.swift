//
//  MainPresenterTest.swift
//  Telecom-challengeTests
//
//  Created by Natalia MR on 2/13/23.
//

import Foundation
import Nimble
import Quick
@testable import Telecom_challenge

class TestSpec: QuickSpec {
	
	override func spec() {
		describe("Presenter Test") {
			context("Init Tests") {
				let presenter = MainPresenter()
				it("Parameters to be initialized") {
					expect(presenter.weatherModels).toNot(beNil())
					expect(presenter.weatherModels).to(beEmpty())
					expect(presenter.view).to(beNil())
					expect(presenter.locationManager).to(beNil())
					expect(presenter.imageURL).toNot(beNil())
					expect(presenter.imageURL) == "https://openweathermap.org/img/w/"
				}
				
				it("View to be set") {
					let view = MainViewController()
					presenter.setMainPresenter(withView: view)
					expect(presenter.view).toNot(beNil())
				}
			}
			context("Data usage") {
				let presenter = MainPresenter()
				it("Location to be created used and destroyed") {
					presenter.getLocation()
					expect(presenter.locationManager).toNot(beNil())
					presenter.didGetLocation(lat: 10, lon: 10)
					expect(presenter.locationManager).to(beNil())
				}
				
				it("Treat weather data correctly") {
					let model = self.getMockData()
					presenter.addWeather(model)
					expect(presenter.weatherModels).toNot(beEmpty())
					expect(presenter.getNumberOfRows()) == 1
					expect(presenter.getTemp(atIndex: 0)) == "15"
					expect(presenter.getMaxTemp(atIndex: 0)) == "17"
					expect(presenter.getMinTemp(atIndex: 0)) == "13"
					expect(presenter.getCity(atIndex: 0)) == "Test"
					expect(presenter.getWeatherImgURL(atIndex: 0)).toNot(beNil())
				}
			}
		}
	}
	
	func getMockData() -> MainModel {
		let mainModel = MainModel()
		mainModel.name = "Test"
		mainModel.weather = [WeatherModel()]
		mainModel.weather?[0].icon = "04d"
		mainModel.main = WeatherMainModel()
		mainModel.main?.temp = 15.33
		mainModel.main?.temp_max = 17.21
		mainModel.main?.temp_min = 12.70
		mainModel.coord?.lat = 10.55
		mainModel.coord?.lon = 22.22
		return mainModel
	}
}
