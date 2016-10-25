//
//  _StackScrollView.swift
//  StackScrollView
//
//  Created by muukii on 2016/10/26.
//  Copyright © 2016 muukii. All rights reserved.
//

import Foundation

public protocol BetaStackScrollViewCellType: class {
    
}

extension BetaStackScrollViewCellType where Self: UIView {
    
    public var stackScrollView: BetaStackScrollView {
        
        var superview: UIView? = self
        
        while !(superview is BetaStackScrollView) {
            superview = superview?.superview
        }
        
        precondition(superview is BetaStackScrollView, "Must be added StackScrollView")
        return superview as! BetaStackScrollView
    }
    
    public func updateLayout(animated: Bool) {
        stackScrollView.updateLayout(animated: animated)
    }
    
    public func set(isHidden: Bool, animated: Bool) {
        
        stackScrollView.setHidden(isHidden: isHidden, view: self, animated: animated)
    }
    
    public func scrollToSelf(animated: Bool) {
        
        stackScrollView.scroll(to: self, animated: animated)
    }
}

open class BetaStackScrollView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    open func setup() {
        
        tableView.backgroundColor = UIColor.clear
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.frame = bounds
        
        addSubview(tableView)
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            tableView.separatorStyle = .none
            tableView.separatorColor = .clear
            tableView.separatorInset = .zero
            tableView.delegate = self
            tableView.dataSource = self
        } else {
            tableView.delegate = nil
            tableView.dataSource = nil
        }
    }
    
    open func append(view: UIView, animated: Bool) {
        
        cells.append(createCell(view: view))
        
        // TODO: Improve performance, animated
        tableView.reloadData()
        if animated {
            UIView.animate(withDuration: 0.3, animations: { 
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            })
        }
    }
    
    open func append(views: [UIView], animated: Bool) {
        
        let _cells = views.map(createCell)
        
        cells += _cells
        // TODO: Improve performance, animated
        tableView.reloadData()
        updateLayout(animated: animated)
    }
    
    open func remove(view: UIView, animated: Bool) {
        
        if let index = cells.flatMap({ $0.contentView.subviews.first }).index(of: view) {
            cells.remove(at: index)
        }
        
        // TODO: Improve performance, animated
        tableView.reloadData()
        updateLayout(animated: animated)
    }
    
    open func setHidden(isHidden: Bool, view: UIView, animated: Bool) {
        
        view.isHidden = isHidden
        updateLayout(animated: animated)
    }
    
    open func scroll(to view: UIView, animated: Bool) {
        
        let targetRect = view.convert(view.bounds, to: self)
        tableView.scrollRectToVisible(targetRect, animated: true)
    }
    
    public var cells: [UITableViewCell] = []
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    public func updateLayout(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            })
        }else {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    private func createCell(view: UIView) -> UITableViewCell {
        let cell = UITableViewCell(frame: .zero)
        cell.separatorInset = .zero
        cell.selectionStyle = .none
        
        let contentView = cell.contentView
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0),
            ])
        return cell
    }
    
    // MARK: - UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cells.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return cells[indexPath.row]
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // iOS8 Bugs
        
        let cell = cells[indexPath.row]
        
        let contentView = cell.contentView
        contentView.invalidateIntrinsicContentSize()
        
        guard contentView.subviews.first?.isHidden == false else {
            return 0
        }
        
        let width = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: tableView.bounds.width)
        
        NSLayoutConstraint.activate([width])
        
        let size = contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        
        NSLayoutConstraint.deactivate([width])
        
        return size.height
    }
}
