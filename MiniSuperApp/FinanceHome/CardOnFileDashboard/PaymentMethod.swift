//
//  PaymentMethod.swift
//  MiniSuperApp
//
//  Created by 60157124 on 2022/08/25.
//

import Foundation

// 백엔드에서 받는 모델이라고 가정
struct PaymentMethod: Decodable {
  let id: String
  let name: String
  let digits: String
  let color: String
  let isPrimary: Bool
}
