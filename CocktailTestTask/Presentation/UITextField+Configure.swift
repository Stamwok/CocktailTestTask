//
//  UIView+ConfiguredProperties.swift
//  CocktailTestTask
//
//  Created by  Егор Шуляк on 30.03.22.
//

import Foundation
import UIKit

extension UITextField {
    func getConfiguredTextFieldForMainScreen() -> UITextField {
        let searchField = UITextField()
        searchField.backgroundColor = .white
        searchField.placeholder = "Cocktail name"
        searchField.textAlignment = .center
        
        searchField.layer.shadowColor = UIColor.black.cgColor
        searchField.layer.shadowOpacity = 0.3
        searchField.layer.shadowRadius = 10
        searchField.layer.shadowOffset = CGSize(width: 0, height: 10)
        searchField.returnKeyType = .done
        searchField.autocorrectionType = .no
        searchField.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        searchField.tintColor = .black
        return searchField
    }
}
