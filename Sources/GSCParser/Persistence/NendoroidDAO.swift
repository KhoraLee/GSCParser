//
//  NendoroidDAO.swift
//  Parser
//
//  Created by 이승윤 on 2022/12/02.
//

import Foundation

public class NendoroidDAO: BaseDAO {

    // MARK: Lifecycle

    private init() { } // Block creating new instance

    // MARK: Public

    public static let shared = NendoroidDAO()

    public static func setup(path: URL) {
        if staticPath != nil {
            fatalError("NendoroidDAO is already setuped.")
        }
        staticPath = path

        // Check sub directory exist and if not create
        for range in 0...20 {
            let folderName = String(format: "%04d-%04d", range * 100, (range + 1) * 100 - 1)
            let folder = staticPath!.appendingPathComponent(folderName)
            createFolderWhenNotExist(folder: folder)
        }
        createFolderWhenNotExist(folder: staticPath!.appendingPathComponent("Set"))
    }

    public func loadNendoroid(number num: String) throws -> Nendoroid {
        let range = num.components(separatedBy: .decimalDigits.inverted).joined().toInt()! / 100
        let folderName = String(format: "%04d-%04d", range * 100, (range + 1) * 100 - 1)
        let url = path
            .appendingPathComponent(folderName)
            .appendingPathComponent(num)
            .appendingPathExtension("json")
        return try loadFile(at: url)
    }

    public func loadNendoroidSet(number num: Int) throws -> NendoroidSet {
        let url = path.appendingPathComponent("Set")
            .appendingPathComponent(String(format: "Set%03d", num))
            .appendingPathExtension("json")
        return try loadFile(at: url)
    }

    // MARK: Internal

    private(set) static var staticPath: URL?

}
