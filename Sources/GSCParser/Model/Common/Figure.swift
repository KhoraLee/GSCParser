//
//  Figure.swift
//  GSCParser
//
//  Created by 이승윤 on 2022/12/02.
//

import Foundation

// MARK: - Base

public protocol Figure: Codable {
    func location() -> String
    func save() throws
}
