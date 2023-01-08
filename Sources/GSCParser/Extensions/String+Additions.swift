//
//  String+Additions.swift
//  Parser
//
//  Created by 이승윤 on 2022/12/02.
//

import Foundation

extension String {
    var containsFullWidthCharacters: Bool {
        unicodeScalars.contains { $0.isFullWidth }
    }


    func replacing(_ regexString: String, with replacement: String) -> String {
        if #available(macOS 13.0, iOS 16.0, *) {
            return self.replacing(try! Regex(regexString), with: replacement)
        } else {
            let regex = try! NSRegularExpression(pattern: regexString)
            return regex.stringByReplacingMatches(in: self, range: NSRange(0..<count), withTemplate: replacement)
        }
    }

    func toInt() -> Int? {
        Int(self)
    }

    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }

        let startIndex = index(startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1)

        return String(self[startIndex ..< endIndex])
    }

    func substring(_ from: Int) -> String {
        guard from < count else {
            return ""
        }

        let startIndex = index(startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: count)
        return String(self[startIndex ..< endIndex])
    }

    func convertToHalfWidthString() -> String {
        String(unicodeScalars.map {
            if !$0.isConverterable { return $0 }
            if $0.value == 0x3000 {
                return UnicodeScalar(0x0020)
            } else {
                return UnicodeScalar($0.value - 0xfee0)!
            }
        }.map(Character.init))
    }
}
