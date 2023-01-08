//
//  Figure.swift
//  GSCParser
//
//  Created by 이승윤 on 2022/12/02.
//

import Foundation

// MARK: - Base

protocol Figure: Codable {
    
    var productID: Int { get set }
    var image: String { get set }
    var name: LocalizedString { get set }
    var series: LocalizedString { get set }
    var price: Int { get set }
    var releaseDate: [String] { get set }

    func location() -> String
    func save() throws
}
