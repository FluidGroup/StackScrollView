
import Foundation
import UIKit

open class StackCell: UIView, StackCellType {
  
  open var shouldAnimateLayoutChanges: Bool = true
  
  open override func invalidateIntrinsicContentSize() {
    super.invalidateIntrinsicContentSize()
    updateLayout(animated: shouldAnimateLayoutChanges)
  }
}
