//
//  MarginStackCell.swift
//  StackScrollView
//
//  Created by muukii on 5/2/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

import StackScrollView

final class MarginStackCell: StackCellBase {
  
  let height: CGFloat
  
  init(height: CGFloat, backgroundColor: UIColor) {
    self.height = height
    super.init()
    self.backgroundColor = backgroundColor
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIView.noIntrinsicMetric, height: height)
  }
}
