//
//  UIImage+URL.swift
//  Telecom-challenge
//
//  Created by Natalia MR on 2/13/23.
//

import Foundation
import UIKit

extension UIImage {
	convenience init?(withUrl url: URL?) {
		guard let url = url else { return nil }
		
		do {
			self.init(data: try Data(contentsOf: url))
		} catch {
			print("Fail at loading: \(url) with error: \(error)")
			return nil
		}
	}
}
