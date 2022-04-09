//
//  RemoteCocktailListProtocol.swift
//  CocktailTestTask
//
//  Created by  Егор Шуляк on 8.04.22.
//

import Foundation

protocol RemoteCocktailsListProtocol {
    func getCocktailsList(completionHandler: @escaping ([Cocktail]) -> Void)
}
