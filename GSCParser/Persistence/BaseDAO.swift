//
//  BaseDAO.swift
//  GSCParser
//
//  Created by 이승윤 on 2022/12/26.
//

import Foundation

// MARK: - BaseDAO

protocol BaseDAO {
  var path: URL { get }

  static var staticPath: URL? { get }

  static func setup(path: URL)
}

extension BaseDAO {
  var fm: FileManager { FileManager.default }

  var path: URL {
    if Self.staticPath == nil {
      fatalError("DAO is used before setup")
    }
    return Self.staticPath!
  }

  func saveFile(data: some Encodable, to path: String) throws {
    let url = self.path.appending(path: path)
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes, .sortedKeys]
    try encoder.encode(data).write(to: url)
  }

  func loadFile<T>(at url: URL) throws -> T where T: Decodable {
    try JSONDecoder().decode(T.self, from: Data(contentsOf: url))
  }

}
