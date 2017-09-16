//
//  ViewController.swift
//  StackScrollView
//
//  Created by muukii on 08/29/2016.
//  Copyright (c) 2016 muukii. All rights reserved.
//

import UIKit

import StackScrollView
import EasyPeasy

class ViewController: UIViewController {
  
  private let stackScrollView = StackScrollView()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    var views: [UIView] = []
    
    let marginColor = UIColor(white: 0.98, alpha: 1)
    
    views.append(MarginStackCell(height: 96, backgroundColor: marginColor))
    
    views.append(HeaderStackCell(title: "LabelStackCell", backgroundColor: marginColor))

    views.append(LabelStackCell(title: "Label"))
    
    views.append(MarginStackCell(height: 40, backgroundColor: marginColor))
    
    views.append(HeaderStackCell(title: "TextFieldStackCell", backgroundColor: marginColor))
    
    views.append(fullSeparator())
    
    views.append({
      let v = TextFieldStackCell()
      v.set(placeholder: "Title")
      return v
    }())
    
    views.append(semiSeparator())
    
    views.append({
      let v = TextFieldStackCell()
      v.set(placeholder: "Detail")
      return v
      }())
    
    views.append(fullSeparator())
    
    views.append(MarginStackCell(height: 40, backgroundColor: marginColor))
    
    views.append(HeaderStackCell(title: "DatePickerStackCell", backgroundColor: marginColor))
    
    views.append(fullSeparator())
    
    views.append({
      let v = DatePickerStackCell()
      v.set(title: "Date")
      return v
    }())
    
    views.append(fullSeparator())

    views.append(MarginStackCell(height: 40, backgroundColor: marginColor))
    
    views.append(HeaderStackCell(title: "TextViewStackCell", backgroundColor: marginColor))
    
    views.append(fullSeparator())

    views.append(TextViewStackCell())

    views.append(fullSeparator())
    
    views.append(MarginStackCell(height: 40, backgroundColor: marginColor))
    
    views.append(HeaderStackCell(title: "SwitchStackCell", backgroundColor: marginColor))
    
    (0..<3).forEach { i in
      
      let s = fullSeparator()
      views.append(s)
      views.append(SwitchStackCell(title: "Switch \(i)"))
    }
    
    views.append(fullSeparator())
    
    views.append(MarginStackCell(height: 40, backgroundColor: marginColor))
    
    views.append(HeaderStackCell(title: "ButtonStackCell", backgroundColor: marginColor))
    
    (0..<3).forEach { _ in
      
      let s = fullSeparator()
      
      views.append(s)
      
      views.append({
        let v = ButtonStackCell(buttonTitle: "Remove")
        v.tapped = { [unowned v] in
          v.remove()
          s.remove()
        }
        return v
        }())
      
    }
    
    views.append(fullSeparator())
    
    views.append(MarginStackCell(height: 40, backgroundColor: marginColor))

    views.append(HeaderStackCell(title: "MarginStackCell", backgroundColor: marginColor))
    
    views.append(MarginStackCell(height: 40, backgroundColor: marginColor))
    
    views.append(HeaderStackCell(title: "SeparatorStackCell", backgroundColor: marginColor))
    
    views.append(fullSeparator())
    
    views.append(MarginStackCell(height: 40, backgroundColor: marginColor))
    
    do {
      // Load from XIB
      
      let cell = NibLoader<NibStackCell>().load()
      
      views.append(fullSeparator())
      views.append(cell)
      views.append(fullSeparator())
      
    }

    views.append(MarginStackCell(height: 40, backgroundColor: marginColor))

    stackScrollView.append(views: views)

    stackScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    stackScrollView.frame = view.bounds
    view.addSubview(stackScrollView)
  }
  
  private func fullSeparator() -> SeparatorStackCell {
    return SeparatorStackCell(leftMargin: 0, rightMargin: 0, backgroundColor: .clear, separatorColor: UIColor(white: 0.90, alpha: 1))
  }
  
  private func semiSeparator() -> SeparatorStackCell {
    return SeparatorStackCell(leftMargin: 8, rightMargin: 8, backgroundColor: .clear, separatorColor: UIColor(white: 0.90, alpha: 1))
  }
}
