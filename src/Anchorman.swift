import UIKit

public protocol Anchor {

    var rawValue: Int { get }
    var constant: CGFloat { get }
    var priority: UILayoutPriority { get }

    init(rawValue: Int, constant: CGFloat, priority: UILayoutPriority)

}

public extension Anchor {

    public init(rawValue: Int) {
        self.init(rawValue: rawValue, constant: 0.0, priority: UILayoutPriorityRequired)
    }

}

public struct EdgeAnchor: OptionSet, Anchor {

    public let rawValue: Int
    public let constant: CGFloat
    public let priority: UILayoutPriority

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

    @discardableResult
    public static func leading(_ constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> EdgeAnchor {
        return EdgeAnchor(rawValue: EdgeAnchor.leading.rawValue, constant: constant, priority: priority)
    }

    @discardableResult
    public static func trailing(_ constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> EdgeAnchor {
        return EdgeAnchor(rawValue: EdgeAnchor.trailing.rawValue, constant: constant, priority: priority)
    }

    @discardableResult
    public static func top(_ constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> EdgeAnchor {
        return EdgeAnchor(rawValue: EdgeAnchor.top.rawValue, constant: constant, priority: priority)
    }

    @discardableResult
    public static func bottom(_ constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> EdgeAnchor {
        return EdgeAnchor(rawValue: EdgeAnchor.bottom.rawValue, constant: constant, priority: priority)
    }

    @discardableResult
    public static func centerX(_ constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> EdgeAnchor {
        return EdgeAnchor(rawValue: EdgeAnchor.centerX.rawValue, constant: constant, priority: priority)
    }

    @discardableResult
    public static func centerY(_ constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> EdgeAnchor {
        return EdgeAnchor(rawValue: EdgeAnchor.centerY.rawValue, constant: constant, priority: priority)
    }

    @discardableResult
    public static func width(_ constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> EdgeAnchor {
        return EdgeAnchor(rawValue: EdgeAnchor.width.rawValue, constant: constant, priority: priority)
    }

    @discardableResult
    public static func height(_ constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> EdgeAnchor {
        return EdgeAnchor(rawValue: EdgeAnchor.height.rawValue, constant: constant, priority: priority)
    }

}

public struct SizeAnchor: OptionSet, Anchor {
    public let rawValue: Int
    public let constant: CGFloat
    public let priority: UILayoutPriority

    public init(rawValue: Int, constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) {
        self.rawValue = rawValue
        self.constant = constant
        self.priority = priority
    }

    public static let width = SizeAnchor(rawValue: 1 << 1)
    public static let height = SizeAnchor(rawValue: 1 << 2)

    @discardableResult
    public static func width(_ constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> SizeAnchor {
        return SizeAnchor(rawValue: SizeAnchor.width.rawValue, constant: constant, priority: priority)
    }

    @discardableResult
    public static func height(_ constant: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) -> SizeAnchor {
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

    @discardableResult
    func pinToSuperview(_ edges: [EdgeAnchor] = EdgeAnchor.allSides, relation: NSLayoutRelation = .equal, activate: Bool = true) -> [NSLayoutConstraint] {
        if let superview = self.superview {
            return self.pinToView(superview, edges: edges, activate: activate)
        } else {
            fatalError("Cannot pin to a nil superview")
        }
    }

    @discardableResult
    func pinToView(_ view: UIView, edges: [EdgeAnchor] = EdgeAnchor.allSides, relation: NSLayoutRelation = .equal, activate: Bool = true) -> [NSLayoutConstraint] {
        let addConstraint: (_ edge: EdgeAnchor) -> NSLayoutConstraint? = { edge in
            if edges.contains(edge) {
                let constant: CGFloat
                let priority: UILayoutPriority

                if let index = edges.index(of: edge) {
                    let currentEdge = edges[index]
                    constant = currentEdge.constant
                    priority = currentEdge.priority
                } else {
                    constant = 0.0
                    priority = UILayoutPriorityRequired
                }

                let currentAnchor = self.layoutAnchor(edge: edge)
                let viewAnchor = view.layoutAnchor(edge: edge)
                let constraint: NSLayoutConstraint
                if relation == .greaterThanOrEqual {
                    NSLayoutYAxisAnchor().constraint(greaterThanOrEqualTo: NSLayoutYAxisAnchor(), constant: 0)
                    constraint = currentAnchor.constraint(greaterThanOrEqualTo: viewAnchor, constant: constant)
                } else if relation == .lessThanOrEqual {
                    constraint = currentAnchor.constraint(lessThanOrEqualTo: viewAnchor, constant: constant)
                } else {
                    constraint = currentAnchor.constraint(equalTo: viewAnchor, constant: constant)
                }

                constraint.priority = priority
                return constraint
            }

            return nil
        }

        let leadingConstraint = addConstraint(.leading)
        let trailingConstraint = addConstraint(.trailing)
        let topConstraint = addConstraint(.top)
        let bottomConstraint = addConstraint(.bottom)
        let centerXConstraint = addConstraint(.centerX)
        let centerYConstraint = addConstraint(.centerY)
        let widthConstraint = addConstraint(.width)
        let heightConstraint = addConstraint(.height)

        self.translatesAutoresizingMaskIntoConstraints = false

        let viewConstraints = [ leadingConstraint, trailingConstraint, topConstraint, bottomConstraint, centerXConstraint, centerYConstraint, widthConstraint, heightConstraint ].flatMap { $0 }
        viewConstraints.setActive(active: activate)

        return viewConstraints
    }

    @discardableResult
    func pinEdge(_ edge: EdgeAnchor, toEdge: EdgeAnchor, ofView: UIView, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0, priority: UILayoutPriority = UILayoutPriorityRequired, activate: Bool = true) -> NSLayoutConstraint {
        let fromAnchor = self.layoutAnchor(edge: edge)
        let toAnchor = ofView.layoutAnchor(edge: toEdge)

        let constraint: NSLayoutConstraint
        if relation == .greaterThanOrEqual {
            constraint = fromAnchor.constraint(greaterThanOrEqualTo: toAnchor, constant: constant)
        } else if relation == .lessThanOrEqual {
            constraint = fromAnchor.constraint(lessThanOrEqualTo: toAnchor, constant: constant)
        } else {
            constraint = fromAnchor.constraint(equalTo: toAnchor, constant: constant)
        }

        constraint.priority = priority
        constraint.isActive = activate

        return constraint
    }

    @discardableResult
    func setSize(_ sizeAnchor: SizeAnchor, relation: NSLayoutRelation = .equal, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        let currentDimension = self.layoutDimensionForAnchor(size: sizeAnchor)

        let constraint: NSLayoutConstraint
        if relation == .greaterThanOrEqual {
            constraint = currentDimension.constraint(greaterThanOrEqualToConstant: sizeAnchor.constant)
        } else if relation == .lessThanOrEqual {
            constraint = currentDimension.constraint(lessThanOrEqualToConstant: sizeAnchor.constant)
        } else {
            constraint = currentDimension.constraint(equalToConstant: sizeAnchor.constant)
        }

        constraint.priority = sizeAnchor.priority
        constraint.isActive = activate

        return constraint
    }

    @discardableResult
    func setSize(_ sizeAnchors: [SizeAnchor] = [ SizeAnchor.width, SizeAnchor.height ], relation: NSLayoutRelation = .equal, activate: Bool = true) -> [NSLayoutConstraint] {
        return sizeAnchors.map { return self.setSize($0, relation: relation, activate: activate) }
    }

    @discardableResult
    func setRelativeSize(_ sizeAnchor: SizeAnchor, toSizeAnchor: SizeAnchor, ofView: UIView, multiplier: CGFloat, constant: CGFloat, relation: NSLayoutRelation = .equal, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        let fromDimension = self.layoutDimensionForAnchor(size: sizeAnchor)
        let toDimension = ofView.layoutDimensionForAnchor(size: toSizeAnchor)

        let constraint: NSLayoutConstraint
        if relation == .greaterThanOrEqual {
            constraint = fromDimension.constraint(greaterThanOrEqualTo: toDimension, multiplier: multiplier, constant: constant)
        } else if relation == .lessThanOrEqual {
            constraint = fromDimension.constraint(lessThanOrEqualTo: toDimension, multiplier: multiplier, constant: constant)
        } else {
            constraint = fromDimension.constraint(equalTo: toDimension, multiplier: multiplier, constant: constant)
        }

        constraint.priority = sizeAnchor.priority
        constraint.isActive = activate

        return constraint
    }

}

public extension NSLayoutConstraint {

    static func activateAllConstraints(constraints: [[NSLayoutConstraint]]) {
        NSLayoutConstraint.activate(constraints.flatMap { $0 })
    }

    static func deactivateAllConstraints(constraints: [[NSLayoutConstraint]]) {
        NSLayoutConstraint.deactivate(constraints.flatMap { $0 })
    }

}

// MARK: Objective-C API

public extension UIView {

    @available(*, unavailable, message: "Only to be used from Objective-C") func objc_pinToView(view: UIView, inset: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        return self._objcPinToView(view: view)
    }

    @available(*, unavailable, message: "Only to be used from Objective-C") func objc_pinToSuperview(inset: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        if let superview = self.superview {
            return self._objcPinToView(view: superview, inset: inset)
        } else {
            fatalError("Cannot pin to a nil superview")
        }
    }

}

private enum TypedAnchor {
    case x(NSLayoutXAxisAnchor)
    case y(NSLayoutYAxisAnchor)
    case dimension(NSLayoutDimension)

    func constraint(equalTo anchor: TypedAnchor, constant c: CGFloat) -> NSLayoutConstraint {
        if case .x(let x) = self, case .x(let y) = anchor {
            return x.constraint(equalTo: y, constant: c)
        }

        if case .y(let x) = self, case .y(let y) = anchor {
            return x.constraint(equalTo: y, constant: c)
        }

        if case .dimension(let x) = self, case .dimension(let y) = anchor {
            return x.constraint(equalTo: y, constant: c)
        }

        fatalError("This should not happen")
    }

    func constraint(greaterThanOrEqualTo anchor: TypedAnchor, constant c: CGFloat) -> NSLayoutConstraint {
        if case .x(let x) = self, case .x(let y) = anchor {
            return x.constraint(greaterThanOrEqualTo: y, constant: c)
        }

        if case .y(let x) = self, case .y(let y) = anchor {
            return x.constraint(greaterThanOrEqualTo: y, constant: c)
        }

        if case .dimension(let x) = self, case .dimension(let y) = anchor {
            return x.constraint(greaterThanOrEqualTo: y, constant: c)
        }

        fatalError("This should not happen")
    }

    func constraint(lessThanOrEqualTo anchor: TypedAnchor, constant c: CGFloat) -> NSLayoutConstraint {
        if case .x(let x) = self, case .x(let y) = anchor {
            return x.constraint(lessThanOrEqualTo: y, constant: c)
        }

        if case .y(let x) = self, case .y(let y) = anchor {
            return x.constraint(lessThanOrEqualTo: y, constant: c)
        }

        if case .dimension(let x) = self, case .dimension(let y) = anchor {
            return x.constraint(lessThanOrEqualTo: y, constant: c)
        }

        fatalError("This should not happen")
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

    func layoutAnchor(edge: EdgeAnchor) -> TypedAnchor {
        switch edge {

        case EdgeAnchor.leading:
            return .x(self.leadingAnchor)

        case EdgeAnchor.trailing:
            return .x(self.trailingAnchor)

        case EdgeAnchor.top:
            return .y(self.topAnchor)

        case EdgeAnchor.bottom:
            return .y(self.bottomAnchor)

        case EdgeAnchor.centerX:
            return .x(self.centerXAnchor)

        case EdgeAnchor.centerY:
            return .y(self.centerYAnchor)

        case EdgeAnchor.width:
            return .dimension(self.widthAnchor)

        case EdgeAnchor.height:
            return .dimension(self.heightAnchor)

        default:
            fatalError("There is an unhandled edge case with edges. Get it? Edge case… 😂")

        }
    }


    @discardableResult
    func _objcPinToView(view: UIView, inset: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        let viewConstraints: [NSLayoutConstraint] = [
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset.left),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: inset.right),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: inset.top),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: inset.bottom),
            ]
        
        return viewConstraints
    }
    
}

private extension Array where Element: NSLayoutConstraint {
    
    func setActive(active: Bool) {
        if active {
            NSLayoutConstraint.activate(self)
        } else {
            NSLayoutConstraint.deactivate(self)
        }
    }
    
}
