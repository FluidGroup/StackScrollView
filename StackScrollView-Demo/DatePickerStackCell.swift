//
//  DatePickerStackCell.swift
//  StackScrollView
//
//  Created by muukii on 5/2/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

import EasyPeasy

import StackScrollView

final class DatePickerStackCell: TapStackCell {
  
  let pickerView = UIDatePicker()
  let titleLabel = UILabel()
  let valueLabel = UILabel()
  var editing: Bool = false
  
  private let borderView = UIView()
  private let pickerContainerView = UIView()
  private let bodyContainerView = UIView()
  
  override init() {
    
    super.init()
    
    backgroundColor = UIColor.white
    
    pickerContainerView.clipsToBounds = true
    
    pickerView.setContentHuggingPriority(100, for: .horizontal)
    
    pickerContainerView.addSubview(pickerView)
    
    addSubview(bodyContainerView)
    addSubview(borderView)
    addSubview(pickerContainerView)
    
    pickerView <- [
      Top().with(.medium),
      Right(),
      Left(),
      Bottom().with(.medium),
      CenterY(),
    ]
    
    bodyContainerView.addSubview(titleLabel)
    bodyContainerView.addSubview(valueLabel)
    
    titleLabel <- [
      Top(>=12),
      Bottom(<=12),
      Left(16),
      CenterY(),
    ]
    
    valueLabel <- [
      Top(>=12),
      Bottom(<=12),
      Left(>=24).to(titleLabel, .right),
      CenterY(),
      Right(16),
    ]
    
    bodyContainerView <- [
      Top(),
      Right(),
      Left(),
      Bottom().to(borderView, .top),
    ]
    
    borderView <- [
      Left(16),
      Right(16),
      Height(1 / UIScreen.main.scale),
      Bottom().to(pickerContainerView, .top),
    ]
    
    pickerContainerView <- [
      Right(),
      Left(),
      Bottom(),
      Height(0),
    ]
    
    bodyContainerView.isUserInteractionEnabled = false
    
    valueLabel.textAlignment = .right
    valueLabel.numberOfLines = 0
    
    borderView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    borderView.alpha = 0
  }

  override func tap() {
    
    if editing {
      _close()
    } else {
      _open()
    }
    
  }
  
  func _close() {
    
    guard editing == true else { return }
    
    editing = false
    
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 1,
      initialSpringVelocity: 0,
      options: [
        .beginFromCurrentState,
        .allowUserInteraction
      ],
      animations: {
        
        self.pickerContainerView <- [
          Height(0),
        ]
        self.borderView.alpha = 0
        self.pickerView.alpha = 0
        
        self.pickerContainerView.invalidateIntrinsicContentSize()
        self.pickerContainerView.layoutIfNeeded()
        self.updateLayout(animated: true)
        self.scrollToSelf(animated: true)
        
    }) { (finish) in
      
    }
    
  }
  
  func _open() {
    
    guard editing == false else { return }
    
    editing = true
    
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 1,
      initialSpringVelocity: 0,
      options: [
        .beginFromCurrentState,
        .allowUserInteraction
      ],
      animations: {
        
        NSLayoutConstraint.deactivate(
          self.pickerContainerView <- [
            Height(),
          ]
        )
        self.borderView.alpha = 1
        self.pickerView.alpha = 1
        
        self.pickerContainerView.invalidateIntrinsicContentSize()
        self.pickerContainerView.layoutIfNeeded()
        self.updateLayout(animated: true)
        self.scrollToSelf(animated: true)
        
    }) { (finish) in
      
    }
    
  }
  
  func set(title: String) {
    titleLabel.text = title
  }
} 
