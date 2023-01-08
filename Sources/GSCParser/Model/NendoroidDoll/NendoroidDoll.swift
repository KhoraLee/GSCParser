//
//  NendoroidDoll.swift
//  
//
//  Created by 이승윤 on 2023/01/06.
//

import Foundation

public struct NendoroidDoll: Figure {
    
    public var image: String
    public var releaseDate: [String]
    public var name, series: LocalizedString
    public var productID, price: Int
    public var gender: Gender?
    public var type: DollType?

    public init(
        name: LocalizedString = LocalizedString(),
        series: LocalizedString = LocalizedString(),
        productID: Int = -1,
        price: Int = -1,
        releaseDate: [String] = [],
        image: String = "",
        gender: Gender? = nil,
        type: DollType? = nil)
    {
        self.name = name
        self.series = series
        self.productID = productID
        self.price = price
        self.releaseDate = releaseDate
        self.image = image
        self.gender = gender
        self.type = type
    }
}

extension NendoroidDoll: Hashable {
    public static func == (lhs: NendoroidDoll, rhs: NendoroidDoll) -> Bool {
        lhs.productID == rhs.productID
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(productID)
    }

    public mutating func merge(with new: NendoroidDoll) {
        if productID != new.productID { return }
        name.join(new.name)
        series.join(new.series)
        if image == "" { image = new.image }
        if price == -1 { price = new.price }
        if releaseDate.isEmpty { releaseDate = new.releaseDate }
        if gender == nil { gender = new.gender }
        if type == nil { type = new.type }
    }
}
