//
//  TextViewStackCell.swift
//  StackScrollView
//
//  Created by muukii on 5/2/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

import EasyPeasy

import StackScrollView

final class TextViewStackCell: StackCellBase, UITextViewDelegate {

  private let textView = UITextView()
  
  override init() {
    super.init()
    
    addSubview(textView)
    textView <- Edges(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    
    self <- Height(>=40)
    
    textView.font = UIFont.preferredFont(forTextStyle: .body)
    textView.isScrollEnabled = false
    textView.delegate = self
  }
  
  func set(value: String) {
    
    textView.text = value
  }
  
  func textViewDidChange(_ textView: UITextView) {
    updateLayout(animated: true)
  }
}
