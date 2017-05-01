//
//  LabelStackCell.swift
//  StackScrollView
//
//  Created by muukii on 5/2/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

import EasyPeasy

import StackScrollView

final class LabelStackCell: StackCellBase {
  
  private let label = UILabel()
  
  override init() {
    super.init()
    
    addSubview(label)
    label <- Edges(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    
    self <- Height(>=40)
    
    label.font = UIFont.preferredFont(forTextStyle: .body)
  }
  
  func set(value: String) {
    label.text = value
  }
}
