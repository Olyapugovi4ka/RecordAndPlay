//
//  RecordsCaretaker.swift
//  RecordAndPlay
//
//  Created by Olga Melnik on 29.01.2020.
//  Copyright © 2020 Olga Melnik. All rights reserved.
//

import Foundation

class RecordsCaretaker {
    private var decoder = JSONDecoder()
    private var encoder = JSONEncoder()
    private let key = "RecordAndPlay"
    
    func save (_ records: [Record]) {
        let data = try! encoder.encode(records)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func load() -> [Record] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return try! decoder.decode([Record].self, from: data)
    }
}
