//
//  File.swift
//  
//
//  Created by 이승윤 on 2023/01/06.
//

import Foundation

public class NendoroidDollDAO: BaseDAO {

    // MARK: Lifecycle

    private init() { } // Block creating new instance

    // MARK: Public

    public static let shared = NendoroidDollDAO()

    public static func setup(path: URL) {
        if staticPath != nil {
            fatalError("NendoroidDollDAO is already setuped.")
        }
        staticPath = path

        // Check sub directory exist and if not create
        for type in DollType.allCases {
            let folder = staticPath!.appendingPathComponent("\(type)")
            createFolderWhenNotExist(folder: folder)
        }
    }

    public func loadNendoroidDoll(type: DollType, productNum: Int) throws -> NendoroidDoll {
        let url = path
            .appendingPathComponent("\(type)")
            .appendingPathComponent("\(productNum)")
            .appendingPathExtension("json")
        return try loadFile(at: url)
    }

    private(set) static var staticPath: URL?

}
