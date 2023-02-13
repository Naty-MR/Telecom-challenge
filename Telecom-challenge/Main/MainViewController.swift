//
//  MainViewController.swift
//  Telecom-challenge
//
//  Created by Natalia MR on 2/9/23.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
	var presenter: MainPresenterContract?
	var loadingAlert: UIAlertController?
    
	// MARK: - View Life Cyrcle
    override func viewDidLoad() {
        super.viewDidLoad()
		setPresenter()
		tableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: WeatherCell.CELL_IDENTIFIER)
		tableView.register(UINib(nibName: "AddWeatherCell", bundle: nil), forCellReuseIdentifier: AddWeatherCell.CELL_IDENTIFIER)
    }
	
	func setPresenter() {
		self.presenter = MainPresenter()
		self.presenter?.setMainPresenter(withView: self)
	}
	
	//MARK: - Add Cities
	
	func showAddCityPrompt() {
		let alert = UIAlertController(title: nil, message: "Enter a City", preferredStyle: .alert)
		alert.addTextField { (textField) in
			textField.placeholder = "City..."
		}

		alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
			if let alert = alert, let textField = alert.textFields?[0], let city = textField.text, city != "" {
				self.presenter?.fetchWeather(withCityName: city)
				alert.dismiss(animated: true)
			}
		}))
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
			alert?.dismiss(animated: true)
		}))
		self.present(alert, animated: true, completion: nil)
	}
}

//MARK: - MainContract Implementation
extension MainViewController: MainViewContract {
	func updateView() {
		self.tableView.reloadData()
	}
	
	func showLoading() {
		if loadingAlert == nil {
			loadingAlert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
			loadingAlert?.view.tintColor = UIColor.darkGray
			let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10,y: 5,width: 50, height: 50))
			loadingIndicator.hidesWhenStopped = true
			loadingIndicator.style = .medium
			loadingIndicator.startAnimating()
			loadingAlert?.view.addSubview(loadingIndicator)
		}
		if let loadingAlert = self.loadingAlert {
			self.present(loadingAlert, animated: true)
		}
	}
	
	func stopLoading() {
		loadingAlert?.dismiss(animated: true)
	}
	
	func showErrorMessage() {
		let alert = UIAlertController(title: "An error has ocurred", message: "Please try again later...", preferredStyle: .alert)

		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
			alert?.dismiss(animated: true)
		}))
		self.present(alert, animated: true, completion: nil)
	}
	
	@objc func actionButtonPressed(sender: UIButton) {
		let index = sender.tag
		if index == 0 {
			presenter?.updateWeather()
		} else {
			presenter?.deleteWeather(atIndex: index)
		}
	}
}

// MARK: - UITableView Delegates
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let numberOfRows = presenter?.getNumberOfRows() ?? 0
		return numberOfRows < 6 ? numberOfRows+1 : numberOfRows
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row >= presenter?.getNumberOfRows() ?? 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: AddWeatherCell.CELL_IDENTIFIER, for: indexPath)
			cell.backgroundColor = .darkGray
			return cell
			
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.CELL_IDENTIFIER, for: indexPath)
			if let cell = cell as? WeatherCell, let presenter = self.presenter {
				cell.configureCell(withImgURL: presenter.getWeatherImgURL(atIndex: indexPath.row),
								   cityName: presenter.getCity(atIndex: indexPath.row),
								   temp: presenter.getTemp(atIndex: indexPath.row),
								   minTemp: presenter.getMinTemp(atIndex: indexPath.row),
								   maxTemp: presenter.getMaxTemp(atIndex: indexPath.row))
				let actionButtonImageName = indexPath.row == 0 ? "arrow.clockwise" : "trash"
				if let actionButtonImage = UIImage(systemName: actionButtonImageName) {
					cell.setActionButton(withImage: actionButtonImage)
				}
				cell.actionButton.addTarget(self, action: #selector(actionButtonPressed(sender:)), for: .touchUpInside)
				cell.actionButton.tag = indexPath.row
				
				cell.backgroundColor = .darkGray
				cell.contentView.isUserInteractionEnabled = true
			}
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row >= presenter?.getNumberOfRows() ?? 0 {
			showAddCityPrompt()
		}

		tableView.deselectRow(at: indexPath, animated: true)
	}
}
