//
//  GSCRouter.swift
//  Parser
//
//  Created by 이승윤 on 2022/12/09.
//

import Alamofire
import Foundation

public enum GSCRouter: URLRequestConvertible {

    case byYear(locale: LanguageCode, type: SortType, year: Int)
    case byRange(locale: LanguageCode, range: String)
    case productInfo(locale: LanguageCode, productID: Int)
    case smartStore(item: SmartStoreItemType, page: Int)

    // MARK: Public

    public enum SortType: String {
        case announce = "announced"
        case release = "released"
    }

    public enum SmartStoreItemType: String {
        case nendoroid = "fc068adc735c4a4093dd9318b50c053b"
        case nendoroidDoll = "f999ec7a41d641e3a7c3f3f21c430c6b"
        case nendoroidDollClothes = "a1a190b4f513402bbf436800135044fb"
    }

    public func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        request.timeoutInterval = 10
        return request
    }

    // MARK: Internal

    var baseURL: URL {
        switch self {
        case .smartStore:
            return URL(string: "https://brand.naver.com/goodsmilekr/category/")!
        default:
            return URL(string: "https://www.goodsmile.info/")!
        }
    }

    var method: HTTPMethod {
        .get
    }

    var path: String {
        switch self {
        case .byYear(let locale, let type, let year):
            return "\(locale)/products/category/nendoroid_series/\(type.rawValue)/\(year)"
        case .byRange(let locale, let range):
            return "\(locale)/nendoroid\(range)"
        case .productInfo(let locale, let productId):
            return "\(locale)/product/\(productId)"
        case .smartStore(let item, _):
            return item.rawValue
        }
    }

    var parameters: [String: String] {
        switch self {
        case .smartStore(_, let page):
            return [
                "st" : "RECENT",
                "page" : "\(page)",
                "size" : "80",
            ]
        default:
            return [:]
        }
    }
}
