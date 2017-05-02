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
  
  init(title: String) {
    super.init()
    
    addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 8).isActive = true
    label.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: 8).isActive = true
    label.rightAnchor.constraint(equalTo: rightAnchor, constant: 8).isActive = true
    label.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
    label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
    
    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.text = title
  }
}
