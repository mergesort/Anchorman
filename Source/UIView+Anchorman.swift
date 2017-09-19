import UIKit

public extension UIView {

    /// A function that allows you to pin the current `UIView` to another `UIView`.
    ///
    /// - Parameters:
    ///   - view: The `UIView` that we will constrain the current `UIView` to.
    ///   - edges: The `EdgeAnchor`s we wish to create `NSLayoutConstraint`s for.
    ///   - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///   - isActive: Whether or not the underlying `NSLayoutConstraint` will be active.
    /// - Returns: An `[NSLayoutConstraint]` between the current `UIView` and another `UIView`.
    @discardableResult
    func pin(to view: UIView, edges: [EdgeAnchor] = EdgeAnchor.allSides, relation: NSLayoutRelation = .equal, isActive: Bool = true) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self.pin(toAnchorable: view, edges: edges, relation: relation, isActive: isActive)
    }

    /// A function that allows you to pin the current `UIView` to a `UILayoutGuide`.
    ///
    /// - Parameters:
    ///   - layoutGuide: The `UILayoutGuide` that we will constrain the current `UIView` to.
    ///   - edges: The `EdgeAnchor`s we wish to create `NSLayoutConstraint`s for.
    ///   - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///   - isActive: Whether or not the underlying `NSLayoutConstraint` will be active.
    /// - Returns: An `[NSLayoutConstraint]` between the current `UIView` and a `UILayoutGuide`.
    @discardableResult
    func pin(to layoutGuide: UILayoutGuide, edges: [EdgeAnchor] = EdgeAnchor.allSides, relation: NSLayoutRelation = .equal, isActive: Bool = true) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        return self.pin(toAnchorable: layoutGuide, edges: edges, relation: relation, isActive: isActive)
    }

    /// A function that allows you to pin the current `UIView` to a `UIView`.
    ///
    /// - Parameters:
    ///   - edge: The `EdgeAnchor` of the current `UIView` we wish to create an `NSLayoutConstraint` for.
    ///   - toEdge: The `EdgeAnchor` of the `UIView` we wish to create an `NSLayoutConstraint` for.
    ///   - view: The `UIView` that we will constrain the current `UIView` to.
    ///   - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///   - constant: The constant for the underlying `NSLayoutConstraint`.
    ///   - priority: The priority for the underlying `NSLayoutConstraint`. Default argument is `.required`.
    ///   - isActive: Whether or not the underlying `NSLayoutConstraint` will be active.
    /// - Returns: An `NSLayoutConstraint` between the current `UIView`'s `EdgeAnchor` and another `UIView`'s `EdgeAnchor`.
    @discardableResult
    func pin(edge: EdgeAnchor, toEdge: EdgeAnchor, ofView view: UIView, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        return self.pin(edge: edge, toEdge: toEdge, ofAnchorable: view, relation: relation, constant: constant, priority: priority, isActive: isActive)
    }
    
    /// A function that allows you to pin edges from the current `UIView` to it's superview.
    ///
    /// - Parameters:
    ///   - edge: The `EdgeAnchor` of the current `UIView` we wish to create an `NSLayoutConstraint` for.
    ///   - toEdge: The `EdgeAnchor` of the `UILayoutGuide` we wish to create an `NSLayoutConstraint` for.
    ///   - layoutGuide: The `UILayoutGuide` that we will constrain the current `UIView` to.
    ///   - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///   - constant: The constant for the underlying `NSLayoutConstraint`.
    ///   - priority: The priority for the underlying `NSLayoutConstraint`. Default argument is `.required`.
    ///   - isActive: Whether or not the underlying `NSLayoutConstraint` will be active.
    /// - Returns: An `NSLayoutConstraint` between the current `UIView`'s `EdgeAnchor` and another `UILayoutGuide`'s `EdgeAnchor`.
    @discardableResult
    func pin(edge: EdgeAnchor, toEdge: EdgeAnchor, ofLayoutGuide layoutGuide: UILayoutGuide, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        return self.pin(edge: edge, toEdge: toEdge, ofAnchorable: layoutGuide, relation: relation, constant: constant, priority: priority, isActive: isActive)
    }

    /// A function that allows you to pin edges from the current `UIView` to it's superview.
    ///
    /// - Parameters:
    ///   - edges: The `EdgeAnchor`s we wish to create `NSLayoutConstraint`s for.
    ///   - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///   - isActive: Whether or not the underlying `NSLayoutConstraint` will be active.
    /// - Returns: An `[NSLayoutConstraint]` between the current `UIView` and it's superview.
    @discardableResult
    func pinToSuperview(_ edges: [EdgeAnchor] = EdgeAnchor.allSides, relation: NSLayoutRelation = .equal, isActive: Bool = true) -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            fatalError("Cannot pin to a nil superview")
        }

        return self.pin(to: superview, edges: edges, isActive: isActive)
    }

    /// A function that allows you to pin the one dimension of the current `UIView` to another `UIView`.
    ///
    /// - Parameters:
    ///   - sizeAnchor: The `SizeAnchor` of the current `UIView` we wish to create an `NSLayoutConstraint` for.
    ///   - toSizeAnchor: The `SizeAnchor` of the other `UIView` we wish to create an `NSLayoutConstraint` for.
    ///   - view: The `UIView` that we will constrain the current `UIView` to.
    ///   - multiplier: The multiplier for the underlying `NSLayoutConstraint`.
    ///   - constant: The constant for the underlying `NSLayoutConstraint`.
    ///   - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///   - isActive: Whether or not the underlying `NSLayoutConstraint` will be active.
    /// - Returns: An `NSLayoutConstraint` between the current `UIView`'s `SizeAnchor` and another `UILayoutGuide`'s `SizeAnchor`.
    @discardableResult
    func set(relativeSize sizeAnchor: SizeAnchor, toSizeAnchor: SizeAnchor, ofView view: UIView, multiplier: CGFloat, constant: CGFloat, relation: NSLayoutRelation = .equal, isActive: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        return self.set(relativeSize: sizeAnchor, toSizeAnchor: toSizeAnchor, ofAnchorable: view, multiplier: multiplier, constant: constant, relation: relation, isActive: isActive)
    }

    /// A function that allows you to pin the one dimension of the current `UIView` to another `UILayoutGuide`.
    ///
    /// - Parameters:
    ///   - sizeAnchor: The `SizeAnchor` of the current `UIView` we wish to create an `NSLayoutConstraint` for.
    ///   - toSizeAnchor: The `SizeAnchor` of the other `UIView` we wish to create an `NSLayoutConstraint` for.
    ///   - layoutGuide: The `UILayoutGuide` that we will constrain the current `UIView` to.
    ///   - multiplier: The multiplier for the underlying `NSLayoutConstraint`.
    ///   - constant: The constant for the underlying `NSLayoutConstraint`.
    ///   - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///   - isActive: Whether or not the underlying `NSLayoutConstraint` will be active.
    /// - Returns: An `NSLayoutConstraint` between the current `UIView`'s `SizeAnchor` and another `UILayoutGuide`'s `SizeAnchor`.
    @discardableResult
    func set(relativeSize sizeAnchor: SizeAnchor, toSizeAnchor: SizeAnchor, ofLayoutGuide layoutGuide: UILayoutGuide, multiplier: CGFloat, constant: CGFloat, relation: NSLayoutRelation = .equal, isActive: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        return self.set(relativeSize: sizeAnchor, toSizeAnchor: toSizeAnchor, ofAnchorable: layoutGuide, multiplier: multiplier, constant: constant, relation: relation, isActive: isActive)
    }

}
