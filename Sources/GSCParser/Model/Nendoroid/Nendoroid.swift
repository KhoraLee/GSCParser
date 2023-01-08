//
//  Nendoroid.swift
//  GSCParser
//
//  Created by 이승윤 on 2022/12/02.
//

// MARK: - Nendoroid

public struct Nendoroid: Figure {

    // MARK: Lifecycle

    public init(
        num: String,
        name: LocalizedString = LocalizedString(),
        series: LocalizedString = LocalizedString(),
        productID: Int = -1,
        price: Int = -1,
        releaseDate: [String] = [],
        image: String = "",
        gender: Gender? = nil,
        set: Int? = nil)
    {
        self.num = num
        self.name = name
        self.series = series
        self.productID = productID
        self.price = price
        self.releaseDate = releaseDate
        self.image = image
        self.gender = gender
        self.set = set
    }

    // MARK: Public

    public let num: String
    public var image: String
    public var releaseDate: [String]
    public var name, series: LocalizedString
    public var productID, price: Int
    public var set: Int?
    public var gender: Gender?

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case num, name, series, price, image, gender, set
        case productID = "gsc_productNum"
        case releaseDate = "release_date"
    }
}

extension Nendoroid: Hashable {
    public static func == (lhs: Nendoroid, rhs: Nendoroid) -> Bool {
        lhs.num == rhs.num && lhs.productID == rhs.productID
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(num)
        hasher.combine(productID)
    }

    public mutating func merge(with new: Nendoroid) {
        if num != new.num { return }
        name.join(new.name)
        series.join(new.series)
        if price == -1 { price = new.price }
        if releaseDate.isEmpty { releaseDate = new.releaseDate }
        if gender == nil { gender = new.gender }
    }
}
