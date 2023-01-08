//
//  LocalizedString.swift
//  GSCParser
//
//  Created by 이승윤 on 2022/12/02.
//

public struct LocalizedString: Codable {
    
    private var en: String?
    private var ja: String?
    private var ko: String?

    public init() { }

    public init(locale: LanguageCode, string: String) {
        switch locale {
        case .ko:
            ko = string
        case .ja:
            ja = string
        case .en:
            en = string
        }
    }
    
    public init(_ strings: [LanguageCode: String]) {
        for (langCode, string) in strings {
            insert(string, to: langCode)
        }
    }
    
    mutating func insert(_ string: String, to: LanguageCode) {
        switch to {
        case .en:
            en = string
        case .ja:
            ja = string
        case .ko:
            ko = string
        }
    }
    
    mutating func join(_ new: LocalizedString, overwrite: [LanguageCode] = []) {
        if overwrite.contains(.en) || (en == nil && new.en != nil) {
            en = new.en
        }
        if overwrite.contains(.ja) || (ja == nil && new.ja != nil) {
            ja = new.ja
        }
        if overwrite.contains(.ko) || (ko == nil && new.ko != nil) {
            ko = new.ko
        }
    }

    mutating func join(_ new: LocalizedString, overwrite: LanguageCode) {
        join(new, overwrite: [overwrite])
    }

    func localizedString(locale: LanguageCode) -> String? {
        switch locale {
        case .en:
            return en
        case .ja:
            return ja
        case .ko:
            return ko
        }
    }
}
