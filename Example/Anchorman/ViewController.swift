import UIKit

class ViewController: UIViewController {

    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        return view
    }()
    
    let pinkLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 1, green: 0.4196078431, blue: 0.4196078431, alpha: 1)
        label.text = "I'm pink but I've always wanted to be red"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    let greenLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0, green: 0.336333222, blue: 0.7391359786, alpha: 1)
        label.text = "I'm blue if I was green I would die"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()

    let messageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        label.text = "I like setting custom messages.\nBelow the status bar is a good place."
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()

    // Please don't ever actually lay something out like this
    let statusBarBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)

        return view
    }()

    let footerLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0, green: 0.6619170308, blue: 0, alpha: 1)
        label.text = "Doesn't this look like a banner ad?"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

}

private extension ViewController {
    
    func setup() {
        // This part is unexciting, we're just adding all the subviews. The real meat is below.
        self.view.addSubview(self.backgroundView)
        self.backgroundView.addSubview(self.statusBarBackgroundView)
        self.backgroundView.addSubview(self.messageLabel)
        self.backgroundView.addSubview(self.footerLabel)
        self.backgroundView.addSubview(self.pinkLabel)
        self.backgroundView.addSubview(self.greenLabel)
        
        // This is us calling the meat.
        self.setupConstraints()
    }
    
    func setupConstraints() {
        // You can pin all the edges from one view to it's superview.
        self.backgroundView.pinToSuperview()

        // You can pin specific edges of any view to any other view, in this case the superview.
        self.statusBarBackgroundView.pinToSuperview([.leading, .trailing, .top])

        self.messageLabel.pinToSuperview([.leading, .trailing])

        // You can pin a `UIView` to a `UILayoutGuide`, and vice versa.
        self.messageLabel.pin(to: self.view.safeAreaLayoutGuide, edges: [.top])

        // You can set sizes to be constants… Please don't set a status bar background like this ever.
        self.statusBarBackgroundView.set(size: .height(20.0))

        self.footerLabel.pin(to: self.view.safeAreaLayoutGuide, edges: [.bottom, .centerX])

        // You can set `SizeAnchor` to be relative to another `SizeAnchor`. In this case the `footerLabel`
        // will be as wide as the `statusBarBackgroundView` with an inset of 20 pixels.
        self.footerLabel.set(relativeSize: .width, toSizeAnchor: .width, ofView: self.statusBarBackgroundView, multiplier: 1.0, constant: -20.0)

        self.footerLabel.set(size: .height(44.0))

        // Or you can choose to pin specific `EdgeAnchor`s to a superview, or any view in fact.
        self.pinkLabel.pinToSuperview([.centerX, .centerY])

        // You can also set `NSLayoutRelation`s on any constraint as optional parameters.
        // They default to `.equal` if not set.
        // You can also choose to activate the constraint by default or not. This defaults to `true`.
        self.pinkLabel.set(size: [.width(200.0), .height(80.0)], relation: .lessThanOrEqual, isActive: true)

        self.greenLabel.set(relativeSize: .width, toSizeAnchor: .width, ofView: self.pinkLabel, multiplier: 1.0, constant: 0.0)
        self.greenLabel.pin(edge: .top, toEdge: .bottom, ofView: self.pinkLabel)
        self.greenLabel.pin(to: self.pinkLabel, edges: [ .leading, .trailing ])
    }
    
}
