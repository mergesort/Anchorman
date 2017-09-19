import UIKit

/// A protocol for anything that provides a set `NSLayoutAnchor`s found in `UIView` and `UILayoutGuide`.
public protocol Anchorable {
    
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
}

extension UIView: Anchorable {}

extension UILayoutGuide: Anchorable {}

public extension Anchorable {
   
    /// A function that allows you to add a `SizeAnchor` to an `Anchorable`.
    ///
    /// - Parameters:
    ///   - sizeAnchor: The `SizeAnchor` we want to add to an `Anchorable`.
    ///   - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///   - isActive: Whether or not the underlying `NSLayoutConstraint` will be active.
    /// - Returns: An `NSLayoutConstraint` between the current `Anchorable` and another `Anchorable`.
    @discardableResult
    func set(size sizeAnchor: SizeAnchor, relation: NSLayoutRelation = .equal, isActive: Bool = true) -> NSLayoutConstraint {
        let currentDimension = sizeAnchor.layoutDimensionForAnchorable(anchorable: self)
        
        let constraint: NSLayoutConstraint
        if relation == .greaterThanOrEqual {
            constraint = currentDimension.constraint(greaterThanOrEqualToConstant: sizeAnchor.constant)
        } else if relation == .lessThanOrEqual {
            constraint = currentDimension.constraint(lessThanOrEqualToConstant: sizeAnchor.constant)
        } else {
            constraint = currentDimension.constraint(equalToConstant: sizeAnchor.constant)
        }
        
        constraint.priority = sizeAnchor.priority
        constraint.isActive = isActive
        
        return constraint
    }
    
    /// A function that allows you to add a `[SizeAnchor]` to an `Anchorable`.
    ///
    /// - Parameters:
    ///   - sizeAnchors: The `[SizeAnchor]` we want to add to an `Anchorable`.
    ///   - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///   - isActive: Whether or not the underlying `NSLayoutConstraint` will be active.
    /// - Returns: An `[NSLayoutConstraint]` between the current `Anchorable` and another `Anchorable`.
    @discardableResult
    func set(size sizeAnchors: [SizeAnchor] = [ SizeAnchor.width, SizeAnchor.height ], relation: NSLayoutRelation = .equal, isActive: Bool = true) -> [NSLayoutConstraint] {
        return sizeAnchors.map { return self.set(size: $0, relation: relation, isActive: isActive) }
    }

}

extension Anchorable {
    
    /// A function that allows you to pin one `Anchorable` to another `Anchorable`.
    ///
    /// - Parameters:
    ///   - anchorable: The `Anchorable` to pin the current `Anchorable` to.
    ///   - edges: The `EdgeAnchor`s we wish to create `NSLayoutConstraint`s for.
    ///   - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///   - isActive: Whether or not the underlying `NSLayoutConstraint` will be active.
    /// - Returns: An `[NSLayoutConstraint]` between the current `Anchorable` and another `Anchorable`.
    @discardableResult
    func pin(toAnchorable anchorable: Anchorable, edges: [EdgeAnchor] = EdgeAnchor.allSides, relation: NSLayoutRelation = .equal, isActive: Bool = true) -> [NSLayoutConstraint] {

        func addConstraint(edge: EdgeAnchor) -> NSLayoutConstraint? {
            guard edges.contains(edge) else {
                return nil
            }
            
            let constant: CGFloat
            let priority: UILayoutPriority
            
            if let index = edges.index(of: edge) {
                let currentEdge = edges[index]
                constant = currentEdge.constant
                priority = currentEdge.priority
            } else {
                constant = 0.0
                priority = .required
            }
            
            let currentAnchor = edge.layoutAnchorForAnchorable(anchorable: self)
            let viewAnchor = edge.layoutAnchorForAnchorable(anchorable: anchorable)
            
            let constraint: NSLayoutConstraint
            if relation == .greaterThanOrEqual {
                constraint = currentAnchor.constraint(greaterThanOrEqualTo: viewAnchor, constant: constant)
            } else if relation == .lessThanOrEqual {
                constraint = currentAnchor.constraint(lessThanOrEqualTo: viewAnchor, constant: constant)
            } else {
                constraint = currentAnchor.constraint(equalTo: viewAnchor, constant: constant)
            }
            
            constraint.priority = priority
            return constraint
        }
        
        let leadingConstraint = addConstraint(edge: .leading)
        let trailingConstraint = addConstraint(edge: .trailing)
        let topConstraint = addConstraint(edge: .top)
        let bottomConstraint = addConstraint(edge: .bottom)
        let centerXConstraint = addConstraint(edge: .centerX)
        let centerYConstraint = addConstraint(edge: .centerY)
        let widthConstraint = addConstraint(edge: .width)
        let heightConstraint = addConstraint(edge: .height)
        
        let viewConstraints = [ leadingConstraint, trailingConstraint, topConstraint, bottomConstraint, centerXConstraint, centerYConstraint, widthConstraint, heightConstraint ].flatMap { $0 }
        viewConstraints.forEach { $0.isActive = isActive }
        
        return viewConstraints
    }
    
    /// A function that allows you to pin one `Anchorable` to another `Anchorable`.
    ///
    /// - Parameters:
    /// - Parameters:
    ///   - edge: The `EdgeAnchor` of the current `Anchorable` we wish to create an `NSLayoutConstraint` for.
    ///   - toEdge: The `EdgeAnchor` of the `Anchorable` we wish to create an `NSLayoutConstraint` for.
    ///   - anchorable: The `Anchorable` to pin the current `Anchorable` to.
    ///   - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///   - constant: The constant for the underlying `NSLayoutConstraint`.
    ///   - priority: The priority for the underlying `NSLayoutConstraint`. Default argument is `.required`.
    ///   - isActive: Whether or not the underlying `NSLayoutConstraint` will be active.
    /// - Returns: An `NSLayoutConstraint` between the current `Anchorable` and another `Anchorable`.
    @discardableResult
    func pin(edge: EdgeAnchor, toEdge: EdgeAnchor, ofAnchorable anchorable: Anchorable, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        
        let fromAnchor = edge.layoutAnchorForAnchorable(anchorable: self)
        let toAnchor = toEdge.layoutAnchorForAnchorable(anchorable: anchorable)
        
        let constraint: NSLayoutConstraint
        if relation == .greaterThanOrEqual {
            constraint = fromAnchor.constraint(greaterThanOrEqualTo: toAnchor, constant: constant)
        } else if relation == .lessThanOrEqual {
            constraint = fromAnchor.constraint(lessThanOrEqualTo: toAnchor, constant: constant)
        } else {
            constraint = fromAnchor.constraint(equalTo: toAnchor, constant: constant)
        }
        
        constraint.priority = priority
        constraint.isActive = isActive
        
        return constraint
    }

    /// A function that allows you to pin one `Anchorable` to another `Anchorable`.
    ///
    /// - Parameters:
    ///   - sizeAnchor: The `SizeAnchor` of the current `Anchorable` we wish to create an `NSLayoutConstraint` for.
    ///   - toSizeAnchor: The `SizeAnchor` of the `Anchorable` we wish to create an `NSLayoutConstraint` for.
    ///   - anchorable: The `Anchorable` to pin the current `Anchorable` to.
    ///   - multiplier: The multiplier for the underlying `NSLayoutConstraint`.
    ///   - constant: The constant for the underlying `NSLayoutConstraint`.
    ///   - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///   - isActive: Whether or not the underlying `NSLayoutConstraint` will be active.
    /// - Returns: An `NSLayoutConstraint` between the current `Anchorable` and another `Anchorable`.
    @discardableResult
    func set(relativeSize sizeAnchor: SizeAnchor, toSizeAnchor: SizeAnchor, ofAnchorable anchorable: Anchorable, multiplier: CGFloat, constant: CGFloat, relation: NSLayoutRelation = .equal, isActive: Bool = true) -> NSLayoutConstraint {
        let fromDimension = sizeAnchor.layoutDimensionForAnchorable(anchorable: self)
        let toDimension = toSizeAnchor.layoutDimensionForAnchorable(anchorable: anchorable)
        
        let constraint: NSLayoutConstraint
        if relation == .greaterThanOrEqual {
            constraint = fromDimension.constraint(greaterThanOrEqualTo: toDimension, multiplier: multiplier, constant: constant)
        } else if relation == .lessThanOrEqual {
            constraint = fromDimension.constraint(lessThanOrEqualTo: toDimension, multiplier: multiplier, constant: constant)
        } else {
            constraint = fromDimension.constraint(equalTo: toDimension, multiplier: multiplier, constant: constant)
        }
        
        constraint.priority = sizeAnchor.priority
        constraint.isActive = isActive
        
        return constraint
    }

}

private extension EdgeAnchor {
    
    func layoutAnchorForAnchorable(anchorable: Anchorable) -> TypedAnchor {
        switch self {
            
        case EdgeAnchor.leading:
            return .x(anchorable.leadingAnchor)
            
        case EdgeAnchor.trailing:
            return .x(anchorable.trailingAnchor)
            
        case EdgeAnchor.top:
            return .y(anchorable.topAnchor)
            
        case EdgeAnchor.bottom:
            return .y(anchorable.bottomAnchor)
            
        case EdgeAnchor.centerX:
            return .x(anchorable.centerXAnchor)
            
        case EdgeAnchor.centerY:
            return .y(anchorable.centerYAnchor)
            
        case EdgeAnchor.width:
            return .dimension(anchorable.widthAnchor)
            
        case EdgeAnchor.height:
            return .dimension(anchorable.heightAnchor)
            
        default:
            fatalError("There is an unhandled edge case with edges. Get it? Edge case… 😂")
            
        }
    }
}

private extension SizeAnchor {
    
    func layoutDimensionForAnchorable(anchorable: Anchorable) -> NSLayoutDimension {
        switch self {
            
        case SizeAnchor.width:
            return anchorable.widthAnchor
            
        case SizeAnchor.height:
            return anchorable.heightAnchor
            
        default:
            fatalError("There is an unhandled size. Have you considered inventing another dimension? 📐")
            
        }
    }
}

/// A typed anchor allows for creating only valid constraints along the same axis or dimension.
/// We want to prevent you from being able to pin a `.top` anchor to a `.leading`, since that is
/// an invalid combination.
///
/// - x: Anchors that are typed as `NSLayoutXAxisAnchor`.
/// - y: Anchors that are typed as `NSLayoutYAxisAnchor`.
/// - dimension: Anchors that are typed as `NSLayoutDimension`.
private enum TypedAnchor {
    
    case x(NSLayoutXAxisAnchor)
    case y(NSLayoutYAxisAnchor)
    case dimension(NSLayoutDimension)
    
    func constraint(equalTo anchor: TypedAnchor, constant: CGFloat) -> NSLayoutConstraint {
        switch (self, anchor) {
            
        case let (.x(fromConstraint), .x(toConstraint)):
            return fromConstraint.constraint(equalTo: toConstraint, constant: constant)
            
        case let(.y(fromConstraint), .y(toConstraint)):
            return fromConstraint.constraint(equalTo: toConstraint, constant: constant)
            
        case let(.dimension(fromConstraint), .dimension(toConstraint)):
            return fromConstraint.constraint(equalTo: toConstraint, constant: constant)
            
        default:
            fatalError("I feel so constrainted, not cool! 🤐")
            
        }
    }
    
    func constraint(greaterThanOrEqualTo anchor: TypedAnchor, constant: CGFloat) -> NSLayoutConstraint {
        switch (self, anchor) {
            
        case let (.x(fromConstraint), .x(toConstraint)):
            return fromConstraint.constraint(greaterThanOrEqualTo: toConstraint, constant: constant)
            
        case let(.y(fromConstraint), .y(toConstraint)):
            return fromConstraint.constraint(greaterThanOrEqualTo: toConstraint, constant: constant)
            
        case let(.dimension(fromConstraint), .dimension(toConstraint)):
            return fromConstraint.constraint(greaterThanOrEqualTo: toConstraint, constant: constant)
            
        default:
            fatalError("I feel so constrainted, not cool! 🤐")
            
        }
    }
    
    func constraint(lessThanOrEqualTo anchor: TypedAnchor, constant: CGFloat) -> NSLayoutConstraint {
        switch (self, anchor) {
            
        case let (.x(fromConstraint), .x(toConstraint)):
            return fromConstraint.constraint(lessThanOrEqualTo: toConstraint, constant: constant)
            
        case let(.y(fromConstraint), .y(toConstraint)):
            return fromConstraint.constraint(lessThanOrEqualTo: toConstraint, constant: constant)
            
        case let(.dimension(fromConstraint), .dimension(toConstraint)):
            return fromConstraint.constraint(lessThanOrEqualTo: toConstraint, constant: constant)
            
        default:
            fatalError("I feel so constrainted, not cool! 🤐")
            
        }
    }
    
}
