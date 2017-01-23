// StackScrollView.swift
//
// Copyright (c) 2016 muukii
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

open class StackScrollView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  fileprivate var views: [UIView] = []

  public convenience init() {
    self.init(frame: .zero)
  }

  public init(frame: CGRect) {

    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.sectionInset = .zero

    super.init(frame: frame, collectionViewLayout: layout)
    setup()
  }

  public required init?(coder aDecoder: NSCoder) {

    super.init(coder: aDecoder)
    setup()
  }

  open func setup() {

    register(Cell.self, forCellWithReuseIdentifier: "Cell")
    alwaysBounceVertical = true
    delaysContentTouches = false
    keyboardDismissMode = .onDrag
    backgroundColor = .white

    delegate = self
    dataSource = self
  }

  open func append(view: UIView) {

    views.append(view)

    reloadData()
  }

  open func append(views: [UIView]) {

    self.views += views

    reloadData()
  }

  open func remove(view: UIView, animated: Bool) {

    if let index = views.index(of: view) {
      views.remove(at: index)
      view.removeFromSuperview()
    }
  }

  open func scroll(to view: UIView, animated: Bool) {

    let targetRect = view.convert(view.bounds, to: self)
    scrollRectToVisible(targetRect, animated: true)
  }

  open override func touchesShouldCancel(in view: UIView) -> Bool {
    return true
  }

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return views.count
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

    cell.contentView.subviews.forEach { $0.removeFromSuperview() }

    let view = views[indexPath.item]
    view.translatesAutoresizingMaskIntoConstraints = false
    cell.contentView.addSubview(view)

    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
      view.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor),
      view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
      view.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor),
      ])

    return cell
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    var targetSize = UILayoutFittingCompressedSize
    targetSize.width = collectionView.bounds.width

    let view = views[indexPath.item]

    var size = view.systemLayoutSizeFitting(targetSize)
    size.width = collectionView.bounds.width

    return size
  }

  final class Cell: UICollectionViewCell {

  }
}
