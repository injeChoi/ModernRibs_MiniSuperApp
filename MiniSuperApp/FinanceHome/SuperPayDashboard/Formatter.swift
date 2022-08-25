//
//  NumberFormatter.swift
//  MiniSuperApp
//
//  Created by 60157124 on 2022/08/25.
//

import Foundation

struct Formatter {
  static let balanceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }()
}
