import UIKit

public struct EdgeAnchor: OptionSetType {
    public let rawValue: Int
    public let constant: CGFloat
    public let priority: UILayoutPriority

    public init(rawValue: Int) {
        self.rawValue = rawValue
        self.constant = 0.0
        self.priority = UILayoutPriorityRequired
    }

    public init(rawValue: Int, constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) {
        self.rawValue = rawValue
        self.constant = constant
        self.priority = priority
    }

    public static let leading = EdgeAnchor(rawValue: 1 << 1)
    public static let trailing = EdgeAnchor(rawValue: 1 << 2)
    public static let top = EdgeAnchor(rawValue: 1 << 3)
    public static let bottom = EdgeAnchor(rawValue: 1 << 4)
    public static let centerX = EdgeAnchor(rawValue: 1 << 5)
    public static let centerY = EdgeAnchor(rawValue: 1 << 6)
    public static let width = EdgeAnchor(rawValue: 1 << 7)
    public static let height = EdgeAnchor(rawValue: 1 << 8)

    public static let allEdges = [ leading, trailing, top, bottom ]

    public static func leading(constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> EdgeAnchor {
        return EdgeAnchor(rawValue: EdgeAnchor.leading.rawValue, constant: constant, priority: priority)
    }

    public static func trailing(constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> EdgeAnchor {
        return EdgeAnchor(rawValue: EdgeAnchor.trailing.rawValue, constant: constant, priority: priority)
    }

    public static func top(constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> EdgeAnchor {
        return EdgeAnchor(rawValue: EdgeAnchor.top.rawValue, constant: constant, priority: priority)
    }

    public static func bottom(constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> EdgeAnchor {
        return EdgeAnchor(rawValue: EdgeAnchor.bottom.rawValue, constant: constant, priority: priority)
    }

    public static func centerX(constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> EdgeAnchor {
        return EdgeAnchor(rawValue: EdgeAnchor.centerX.rawValue, constant: constant, priority: priority)
    }

    public static func centerY(constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> EdgeAnchor {
        return EdgeAnchor(rawValue: EdgeAnchor.centerY.rawValue, constant: constant, priority: priority)
    }

    public static func width(constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> EdgeAnchor {
        return EdgeAnchor(rawValue: EdgeAnchor.width.rawValue, constant: constant, priority: priority)
    }

    public static func height(constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> EdgeAnchor {
        return EdgeAnchor(rawValue: EdgeAnchor.height.rawValue, constant: constant, priority: priority)
    }

}

public struct SizeAnchor: OptionSetType {
    public let rawValue: Int
    public let constant: CGFloat
    public let priority: UILayoutPriority

    public init(rawValue: Int) {
        self.rawValue = rawValue
        self.constant = 0.0
        self.priority = UILayoutPriorityRequired
    }

    public init(rawValue: Int, constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) {
        self.rawValue = rawValue
        self.constant = constant
        self.priority = priority
    }

    public static let width = SizeAnchor(rawValue: 1 << 1)
    public static let height = SizeAnchor(rawValue: 1 << 2)

    public static func width(constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> SizeAnchor {
        return SizeAnchor(rawValue: SizeAnchor.width.rawValue, constant: constant, priority: priority)
    }

    public static func height(constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> SizeAnchor {
        return SizeAnchor(rawValue: SizeAnchor.height.rawValue, constant: constant, priority: priority)
    }

}

public extension UIView {

    static func setTranslateAutoresizingMasks(views: [UIView], on: Bool) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = on
        }
    }

}

public extension UIView {

    func pinToSuperview(edges: [EdgeAnchor] = EdgeAnchor.allEdges, activate: Bool = true) -> [NSLayoutConstraint] {
        if let superview = self.superview {
            return self.pinToView(superview, edges: edges, activate: activate)
        } else {
            fatalError("Cannot pin to a nil superview")
        }
    }

    func pinToView(view: UIView, edges: [EdgeAnchor] = EdgeAnchor.allEdges, activate: Bool = true) -> [NSLayoutConstraint] {
        let addConstraint: (edge: EdgeAnchor) -> NSLayoutConstraint? = { edge in
            if edges.contains(edge) {
                let constant: CGFloat
                let priority: UILayoutPriority

                if let index = edges.indexOf(edge) {
                    let currentEdge = edges[index]
                    constant = currentEdge.constant
                    priority = currentEdge.priority
                } else {
                    constant = 0.0
                    priority = UILayoutPriorityRequired
                }

                let currentAnchor = self.anchorForEdge(edge)
                let viewAnchor = view.anchorForEdge(edge)
                let constraint = currentAnchor.constraintEqualToAnchor(viewAnchor, constant: constant)
                constraint.priority = priority
                return constraint
            }

            return nil
        }

        let leadingConstraint = addConstraint(edge: .leading)
        let trailingConstraint = addConstraint(edge: .trailing)
        let topConstraint = addConstraint(edge: .top)
        let bottomConstraint = addConstraint(edge: .bottom)
        let centerXConstraint = addConstraint(edge: .centerX)
        let centerYConstraint = addConstraint(edge: .centerY)
        let widthConstraint = addConstraint(edge: .width)
        let heightConstraint = addConstraint(edge: .height)

        self.translatesAutoresizingMaskIntoConstraints = false

        let viewConstraints = [ leadingConstraint, trailingConstraint, topConstraint, bottomConstraint, centerXConstraint, centerYConstraint, widthConstraint, heightConstraint ].flatMap { $0 }
        viewConstraints.setActive(activate)

        return viewConstraints
    }

    func pinEdge(edge: EdgeAnchor, toEdge: EdgeAnchor, ofView: UIView, constant: CGFloat = 0.0, priority: UILayoutPriority = UILayoutPriorityRequired, activate: Bool = true) -> NSLayoutConstraint {
        let fromAnchor = self.anchorForEdge(edge)
        let toAnchor = ofView.anchorForEdge(toEdge)

        let constraint = fromAnchor.constraintEqualToAnchor(toAnchor, constant: constant)
        constraint.priority = priority
        constraint.active = activate

        return constraint
    }

    func setSize(sizeAnchors: [SizeAnchor] = [ SizeAnchor.width, SizeAnchor.height ], activate: Bool = true) -> [NSLayoutConstraint] {
        let addConstraint: (sizeAnchor: SizeAnchor, currentDimension: NSLayoutDimension) -> NSLayoutConstraint? = { sizeAnchor, currentDimension in
            if sizeAnchors.contains(sizeAnchor) {
                let constant: CGFloat
                let priority: UILayoutPriority

                if let index = sizeAnchors.indexOf(sizeAnchor) {
                    let currentAnchor = sizeAnchors[index]
                    constant = currentAnchor.constant
                    priority = currentAnchor.priority
                } else {
                    constant = 0.0
                    priority = UILayoutPriorityRequired
                }

                let constraint = currentDimension.constraintEqualToConstant(constant)
                constraint.priority = priority
                return constraint
            }

            return nil
        }

        self.translatesAutoresizingMaskIntoConstraints = false

        let widthConstraint = addConstraint(sizeAnchor: .width, currentDimension: self.widthAnchor)
        let heightConstraint = addConstraint(sizeAnchor: .height, currentDimension: self.heightAnchor)

        let viewConstraints = [ widthConstraint, heightConstraint ].flatMap { $0 }
        viewConstraints.setActive(activate)

        return viewConstraints
    }

}

public extension NSLayoutConstraint {

    static func activateAllConstraints(constraints: [[NSLayoutConstraint]]) {
        NSLayoutConstraint.activateConstraints(constraints.flatMap { $0 })
    }

    static func deactivateAllConstraints(constraints: [[NSLayoutConstraint]]) {
        NSLayoutConstraint.deactivateConstraints(constraints.flatMap { $0 })
    }

}


// MARK: Objective-C API

public extension UIView {

    // Set leading, trailing, top, and bottom anchors to equal to another view
    @available(*, unavailable, message="Only to be used from Objective-C") func objc_pinToView(view: UIView, inset: UIEdgeInsets = UIEdgeInsetsZero) -> [NSLayoutConstraint] {
        return self._objcPinToView(view)
    }

    @available(*, unavailable, message="Only to be used from Objective-C") func objc_pinToSuperview(inset: UIEdgeInsets = UIEdgeInsetsZero) -> [NSLayoutConstraint] {
        if let superview = self.superview {
            return self._objcPinToView(superview, inset: inset)
        } else {
            fatalError("Cannot pin to a nil superview")
        }
    }

}

private extension UIView {

    func anchorForEdge(edge: EdgeAnchor) -> NSLayoutAnchor {
        if edge == .leading {
            return self.leadingAnchor
        } else if edge == .trailing {
            return self.trailingAnchor
        } else if edge == .top {
            return self.topAnchor
        } else if edge == .bottom {
            return self.bottomAnchor
        } else if edge == .centerX {
            return self.centerXAnchor
        } else if edge == .centerY {
            return self.centerYAnchor
        } else if edge == .width {
            return self.widthAnchor
        } else if edge == .height {
            return self.heightAnchor
        } else {
            fatalError("There is an unhandled edge case with edges. Get it? Edge case… 😂")
        }
    }

    func _objcPinToView(view: UIView, inset: UIEdgeInsets = UIEdgeInsetsZero) -> [NSLayoutConstraint] {
        let viewConstraints: [NSLayoutConstraint] = [
            self.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: inset.left),
            self.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: inset.right),
            self.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: inset.top),
            self.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: inset.bottom),
            ]

        return viewConstraints
    }
    
}

private extension Array where Element: NSLayoutConstraint {
    func setActive(active: Bool) {
        if active {
            NSLayoutConstraint.activateConstraints(self)
        } else {
            NSLayoutConstraint.deactivateConstraints(self)
        }
    }
}
