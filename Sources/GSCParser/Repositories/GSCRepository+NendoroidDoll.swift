//
//  GSCRepository+NendoroidDoll.swift
//  
//
//  Created by 이승윤 on 2023/01/06.
//

import Alamofire
import Foundation
import SwiftSoup

public extension GSCRepository {
    
    func getNendoroidDollInfo(doll: NendoroidDoll) async -> NendoroidDoll {
        var result = doll
        let dollJA = await getNendoroidDollInfo(locale: .ja, productID: doll.productID)
        let dollEN = await getNendoroidDollInfo(locale: .en, productID: doll.productID)
        if dollJA != nil { result.merge(with: dollJA!) }
        if dollEN != nil { result.merge(with: dollEN!) }
        return result
    }
    
    func parseNendoroidDollList(option: [ListParseOption] = [.announce, .release]) async -> Set<NendoroidDoll> {
        await withTaskGroup(of: Set<NendoroidDoll>.self) { group in
            var list = Set<NendoroidDoll>()
            if option.contains(.announce) {
                group.addTask { await self.getNendoroidDollListbyYear(locale: .ja, by: .announce) }
                group.addTask { await self.getNendoroidDollListbyYear(locale: .en, by: .announce) }
            }
            if option.contains(.release) {
                group.addTask { await self.getNendoroidDollListbyYear(locale: .ja, by: .release) }
                group.addTask { await self.getNendoroidDollListbyYear(locale: .en, by: .release) }
            }
            for await sets in group {
                list.formUnion(sets)
            }
            return list
        }
    }
    
    func parseNendoroidDollList(option: ListParseOption) async -> Set<NendoroidDoll> {
        await parseNendoroidDollList(option: [option])
    }

    private func getNendoroidDollListbyYear(locale: LanguageCode, by type: NendoroidRouter.SortType) async -> Set<NendoroidDoll> {
        await withTaskGroup(of: Set<NendoroidDoll>.self) { group in
            var nendoroids = Set<NendoroidDoll>()
            for year in 2005...2024 {
                group.addTask {
                    var list = Set<NendoroidDoll>()
                    do {
                        let request = Requester.request(NendoroidRouter.byYear(locale: locale, type: type, year: year)).serializingString()
                        let doc = try SwiftSoup.parse(await request.value)
                        let elements = try doc
                            .select("[class=\"hitItem nendoroidDoll nendoroid_series\"]")
                            .select("div > a")
                        for e in elements {
                            guard let gscCode = try String(e.attr("href").replacingOccurrences(of: "https://www.goodsmile.info/\(locale)/product", with: "").split(separator: "/").first!).toInt() else { continue }
                            let imageLink = try "https:" + e.select("img").attr("data-original")
                            list.insert(NendoroidDoll(productID: gscCode, image: imageLink))
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                    return list
                }
            }
            for await list in group {
                nendoroids.formUnion(list)
            }
            return nendoroids
        }
    }
    
    private func getNendoroidDollInfo(locale: LanguageCode, productID: Int) async -> NendoroidDoll? {
        do {
            let html = try await getProductInfo(locale: locale, productID: productID)
            let document = try SwiftSoup.parse(html)
            let elements = try document.select("div.itemDetail").select("div.detailBox>dl")
            let keyElements = try elements.select("dt").map { try $0.text() }
            let valueElements = try elements.select("dd").map { try $0.text() }
            if keyElements.count == 0 { return nil }
            if keyElements.count != valueElements.count { throw GSCError.keyValueSizeMismatch }

            var info = [String: String]()
            for i in 0...(keyElements.count - 1) {
                let key = keyElements[i]
                if !convertionDict.keys.contains(key) || info.keys.contains(convertionDict[key]!) { continue }
                info[convertionDict[key]!] = valueElements[i]
            }

            var releaseDates: Set<String>
            if info.keys.contains("release_info") {
                releaseDates = Set(ParserHelper.parseReleaseDate(dateString: info["release_info"]!))
            } else {
                releaseDates = Set(ParserHelper.parseReleaseDate(dateString: info["release"]!))
            }
            
            return NendoroidDoll(
                name: LocalizedString(locale: locale, string: info["name"]!),
                series: LocalizedString(locale: locale, string: info["series"]!),
                productID: productID,
                price: info["price"]?.replacing("\\D", with: "").toInt() ?? 0,
                releaseDate: Array(releaseDates).sorted())
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }


}
