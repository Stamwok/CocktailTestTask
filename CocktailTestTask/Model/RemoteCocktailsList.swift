//
//  RemoteCocktailsList.swift
//  CocktailTestTask
//
//  Created by  Егор Шуляк on 29.03.22.
//

import Foundation
import Alamofire

final class RemoteCocktailsList: RemoteCocktailsListProtocol {
    private let url = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Non_Alcoholic"
    private let contentType: String = "application/json"
    
    struct Response: Decodable {
        let drinks: [Result<Cocktail, DecodingError>]
    }
    
    func getCocktailsList(completionHandler: @escaping ([Cocktail]) -> Void) {
        let header: HTTPHeaders = ["Content-Type": contentType]
        AF.request(
            url,
            method: .get,
            headers: header
        ).responseDecodable(of: Response.self) { response in
            switch response.result {
            case .success(let value):
                let resultList = value.drinks.compactMap { $0.value }
                completionHandler(resultList)
            case.failure(let error):
                print(error)
                completionHandler([])
            }
        }
    }
}
