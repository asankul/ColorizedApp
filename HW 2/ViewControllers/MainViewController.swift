//
//  MainViewController.swift
//  HW 2
//
//  Created by Асанкул Садыков on 12/7/22.
//  Copyright © 2022 Alexey Efimov. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func setNewColor(for colorBG: UIColor)
}

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else { return }
        settingsVC.mainColorBG = view.backgroundColor
        settingsVC.delegate = self
    }
}

// MARK: - SettingsViewControllerDelegate
extension MainViewController: SettingsViewControllerDelegate {
    func setNewColor(for colorBG: UIColor) {
        view.backgroundColor = colorBG
    }
}

