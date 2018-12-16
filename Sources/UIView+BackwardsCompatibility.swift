import UIKit

// MARK: Objective-C API

public extension UIView {
    
    /// A function that allows you to pin one view to another.
    ///
    /// - Parameters:
    ///   - view: The other view for the current view to be pinned to.
    ///   - inset: The inset to pin the view with. Keep in mind that the values only support LTR,
    ///            so they would be backwards on RTL languages.
    /// - Returns: The `[NSLayoutConstraints]` that result between the two `UIView`s.
    @available(*, unavailable, message: "Only to be used from Objective-C")
    func pinToView(view: UIView, inset: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        return self._objcPinToView(view: view)
    }
    
    /// A function that allows you to pin one view to it's superview.
    ///
    /// - Parameter inset: The inset to pin the view with. Keep in mind that the values
    ///             only support LTR, so they would be backwards on RTL languages.
    /// - Returns: The `[NSLayoutConstraints]` that result between the two `UIView`s.
    @available(*, unavailable, message: "Only to be used from Objective-C")
    func pinToSuperview(inset: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            fatalError("Cannot pin to a nil superview. You should fix that. 🛠")
        }
        
        return self._objcPinToView(view: superview, inset: inset)
    }
    
}

private extension UIView {

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

public extension UIView {
    
    /// A `UILayoutGuide` that on iOS 11 returns the `safeAreaLayoutGuide`
    /// and on iOS 10 returns the `layoutMarginsGuide`.
    var backwardsCompatibleSafeAreaLayoutGuide: UILayoutGuide {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide
        } else {
            return self.layoutMarginsGuide
        }
    }
    
    /// A `UIEdgeInsets` that on iOS 11 returns the `safeAreaInsets`
    /// and on iOS 10 returns the `layoutMargins`.
    var backwardsCompatibleSafeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets
        } else {
            return self.layoutMargins
        }
    }
}
