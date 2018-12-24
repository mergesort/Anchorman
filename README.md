# Anchorman

[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=59a836506532420001f89b3b&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/59a836506532420001f89b3b/build/latest?branch=master) 
[![Pod Version](https://img.shields.io/badge/Pod-3.1-6193DF.svg)](https://cocoapods.org/)
![Swift Version](https://img.shields.io/badge/Swift-4.2-brightgreen.svg)
![License MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg) 
![Plaform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)

### Do you think autolayout has to be hard?

![That doesn't make any sense](gifs/doesnt_make_sense.gif)

Nah. `NSLayoutAnchor` is pretty neat! But it's still a bit tedious of an API. Try writing `.translatesAutoresizingMaskIntoConstraints = false` and `.isActive = true` 10 times over. But we can make it a bit easier with a *very* thin layer of abstraction.

![I don't know what we're yelling about!](gifs/yelling.gif)

### Let's start off with a vocabulary lesson.
---

`UIView` and `UILayoutGuide` are `Anchorable`. You can pin one to the other, in any combination you like, as long as it generates valid `NSLayoutConstraint`s.

### How's it work?
---

I am a cool developer, making a cool app. It has so many views. I want to pin my view to it's superview.

```swift
self.backgroundView.pinToSuperview()
```

That was easy, but I don't want to pin to a superview anymore, I want to pin to another view.

```swift
self.messageLabel.pin(to: self.backgroundView)
```

Ah, ok. Easy enough… How about pinning my label to the left and right side of it's superview… and with insets… and center it in my view.

```swift
self.titleLabel.pinToSuperview([ .leading(10.0), .trailing(10.0), .centerY ])
```

Whoa, that was neat! You can specify a group of edges you want to pin to, and their offsets. Swift enums are the best!

![That escalated quickly](gifs/escalated_quickly.gif)

And of course, you can pick one edge to pin to another edge.

```swift
self.footerLabel.pin(edge: .bottom, toEdge: .bottom, of: self.view.safeAreaLayoutGuide, constant: 10.0)
```

Last but not least, set constant values for your 
constraints. For width, height, or both.

```swift
self.footerLabel.set(size: .width(44.0) ])
self.titleLabel.set(size: [ .width(44.0), .height(44.0) ])
```

I lied, there's a bit more. Anchorman includes a couple of goodies to make your life easier between iOS 10 and iOS 11.

```swift
var backwardsCompatibleSafeAreaLayoutGuide: UILayoutGuide 
var backwardsCompatibleSafeAreaInsets: UIEdgeInsets 
```

These will use `safeAreaLayoutGuide` and `safeAreaInsets` on iOS 11, and `layoutMarginsGuide` and `layoutMargins` on iOS 10, so you can avoid a whole bunch of `if #available` conditions.

## Installation
Anchorman supports Swift 4 with the latest versions. If you're looking for Swift 3 support, use [version 2.0](https://github.com/mergesort/Anchorman/releases/tag/2.0)

You can use CocoaPods to install Anchorman by adding it to your Podfile:

```ruby
platform :ios, '8.0'
use_frameworks!

pod 'Anchorman'
```

Or Carthage

```swift
github "mergesort/Anchorman"
```

Or install it the old fashioned way by downloading `Anchorman.swift` and dropping it in your project.

## About me

![I'm Ron Burgundy](gifs/im_ron_burgundy.gif)

Hi, I'm Joe! [@mergesort](http://fabisevi.ch) everywhere on the web, but especially on [Twitter](https://twitter.com/mergesort).

## License

See the [license](LICENSE) for more information about how you can use Anchorman. I promise it's not GPL, because I am not "that guy".

## Fin

Hopefully Anchorman is your cup of tea, it's the kind of autolayout library I'd want to use. And with that, good night San Diego.

![Stay Classy San Diego](gifs/stay_classy.gif)
