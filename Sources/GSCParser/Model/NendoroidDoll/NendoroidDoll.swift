//
//  NendoroidDoll.swift
//  
//
//  Created by 이승윤 on 2023/01/06.
//

import Foundation

public struct NendoroidDoll: Figure, Hashable {
    
    // MARK: Lifecycle

    public init(
        name: LocalizedString = LocalizedString(),
        series: LocalizedString = LocalizedString(),
        gscProductNum: Int = -1,
        price: Int = -1,
        releaseDate: [String] = [],
        image: String = "",
        gender: Gender? = nil,
        type: DollType? = nil)
    {
        self.name = name
        self.series = series
        self.gscProductNum = gscProductNum
        self.price = price
        self.releaseDate = releaseDate
        self.image = image
        self.gender = gender
        self.type = type
    }

    // MARK: Public

    public var image: String
    public var releaseDate: [String]
    public var name, series: LocalizedString
    public var gscProductNum, price: Int
    public var gender: Gender?
    public var type: DollType?

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case name, series, price, image, gender, type
        case gscProductNum = "gsc_productNum"
        case releaseDate = "release_date"
    }
}

extension NendoroidDoll {
    public static func == (lhs: NendoroidDoll, rhs: NendoroidDoll) -> Bool {
        lhs.gscProductNum == rhs.gscProductNum
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(gscProductNum)
    }

    public func location() -> String {
        "\(type ?? .unknown)/\(gscProductNum).json"
    }

    public func save() throws {
        try NendoroidDollDAO.shared.saveFile(data: self, to: location())
    }

    public mutating func merge(with new: NendoroidDoll) {
        if gscProductNum != new.gscProductNum { return }
        name.join(new.name)
        series.join(new.series)
        if image == "" { image = new.image }
        if price == -1 { price = new.price }
        if releaseDate.isEmpty { releaseDate = new.releaseDate }
        if gender == nil { gender = new.gender }
        if type == nil { type = new.type }
    }
}
