//
//  Records.swift
//  RecordAndPlay
//
//  Created by Olga Melnik on 29.01.2020.
//  Copyright © 2020 Olga Melnik. All rights reserved.
//

import Foundation

final class Records: Codable {
    
    static let shared = Records()
    var records: [Record] = []
    private init(){}
    
    func addRecord(_ record: Record) {
        self.records.append(record)
    }
    
    func addRecords(_records: [Records]) {
        records.forEach { (record) in
            self.records.append(record)
        }
    }
    
    func clearRecords() {
        self.records = []
    }
}

struct Record: Codable {
    let date: Date
    let name: URL
}
