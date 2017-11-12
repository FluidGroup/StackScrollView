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
