//
//  UIImage.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/25.
//

import UIKit

extension UIImage {
  func resized(to size: CGSize) -> UIImage {
    return UIGraphicsImageRenderer(size: size).image { _ in
      draw(in: CGRect(origin: .zero, size: size))
    }
  }
}
