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
        
        stackScrollView.append(
            views: [
                labelCell,
                switchCell,
                labelFromTextCell,
                textFieldCell,
            ],
            animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var stackScrollView: StackScrollView!
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
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 60)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel = UILabel()
    let detailLabel = UILabel()
}

class SwitchStackViewCell: UIView {
    
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
        
        switchView.addTarget(self, action: #selector(switchValueChanged), forControlEvents: .ValueChanged)
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 60)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel = UILabel()
    
    let switchView = UISwitch()
    
    @objc private func switchValueChanged() {
        
        valueChanged(switchView.on)
    }
}

class TextFieldStackViewCell: UIView {
    
    var valueChanged: (String) -> Void = { _ in }
    
    init() {
        super.init(frame: .zero)
        
        addSubview(titleLabel)
        addSubview(textField)
        
        titleLabel.setContentHuggingPriority(950, forAxis: .Horizontal)
        titleLabel <- [
            Left(8),
            CenterY(),
        ]
        
        textField <- [
            Left(8).to(titleLabel, .Right),
            Right(8),
            CenterY(),
        ]
        
        textField.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        textField.addTarget(self, action: #selector(textChanged), forControlEvents: .EditingChanged)
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 60)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel = UILabel()
    
    let textField = UITextField()
    
    @objc private func textChanged() {
        
        valueChanged(textField.text ?? "")
    }
}
