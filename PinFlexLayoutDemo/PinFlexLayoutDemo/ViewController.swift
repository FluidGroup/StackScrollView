//
//  ViewController.swift
//  PinFlexLayoutDemo
//
//  Created by muukii on 11/13/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

import StackScrollView
import PinLayout
import FlexLayout

class ViewController: UIViewController {

  private let stackScrollView = StackScrollView()

  override func viewDidLoad() {
    super.viewDidLoad()

    var views: [UIView] = []

    let marginColor = UIColor(white: 0.98, alpha: 1)

    views.append(MarginStackCell(height: 96, backgroundColor: marginColor))
    views.append(FlexLabelStackCell(title: "Hello"))
    views.append(PinLabelStackCell(title: "Fooo"))
    views.append(DatePickerCell.init())
    views.append(DatePickerCell.init())


    stackScrollView.append(views: views)

    stackScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    stackScrollView.frame = view.bounds
    view.addSubview(stackScrollView)
  }
}

class StackCellBase: UIControl, StackCellType {

  init() {
    super.init(frame: .zero)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

final class MarginStackCell: StackCellBase {

  let height: CGFloat

  init(height: CGFloat, backgroundColor: UIColor) {
    self.height = height
    super.init()
    self.backgroundColor = backgroundColor
  }

  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIViewNoIntrinsicMetric, height: height)
  }
}

// WIP:
final class PinLabelStackCell: StackCellBase, ManualLayoutStackCellType {

  private let label = UILabel()

  init(title: String) {
    super.init()

    addSubview(label)
    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.text = title
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    layout()
  }

  private func layout() {

    label.pin.all().fitSize()

  }

  func size(maxWidth: CGFloat?, maxHeight: CGFloat?) -> CGSize {

    if let maxWidth = maxWidth {
      self.pin.width(maxWidth)
    }

    layout()

    let size = self.bounds.size
    return size
    return CGSize(width: size.height, height: 16)
  }
}

final class FlexLabelStackCell: StackCellBase, ManualLayoutStackCellType {

  private let label = UILabel()

  init(title: String) {
    super.init()

    self
      .flex
      .direction(.row)
      .define { flex in
        flex.addItem(label)
    }

    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.text = title
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    layout()
  }

  private func layout() {
    self.flex.layout(mode: .adjustHeight)
  }

  func size(maxWidth: CGFloat?, maxHeight: CGFloat?) -> CGSize {

    if let maxWidth = maxWidth {
      self.flex.width(maxWidth)
    }

    layout()

    let size = self.bounds.size
    return size
  }
}

final class DatePickerCell : StackCellBase, ManualLayoutStackCellType {

  private let datePicker: UIDatePicker = .init()
  private let label: UILabel = .init()
  private let separator: UIView = .init()

  private var isOn: Bool = false

  override init() {
    super.init()

    self.addTarget(self, action: #selector(tap), for: .touchUpInside)

    label.flex.height(40)
    separator.flex.height(1 / UIScreen.main.scale)
    backgroundColor = UIColor(white: 0.9, alpha: 1)
  }

  @objc func tap() {
    isOn = !isOn
    updateLayout(animated: true)
  }

  override func didMoveToSuperview() {
    super.didMoveToSuperview()

    superview?.backgroundColor = .black
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    layout()
  }

  private func layout() {

    self.flex.define { flex in
      flex.addItem(label)

      flex.addItem(separator)
      flex.addItem(datePicker)

      separator.flex.isIncludedInLayout(isOn)
      datePicker.flex.isIncludedInLayout(isOn)

      separator.alpha = isOn ? 1 : 0
      datePicker.alpha = isOn ? 1 : 0
    }

    self.flex.layout(mode: .adjustHeight)
  }

  func size(maxWidth: CGFloat?, maxHeight: CGFloat?) -> CGSize {

    if let maxWidth = maxWidth {
      self.flex.width(maxWidth)
    }

    layout()

    let size = self.bounds.size
    return size
  }
}
