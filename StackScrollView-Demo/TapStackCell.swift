//
//  TapStackCell.swift
//  StackScrollView
//
//  Created by muukii on 5/2/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

class TapStackCell: StackCellBase {
  
  var highlightedBackgroundColor: UIColor = .init(white: 0.95, alpha: 1)
  var normalBackgroundColor: UIColor = .white
  
  override init() {
    super.init()
    
    backgroundColor = .white
    addTarget(self, action: #selector(tap), for: .touchUpInside)
  }
  
  @objc func tap() {
    
  }
  
  override var isHighlighted: Bool {
    didSet {
      
      guard oldValue != isHighlighted else { return }
      
      UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
        
        if self.isHighlighted {
          
          self.backgroundColor = self.highlightedBackgroundColor
        } else {
          
          self.backgroundColor = self.normalBackgroundColor
        }
      }, completion: nil)
    }
  }
}
