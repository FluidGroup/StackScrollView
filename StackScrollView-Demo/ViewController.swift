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

import Then

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorA = UIColor(white: 0.9, alpha: 1)
        let colorB = UIColor(white: 0.8, alpha: 1)
        
        
        let labelCell = LabelStackViewCell().then { cell in
            cell.backgroundColor = colorA
            cell.titleLabel.text = "Hiroshi"
            cell.detailLabel.text = "Kimura"
        }
        
        let switchCell = SwitchStackViewCell().then { cell in
            cell.backgroundColor = colorB
            cell.titleLabel.text = "Hiroshi"
            cell.valueChanged = { on in
                
            }
        }
        
        let labelFromTextCell = LabelStackViewCell().then { cell in
            cell.backgroundColor = colorA
            cell.titleLabel.text = "Hiroshi"
            cell.detailLabel.text = "Kimura"
        }
        
        let textFieldCell = TextFieldStackViewCell().then { cell in
            cell.backgroundColor = colorB
            cell.titleLabel.text = "Hiroshi"
            cell.valueChanged = { string in
                
                labelFromTextCell.titleLabel.text = string
            }
        }
        
        let topCells = (0...20).map { i -> LabelStackViewCell in
            LabelStackViewCell().then { cell in
                cell.backgroundColor = colorA
                cell.titleLabel.text = "\(i)"
                cell.detailLabel.text = "\(i)"
            }
        }
        
        let mediumCells = [
            labelCell,
            switchCell,
            textFieldCell,
            ]
        
        let bottomCells = (20...40).map { i -> LabelStackViewCell in
            LabelStackViewCell().then { cell in
                cell.backgroundColor = colorA
                cell.titleLabel.text = "\(i)"
                cell.detailLabel.text = "\(i)"
            }
        }
        
        stackScrollView.append(
            views: [labelFromTextCell] + [topCells, mediumCells, bottomCells].flatMap { $0 })
        
        stackScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackScrollView.frame = view.bounds
        view.addSubview(stackScrollView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var stackScrollView = StackScrollView()
}

class LabelStackViewCell: UIView {
    
    init() {
        super.init(frame: .zero)
        
        addSubview(titleLabel)
        addSubview(detailLabel)
        
        titleLabel <- [
            Left(8),
            CenterY(),
        ]
        
        detailLabel <- [
            Right(8),
            CenterY(),
        ]
    }
    
    override var intrinsicContentSize : CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 60)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel = UILabel()
    let detailLabel = UILabel()
}

class SwitchStackViewCell: UIView, StackScrollViewCellType {
    
    var valueChanged: (Bool) -> Void = { _ in }
    
    init() {
        super.init(frame: .zero)
        
        addSubview(titleLabel)
        addSubview(switchView)
        
        titleLabel <- [
            Left(8),
            CenterY(),
        ]
        
        switchView <- [
            Right(8),
            CenterY(),
        ]
        
        switchView.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    override var intrinsicContentSize : CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: switchView.isOn ? 60 : 200)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel = UILabel()
    
    let switchView = UISwitch()
    
    @objc fileprivate func switchValueChanged() {
        
        valueChanged(switchView.isOn)        
        updateLayout(animated: true)
    }
}

class TextFieldStackViewCell: UIView {
    
    var valueChanged: (String) -> Void = { _ in }
    
    init() {
        super.init(frame: .zero)
        
        addSubview(titleLabel)
        addSubview(textField)
        
        titleLabel.setContentHuggingPriority(950, for: .horizontal)
        titleLabel <- [
            Left(8),
            CenterY(),
        ]
        
        textField <- [
            Left(8).to(titleLabel, .right),
            Right(8),
            CenterY(),
        ]
        
        textField.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    
    override var intrinsicContentSize : CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 60)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel = UILabel()
    
    let textField = UITextField()
    
    @objc fileprivate func textChanged() {
        
        valueChanged(textField.text ?? "")
    }
}
