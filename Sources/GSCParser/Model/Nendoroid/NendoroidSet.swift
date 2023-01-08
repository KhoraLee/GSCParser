//
//  NendoroidSet.swift
//  GSCParser
//
//  Created by 이승윤 on 2022/12/02.
//

// MARK: - NendoroidSet

public struct NendoroidSet: Codable {
    public let num: String
    public var setName: String
    public var list: [String]

    public init(num: String, setName: String, list: [String]) {
        self.num = num
        self.setName = setName
        self.list = list
    }
}
