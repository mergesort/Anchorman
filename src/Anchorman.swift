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

    public static let allSides = [ leading, trailing, top, bottom ]

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

    func pinToSuperview(edges: [EdgeAnchor] = EdgeAnchor.allSides, relation: NSLayoutRelation = .Equal, activate: Bool = true) -> [NSLayoutConstraint] {
        if let superview = self.superview {
            return self.pinToView(superview, edges: edges, activate: activate)
        } else {
            fatalError("Cannot pin to a nil superview")
        }
    }

    func pinToView(view: UIView, edges: [EdgeAnchor] = EdgeAnchor.allSides, relation: NSLayoutRelation = .Equal, activate: Bool = true) -> [NSLayoutConstraint] {
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

                let currentAnchor = self.layoutAnchorForEdge(edge)
                let viewAnchor = view.layoutAnchorForEdge(edge)
                let constraint: NSLayoutConstraint
                if relation == .GreaterThanOrEqual {
                    constraint = currentAnchor.constraintGreaterThanOrEqualToAnchor(viewAnchor, constant: constant)
                } else if relation == .LessThanOrEqual {
                    constraint = currentAnchor.constraintLessThanOrEqualToAnchor(viewAnchor, constant: constant)
                } else {
                    constraint = currentAnchor.constraintEqualToAnchor(viewAnchor, constant: constant)
                }

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

    func pinEdge(edge: EdgeAnchor, toEdge: EdgeAnchor, ofView: UIView, relation: NSLayoutRelation = .Equal, constant: CGFloat = 0.0, priority: UILayoutPriority = UILayoutPriorityRequired, activate: Bool = true) -> NSLayoutConstraint {
        let fromAnchor = self.layoutAnchorForEdge(edge)
        let toAnchor = ofView.layoutAnchorForEdge(toEdge)

        let constraint: NSLayoutConstraint
        if relation == .GreaterThanOrEqual {
            constraint = fromAnchor.constraintGreaterThanOrEqualToAnchor(toAnchor, constant: constant)
        } else if relation == .LessThanOrEqual {
            constraint = fromAnchor.constraintLessThanOrEqualToAnchor(toAnchor, constant: constant)
        } else {
            constraint = fromAnchor.constraintEqualToAnchor(toAnchor, constant: constant)
        }

        constraint.priority = priority
        constraint.active = activate

        return constraint
    }

    func setSize(sizeAnchor: SizeAnchor, relation: NSLayoutRelation = .Equal, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        let currentDimension = self.layoutDimensionForAnchor(sizeAnchor)

        let constraint: NSLayoutConstraint
        if relation == .GreaterThanOrEqual {
            constraint = currentDimension.constraintGreaterThanOrEqualToConstant(sizeAnchor.constant)
        } else if relation == .LessThanOrEqual {
            constraint = currentDimension.constraintLessThanOrEqualToConstant(sizeAnchor.constant)
        } else {
            constraint = currentDimension.constraintEqualToConstant(sizeAnchor.constant)
        }

        constraint.priority = sizeAnchor.priority
        constraint.active = activate

        return constraint
    }

    func setSize(sizeAnchors: [SizeAnchor] = [ SizeAnchor.width, SizeAnchor.height ], relation: NSLayoutRelation = .Equal, activate: Bool = true) -> [NSLayoutConstraint] {
        return sizeAnchors.map { return self.setSize($0, relation: relation, activate: activate) }
    }

    func setRelativeSize(sizeAnchor: SizeAnchor, toSizeAnchor: SizeAnchor, ofView: UIView, multiplier: CGFloat, constant: CGFloat, relation: NSLayoutRelation = .Equal, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        let fromDimension = self.layoutDimensionForAnchor(sizeAnchor)
        let toDimension = ofView.layoutDimensionForAnchor(toSizeAnchor)

        let constraint: NSLayoutConstraint
        if relation == .GreaterThanOrEqual {
            constraint = fromDimension.constraintGreaterThanOrEqualToAnchor(toDimension, multiplier: multiplier, constant: constant)
        } else if relation == .LessThanOrEqual {
            constraint = fromDimension.constraintLessThanOrEqualToAnchor(toDimension, multiplier: multiplier, constant: constant)
        } else {
            constraint = fromDimension.constraintEqualToAnchor(toDimension, multiplier: multiplier, constant: constant)
        }

        constraint.priority = sizeAnchor.priority
        constraint.active = activate

        return constraint
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

    func layoutDimensionForAnchor(size: SizeAnchor) -> NSLayoutDimension {
        switch size {

        case SizeAnchor.width:
            return self.widthAnchor

        case SizeAnchor.height:
            return self.heightAnchor

        default:
            fatalError("There is an unhandled size. Have you considered checking in another dimension? 📐")

        }
    }

    func layoutAnchorForEdge(edge: EdgeAnchor) -> NSLayoutAnchor {
        switch edge {

        case EdgeAnchor.leading:
            return self.leadingAnchor

        case EdgeAnchor.trailing:
            return self.trailingAnchor

        case EdgeAnchor.top:
            return self.topAnchor

        case EdgeAnchor.bottom:
            return self.bottomAnchor

        case EdgeAnchor.centerX:
            return self.centerXAnchor

        case EdgeAnchor.centerY:
            return self.centerYAnchor

        case EdgeAnchor.width:
            return self.widthAnchor

        case EdgeAnchor.height:
            return self.heightAnchor

        default:
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
