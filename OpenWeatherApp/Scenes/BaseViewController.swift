//
//  BaseViewController.swift
//  OpenWeatherApp
//
//  Created by Hugo Hernando Bernal Palacio on 5/12/20.
//

import UIKit

class BaseViewController: SceneViewController {
    func showAlert(with message: String) {
        let alertView = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { action in
            alertView.dismiss(animated: true, completion: nil)
        }

        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
    }
}
