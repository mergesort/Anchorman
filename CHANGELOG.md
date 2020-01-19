# Change Log

# 3.2.0 (2020-01-19)

- Adding support for Swift 5.1.
- Cleaning up redundant public access level warnings.

# 3.1 (2018-12-24)

- Adding support for Swift 4.2.

# 3.0 (2017-09-11)

- The underlying framework is completely rewritten. If you find any bugs, please report them. 🐛

- This version is written in and supports Swift 4. If you need to use Swift 3, use version 2.0 of Anchorman instead.

---

#### New Features

- Anchorman now supports `UILayoutGuide` along with `UIView` constraints.

- Adding support for `.left` and `.right` `EdgeAnchor`s.

--- 
#### ⚠️ Breaking changes ⚠️

- Removed `func translateAutoresizingMasks(on: Bool)`

- Removed `static func activateAllConstraints(constraints: [[NSLayoutConstraint]])`

- Removed `static func deactivateAllConstraints(constraints: [[NSLayoutConstraint]])`

- For functions that had a parameter `activate: Bool`, it has now been renamed `isActive: Bool`.

### API changes for pinning

~~`func pinToSuperview(_ edges: [EdgeAnchor], relation: NSLayoutRelation, activate: Bool) -> [NSLayoutConstraint]`~~

`func pinToSuperview(_ edges: [EdgeAnchor], relation: NSLayoutRelation, isActive: Bool) -> [NSLayoutConstraint]`

---

~~`func pin(toView view: UIView, edges: [EdgeAnchor], relation: NSLayoutRelation, activate: Bool) -> [NSLayoutConstraint]`~~

`func pin(to view: UIView, edges: [EdgeAnchor], relation: NSLayoutRelation, isActive: Bool) -> [NSLayoutConstraint]`

---

~~`func pin(edge: EdgeAnchor, toEdge: EdgeAnchor, ofView view: UIView, relation: NSLayoutRelation, constant: CGFloat, priority: UILayoutPriority, activate: Bool) -> NSLayoutConstraint`~~

`func pin(edge: EdgeAnchor, toEdge: EdgeAnchor, of view: UIView, relation: NSLayoutRelation = .equal, constant: CGFloat, priority: UILayoutPriority, isActive: Bool) -> NSLayoutConstraint`

---

~~`func set(size sizeAnchor: SizeAnchor, relation: NSLayoutRelation, activate: Bool) -> NSLayoutConstraint`~~

`func set(size sizeAnchor: SizeAnchor, relation: NSLayoutRelation, isActive: Bool) -> NSLayoutConstraint`

---

~~`func set(size sizeAnchors: [SizeAnchor] = [ SizeAnchor.width, SizeAnchor.height ], relation: NSLayoutRelation, activate: Bool) -> [NSLayoutConstraint]`~~

`func set(size sizeAnchors: [SizeAnchor] = [ SizeAnchor.width, SizeAnchor.height ], relation: NSLayoutRelation, isActive: Bool) -> [NSLayoutConstraint]`

---

~~`func set(relativeSize sizeAnchor: SizeAnchor, toSizeAnchor: SizeAnchor, ofView view: UIView, multiplier: CGFloat, constant: CGFloat, relation: NSLayoutRelation, activate: Bool) -> NSLayoutConstraint`~~

`func set(relativeSize sizeAnchor: SizeAnchor, toSizeAnchor: SizeAnchor, ofAnchorable anchorable: Anchorable, multiplier: CGFloat, constant: CGFloat, relation: NSLayoutRelation, isActive: Bool)`

# 2.0 (2016-12-03)

### This release is a completely breaking change to the API.

- The library is now compatible with Swift 3 only. The previous release will continue to work with Swift 2.2.

# 1.2.1 (2016-10-04)

- Fixes a bug that set `self.translatesAutoresizingMaskIntoConstraints = false` onto the view being pinned to, which is bad when the view is `self.view`.


# 1.2 (2016-10-04)

#### This version supports Swift 3, but not 2.2 or 2.3.

- Your code that compiled for Swift 2.2 or 2.3 should not change, and remains compatible. A future update will add Swift 3 naming conventions into the code.

- Brings the library support to 3.0.
- Code clean up.


# 1.1.2 (2016-07-16)

#### This version supports Swift 2.2 and 2.3, but not 3.

- Removing an unused variable. ¯\\_(ツ)_/¯


# 1.1.1 (2016-07-06)

- Adding `setRelativeSize` for multiplier support.
- Fixing uncaught EdgeAnchors.

# 1.1 (2016-06-24)

- `setSize` now overloads allowing to take in either a `SizeAnchor`, or `[SizeAnchor]`, depending on the parameter passed in, returning `NSLayoutConstraint` and `[NSLayoutConstraint]` respectively.

- Breaking change: `.allEdges` has been renamed to `.allSides`, since those semantics are representative of pinning a view's `.leading`, `.trailing`, `.top`, and `.bottom` edges.


# 1.0.1 (2016-06-03)

Adding support for NSLayoutRelations, `.Equal`, `.GreaterThanOrEqual`, and `.LessThanOrEqual`.

# 1.0 (2016-05-26)

- Updating podspec to be iOS 9+.
