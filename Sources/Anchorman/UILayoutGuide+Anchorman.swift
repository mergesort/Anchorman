import UIKit

public extension UILayoutGuide {

    /// A function that allows you to pin the current `UILayoutGuide` to another `UILayoutGuide`.
    ///
    /// - Parameters:
    ///   - layoutGuide: The `UILayoutGuide` that we are pinning the current `UILayoutGuide` to.
    ///   - edges: The `EdgeAnchor`s we wish to create `NSLayoutConstraint`s for.
    ///   - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///   - isActive: Whether or not the underlying `NSLayoutConstraint` will be active.
    /// - Returns: An `[NSLayoutConstraint]` between the current `UILayoutGuide` and another `UILayoutGuide`.
    @discardableResult
    func pin(to layoutGuide: UILayoutGuide, edges: [EdgeAnchor] = EdgeAnchor.allSides, relation: NSLayoutConstraint.Relation = .equal, isActive: Bool = true) -> [NSLayoutConstraint] {
        return self.pin(toAnchorable: layoutGuide, edges: edges, relation: relation, isActive: isActive)
    }
    
    /// A function that allows you to pin the current `UILayoutGuide` to a `UIView`.
    ///
    /// - Parameters:
    ///   - view: The `UIView` that we are pinning the current `UILayoutGuide` to.
    ///   - edges: The `EdgeAnchor`s we wish to create `NSLayoutConstraint`s for.
    ///   - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///   - isActive: Whether or not the underlying `NSLayoutConstraint` will be active.
    /// - Returns: An `[NSLayoutConstraint]` between the current `UILayoutGuide` and another `UIView`.
    @discardableResult
    func pin(to view: UIView, edges: [EdgeAnchor] = EdgeAnchor.allSides, relation: NSLayoutConstraint.Relation = .equal, isActive: Bool = true) -> [NSLayoutConstraint] {
        return self.pin(toAnchorable: view, edges: edges, relation: relation, isActive: isActive)
    }

    /// A function that allows you to pin the one edge of the current `UILayoutGuide` to another `UILayoutGuide`.
    ///
    /// - Parameters:
    ///   - edge: The `EdgeAnchor` of the current `UILayoutGuide` we wish to create an `NSLayoutConstraint` for.
    ///   - toEdge: The `EdgeAnchor` of the `UILayoutGuide` we wish to create an `NSLayoutConstraint` for.
    ///   - layoutGuide: The `UILayoutGuide` we wish to constrain the current `UILayoutGuide` to.
    ///   - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///   - constant: The constant offset between the two `UILayoutGuide`s.
    ///   - priority: The priority for the underlying `NSLayoutConstraint`. Default argument is `.required`.
    ///   - isActive: Whether or not the underlying `NSLayoutConstraint` will be active.
    /// - Returns: An `NSLayoutConstraint` between the current `UILayoutGuide` and another `UILayoutGuide`.
    @discardableResult
    func pin(edge: EdgeAnchor, toEdge: EdgeAnchor, of layoutGuide: UILayoutGuide, relation: NSLayoutConstraint.Relation = .equal, constant: CGFloat = 0.0, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        return self.pin(edge: edge, toEdge: toEdge, ofAnchorable: layoutGuide, relation: relation, constant: constant, priority: priority, isActive: isActive)
    }

    /// A function that allows you to pin the one edge of the current `UILayoutGuide` to a `UIView`.
    ///
    /// - Parameters:
    ///   - edge: The `EdgeAnchor` of the current `UILayoutGuide` we wish to create an `NSLayoutConstraint` for.
    ///   - toEdge: The `EdgeAnchor` of the `UIView` we wish to create an `NSLayoutConstraint` for.
    ///   - view: The `UIView` we wish to constrain the current `UILayoutGuide` to.
    ///   - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///   - constant: The constant for the underlying `NSLayoutConstraint`.
    ///   - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///   - isActive: Whether or not the underlying `NSLayoutConstraint` will be active.
    /// - Returns: An `NSLayoutConstraint` between the current `UILayoutGuide` and another `UIView`.
    @discardableResult
    func pin(edge: EdgeAnchor, toEdge: EdgeAnchor, of view: UIView, relation: NSLayoutConstraint.Relation = .equal, constant: CGFloat = 0.0, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        return self.pin(edge: edge, toEdge: toEdge, ofAnchorable: view, relation: relation, constant: constant, priority: priority, isActive: isActive)
    }

    /// A function that allows you to pin the one dimension of the current `UILayoutGuide` to another `UILayoutGuide`.
    ///
    /// - Parameters:
    ///   - sizeAnchor: The `SizeAnchor` of the current `UILayoutGuide` we wish to create an `NSLayoutConstraint` for.
    ///   - toSizeAnchor: The `SizeAnchor` of the other `UILayoutGuide` we wish to create an `NSLayoutConstraint` for.
    ///   - layoutGuide: The `UILayoutGuide` we wish to constrain the current `UILayoutGuide` to.
    ///   - multiplier: The multiplier for the underlying `NSLayoutConstraint`.
    ///   - constant: The constant for the underlying `NSLayoutConstraint`.
    ///   - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///   - isActive: Whether or not the underlying `NSLayoutConstraint` will be active.
    /// - Returns: An `NSLayoutConstraint` between the current `UILayoutGuide` and another `UIView`.
    @discardableResult
    func set(relativeSize sizeAnchor: SizeAnchor, toSizeAnchor: SizeAnchor, of layoutGuide: UILayoutGuide, multiplier: CGFloat, constant: CGFloat, relation: NSLayoutConstraint.Relation, isActive: Bool) -> NSLayoutConstraint {
        return self.set(relativeSize: sizeAnchor, toSizeAnchor: toSizeAnchor, ofAnchorable: layoutGuide, multiplier: multiplier, constant: constant, relation: relation, isActive: isActive)
    }

    /// A function that allows you to pin the one dimension of the current `UILayoutGuide` to another `UIView`.
    ///
    /// - Parameters:
    ///   - sizeAnchor: The `SizeAnchor` of the current `UILayoutGuide` we wish to create an `NSLayoutConstraint` for.
    ///   - toSizeAnchor: The `SizeAnchor` of the other `UILayoutGuide` we wish to create an `NSLayoutConstraint` for.
    ///   - view: The `UIView` we wish to constrain the current `UILayoutGuide` to.
    ///   - multiplier: The multiplier for the underlying `NSLayoutConstraint`.
    ///   - constant: The constant for the underlying `NSLayoutConstraint`.
    ///   - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///   - isActive: Whether or not the underlying `NSLayoutConstraint` will be active.
    /// - Returns: An `NSLayoutConstraint` between the current `UILayoutGuide` and another `UIView`.
    @discardableResult
    func set(relativeSize sizeAnchor: SizeAnchor, toSizeAnchor: SizeAnchor, of view: UIView, multiplier: CGFloat, constant: CGFloat, relation: NSLayoutConstraint.Relation, isActive: Bool) -> NSLayoutConstraint {
        return self.set(relativeSize: sizeAnchor, toSizeAnchor: toSizeAnchor, ofAnchorable: view, multiplier: multiplier, constant: constant, relation: relation, isActive: isActive)
    }
}
