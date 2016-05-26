# Anchorman

#### Do you think autolayout has to be hard?

![That doesn't make any sense](https://github.com/mergesort/anchorman/blob/master/gifs/doesnt_make_sense.gif)

Nah. NSLayoutAnchor is pretty neat! But it's still a bit tedious of an API. Try writing `setTranslatesAutoResizingMasks = true` and `.active = true` 10 times over. But we can make it a bit easier with a *very* thin layer of abstraction.

![I don't know what we're yelling about!](https://github.com/mergesort/anchorman/blob/master/gifs/yelling.gif)

### How about I show you?

I am a cool developer, making a cool app. It has so many views. I want to pin my view to it's superview.

```
myView.pinToSuperview()
```

That was easy, but I don't want to pin to a superview anymore, I want to pin to a button.

```
myView.pinToView(someCoolerButton)
```

Ah, ok. Easy enough… How about pinning my label to the left and right side of it's superview… and with insets… and center it in my view.

```
MYCAPITALIZEDLABEL.pinToSuperview([ .leading,(10.0) .trailing(10.0), .centerX, .centerY ])
```

Whoa, that was neat! You can specify a group of edges you want to pin to, and their offsets. Swift enums are the best!

![That escalated quickly](https://github.com/mergesort/anchorman/blob/master/gifs/escalated_quickly.gif)

And of course, you can pick one edge to pin to:

```
myImportantLabel.pinEdge(.top, toEdge: .bottom, ofView: myGreatSearchBar, constant: 10.0)
```

Last but not least, set constant values for your 
constraints. For width, height, or both.

```
myView.setSize([ .width(44.0), .height(44.0) ])
```

That's all I got! But who are you stranger?

![I'm Ron Burgundy](https://github.com/mergesort/anchorman/blob/master/gifs/im_ron_burgundy.gif)

Hi, I'm Joe! [@mergesort](http://fabisevi.ch) everywhere on the web, but especially on [Twitter](https://twitter.com/mergesort).

Hopefully Anchorman is your cup of tea, it's the kind of autolayout library I'd want to use. And with that, good night San Diego.

![Stay Classy San Diego](https://github.com/mergesort/anchorman/blob/master/gifs/stay_classy.gif)