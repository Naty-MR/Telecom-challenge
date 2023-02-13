//
//  BaseSerive.swift
//  Telecom-challenge
//
//  Created by Natalia MR on 2/10/23.
//

import Foundation

class BaseService {
	
	func callService(_ urlString: String, withModel model: NSDictionary, onSucess: @escaping (Data) -> Void, onError: @escaping () -> Void) {
		var urlString = urlString
		var concat = "?"
		for (key, value) in model {
			urlString += concat + "\(key)=\(value)"
			concat = "&"
		}
		if let url = URL(string: urlString) {
			var request = URLRequest(url: url)
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			URLSession.shared.dataTask(with: url) { data, response, error in
				if let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
					onSucess(data)
				} else {
					print(error ?? "Unknow Error check status code")
					onError()
				}
			}.resume()
		}
	}
}
