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

import EasyPeasy

open class StackScrollView: UIScrollView {
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    open func setup() {
        
        contentView.backgroundColor = UIColor.clear
        addSubview(contentView)
        
        alwaysBounceVertical = true
        delaysContentTouches = false
        keyboardDismissMode = .onDrag
        
        contentView <- [
            Edges(),
            Width().like(self, .width),
        ]
    }
    
    open func append(view: UIView, animated: Bool) {
        
        views.append(view)
        updateVerticalLayout(animated: animated)
    }
    
    open func append(views: [UIView], animated: Bool) {
        
        self.views += views
        updateVerticalLayout(animated: animated)
    }
    
    open func remove(view: UIView, animated: Bool) {
        
        if let index = views.index(of: view) {
            views.remove(at: index)
            view.removeFromSuperview()
        }
        updateVerticalLayout(animated: animated)
    }
    
    open func setHidden(_ hidden: Bool, view: UIView, animated: Bool) {
        
        func perform() {
            if hidden {
                view.superview! <- [
                    Height(0)
                ]
            } else {
                
                NSLayoutConstraint.deactivate(
                    view.superview! <- [
                        Height(0)
                    ]
                )                                
            }
        }
        
        if animated {
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState], animations: {
                
                perform()
                self.layoutIfNeeded()
                
            }) { (finish) in
                
            }
        } else {
            perform()
        }
    }
    
    open func scroll(to view: UIView, animated: Bool) {
        
        let targetRect = view.convert(view.bounds, to: self)
        scrollRectToVisible(targetRect, animated: true)
    }
    
    fileprivate func updateVerticalLayout(animated: Bool) {
                
        func perform() {
            
            guard views.count > 0 else {
                return
            }
            
            if views.count == 1 {
                
                let firstView = views.first!
                addSubViewToContainerViewIfNeeded(firstView) <- [
                    Edges(),
                ]
                
                return
            }
            
            if views.count == 2 {
                let firstView = views.first!
                let lastView = views.last!
                
                let lastContainerView = addSubViewToContainerViewIfNeeded(lastView)                                
                let firstContainerView = addSubViewToContainerViewIfNeeded(firstView)
                
                firstContainerView <- [
                    Top(),
                    Right(),
                    Left(),
                    Bottom().to(lastContainerView, .top),
                ]
                
                lastContainerView <- [
                    Right(),
                    Left(),
                    Bottom(),
                ]
                
                
                return
            }
            
            if views.count >= 3 {
                
                var _views = views
                
                let firstView = _views.removeFirst()
                let lastView = _views.removeLast()
                
                let firstContainerView = addSubViewToContainerViewIfNeeded(firstView)
                let lastContainerView = addSubViewToContainerViewIfNeeded(lastView)
                
                firstContainerView <- [
                    Top(),
                    Right(),
                    Left(),
                ]
                
                var _topContainerView: UIView = firstView
                
                for view in _views {
                    
                    let containerView = addSubViewToContainerViewIfNeeded(view)
                    
                    containerView <- [
                        Top().to(_topContainerView, .bottom),
                        Right(),
                        Left(),
                    ]
                    _topContainerView = containerView
                }
                
                lastContainerView <- [
                    Top().to(_topContainerView, .bottom),
                    Right(),
                    Left(),
                    Bottom(),
                ]
            }
        }
                       
        if animated {
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState], animations: {
                
                perform()
                self.layoutIfNeeded()
                
            }) { (finish) in
                
            }
        } else {
            perform()
        }
    }
    
    fileprivate var views: [UIView] = []
    
    fileprivate let contentView = UIView()
    
    fileprivate func addSubViewToContainerViewIfNeeded(_ view: UIView) -> UIView {
        if view.superview == nil {
            let containerView = UIView()
            containerView.isOpaque = true
            containerView.backgroundColor = UIColor.clear
            containerView.clipsToBounds = true
            containerView.addSubview(view)
            view <- [
                Edges().with(.mediumPriority)
            ]
            contentView.addSubview(containerView)
        }
        return view.superview!
    }
}
