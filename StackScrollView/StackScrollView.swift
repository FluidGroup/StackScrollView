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

open class StackScrollView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  private enum LayoutKeys {
    static let top = "me.muukii.StackScrollView.top"
    static let right = "me.muukii.StackScrollView.right"
    static let left = "me.muukii.StackScrollView.left"
    static let bottom = "me.muukii.StackScrollView.bottom"
    static let width = "me.muukii.StackScrollView.width"
  }
  
  private static func defaultLayout() -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.sectionInset = .zero
    return layout
  }
  
  private let collectionView: InternalCollectionView
  
  open var contentInset: UIEdgeInsets {
    get {
      return collectionView.contentInset
    }
    set {
      collectionView.contentInset = newValue
    }
  }
  
  open var scrollIndicatorInsets: UIEdgeInsets {
    get {
      return collectionView.scrollIndicatorInsets
    }
    set {
      collectionView.scrollIndicatorInsets = newValue
    }
  }
  
  open var keyboardDismissMode: UIScrollViewKeyboardDismissMode {
    get {
      return collectionView.keyboardDismissMode
    }
    set {
      collectionView.keyboardDismissMode = newValue
    }
  }
  
  // MARK: - Initializers
  
  public init(frame: CGRect, collectionViewLayout: UICollectionViewFlowLayout) {
    collectionView = InternalCollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
    super.init(frame: frame)
    setup()
  }
  
  public override init(frame: CGRect) {
    collectionView = InternalCollectionView(frame: frame, collectionViewLayout: StackScrollView.defaultLayout())
    super.init(frame: frame)
    setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    collectionView = InternalCollectionView(frame: .zero, collectionViewLayout: StackScrollView.defaultLayout())
    super.init(coder: aDecoder)
    setup()
  }
  
  private(set) public var views: [UIView] = []
  
  private func identifier(_ v: UIView) -> String {
    return v.hashValue.description
  }
  
  private func setup() {
    
    backgroundColor = .white
    
    addSubview(collectionView)
    collectionView.frame = bounds
    collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    
    collectionView.alwaysBounceVertical = true
    collectionView.delaysContentTouches = false
    collectionView.keyboardDismissMode = .interactive
    collectionView.backgroundColor = .clear
    
    collectionView.delegate = self
    collectionView.dataSource = self
  }

  open func append(view: UIView) {
    
    views.append(view)
    
    collectionView.register(Cell.self, forCellWithReuseIdentifier: identifier(view))
    
    collectionView.reloadData()
  }  
  
  open func append(views _views: [UIView]) {
    
    views += _views
    _views.forEach { view in
      collectionView.register(Cell.self, forCellWithReuseIdentifier: identifier(view))
    }
    collectionView.reloadData()
  }
  
  // TODO:
  func append(lazy: @escaping () -> UIView) {
    
  }
  
  open func remove(view: UIView, animated: Bool) {
    
    if let index = views.index(of: view) {
      views.remove(at: index)
      if animated {
        UIView.animate(
          withDuration: 0.5,
          delay: 0,
          usingSpringWithDamping: 1,
          initialSpringVelocity: 0,
          options: [
            .beginFromCurrentState,
            .allowUserInteraction,
            .overrideInheritedCurve,
            .overrideInheritedOptions,
            .overrideInheritedDuration
          ],
          animations: {
            self.collectionView.performBatchUpdates({
              self.collectionView.deleteItems(at: [IndexPath.init(item: index, section: 0)])
            }, completion: nil)
        }) { (finish) in
          
        }
        
      } else {
        UIView.performWithoutAnimation {
          collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: [IndexPath.init(item: index, section: 0)])
          }, completion: nil)
        }
      }
    }
  }
  
  open func scroll(to view: UIView, animated: Bool) {
    
    let targetRect = view.convert(view.bounds, to: self)
    collectionView.scrollRectToVisible(targetRect, animated: true)
  }
  
  open func scroll(to view: UIView, at position: UICollectionViewScrollPosition, animated: Bool) {
    if let index = views.index(of: view) {
      collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: position, animated: animated)
    }
  }
  
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return views.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let view = views[indexPath.item]
    let _identifier = identifier(view)
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: _identifier, for: indexPath)
    
    if view.superview == cell.contentView {
      return cell
    }
    
    precondition(cell.contentView.subviews.isEmpty)
    
    view.translatesAutoresizingMaskIntoConstraints = false
    cell.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    cell.contentView.addSubview(view)
    
    let top = view.topAnchor.constraint(equalTo: cell.contentView.topAnchor)
    let right = view.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor)
    let bottom = view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
    let left = view.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor)
    
    top.identifier = LayoutKeys.top
    right.identifier = LayoutKeys.right
    bottom.identifier = LayoutKeys.bottom
    left.identifier = LayoutKeys.left
    
    NSLayoutConstraint.activate([
      top,
      right,
      bottom,
      left,
      ])
    
    return cell
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let view = views[indexPath.item]
    
    let width: NSLayoutConstraint = {
      
      guard let c = view.constraints.filter({ $0.identifier == LayoutKeys.width }).first else {
        let width = view.widthAnchor.constraint(equalToConstant: collectionView.bounds.width)
        width.identifier = LayoutKeys.width
        width.isActive = true
        return width
      }
      
      return c
    }()
    
    width.constant = collectionView.bounds.width
    
    let size = view.superview?.systemLayoutSizeFitting(UILayoutFittingCompressedSize) ?? view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    
    assert(size.width == collectionView.bounds.width)
    
    return size
  }
  
  public func updateLayout(animated: Bool) {
    
    if animated {
      UIView.animate(
        withDuration: 0.5,
        delay: 0,
        usingSpringWithDamping: 1,
        initialSpringVelocity: 0,
        options: [
          .beginFromCurrentState,
          .allowUserInteraction,
          .overrideInheritedCurve,
          .overrideInheritedOptions,
          .overrideInheritedDuration
        ],
        animations: {
          self.collectionView.performBatchUpdates(nil, completion: nil)
          self.layoutIfNeeded()
      }) { (finish) in
        
      }
    } else {
      UIView.performWithoutAnimation {
        self.collectionView.performBatchUpdates(nil, completion: nil)
        self.layoutIfNeeded()
      }
    }
  }
  
  final class Cell: UICollectionViewCell {
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
      return layoutAttributes
    }
  }
}

private class InternalCollectionView: UICollectionView {
  
  open override func touchesShouldCancel(in view: UIView) -> Bool {
    return true
  }
}
