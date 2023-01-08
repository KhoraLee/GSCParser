//
//  DollType.swift
//  
//
//  Created by 이승윤 on 2023/01/06.
///Users/seung-yun/Project/doll.csv

import Foundation

public enum DollType: String, Codable, CaseIterable {
    case body, clothes, customizing, doll, unknown
}
