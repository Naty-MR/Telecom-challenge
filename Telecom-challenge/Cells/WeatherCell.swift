//
//  WeatherCell.swift
//  Telecom-challenge
//
//  Created by Natalia MR on 2/12/23.
//

import Foundation
import UIKit

class WeatherCell: UITableViewCell {
	@IBOutlet weak var weatherImageView: UIImageView!
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var tempLabel: UILabel!
	@IBOutlet weak var minMaxTempLabel: UILabel!
	@IBOutlet weak var actionButton: UIButton!
	
	static let CELL_IDENTIFIER = "WeatherCellIdentifier"
	
	func configureCell(withImgURL imgURL: URL?, cityName: String, temp: String, minTemp: String, maxTemp: String) {
		if let imgURL = imgURL {
			let image = UIImage(withUrl: imgURL)
			self.weatherImageView.image = image
		}
		self.cityLabel.text = cityName
		self.tempLabel.text = temp + "°C"
		self.minMaxTempLabel.text = minTemp + "°C/" + maxTemp + "°C"
	}
	
	func setActionButton(withImage image: UIImage) {
		actionButton.setImage(image, for: .normal)
	}
}
