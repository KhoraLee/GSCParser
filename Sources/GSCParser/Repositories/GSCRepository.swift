//
//  GSCRepository.swift
//  GSCParser
//
//  Created by 이승윤 on 2022/12/10.
//

import Alamofire
import Foundation
import SwiftSoup

let GSC = GSCRepository.shared

open class GSCRepository {

    public static let shared = GSCRepository()
    
    public enum ListParseOption {
        case announce, range, release
    }

    let convertionDict = [
        "商品名" : "name",
        "Product Name" : "name",
        "作品名" : "series",
        "Series" : "series",
        "価格" : "price",
        "Price" : "price",
        "再販" : "release_info",
        "発売時期" : "release",
        "Release Date" : "release",
    ]

    func getProductInfo(locale: LanguageCode, productID: Int) async throws -> String {
        let request = Requester.request(GSCRouter.productInfo(locale: locale, productID: productID)).serializingString()
        return try await request.value
    }

}
