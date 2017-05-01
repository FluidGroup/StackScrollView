//
//  TextFieldStackCell.swift
//  StackScrollView
//
//  Created by muukii on 5/2/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

import EasyPeasy

import StackScrollView

final class TextFieldStackCell: StackCellBase {
  
  private let textField = UITextField()
  
  override init() {
    super.init()
    
    textField.font = UIFont.preferredFont(forTextStyle: .body)
    
    addSubview(textField)
    textField <- Edges(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    
    self <- Height(>=40)
  }
  
  func set(value: String) {
    textField.text = value
  }
  
  func set(placeholder: String) {
    textField.placeholder = placeholder
  }
}
