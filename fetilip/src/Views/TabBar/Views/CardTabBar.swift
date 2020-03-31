//
//  CardTabBar.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/29.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

// FIXME: Rx置き換え
protocol CustomCardTabBarDelegate: class {

    func cardTabBar(_ sender: CardTabBar, didSelectItemAt index: Int)

}

/**
 * TabBarに表示するView本体
 */
class CardTabBar: UIView {

    // MARK: Properties

    // FIXME: Rx置き換え
    weak var delegate: CustomCardTabBarDelegate?

    var items: [UITabBarItem] = [UITabBarItem]() {
        didSet {
            reloadViews()
        }
    }

    /// インジケータビューのY軸制約
    private var indicatorViewYConstraint: NSLayoutConstraint!

    /// インジケータビューのX軸制約
    private var indicatorViewXConstraint: NSLayoutConstraint!

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center

        return stackView
    }()

    private lazy var indicatorView: IndicatorView = {
        let view = IndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.ex.constraint(width: 5)
        view.backgroundColor = tintColor
        view.ex.makeWidthEqualHeight()

        return view
    }()

    // MARK: init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    deinit {
        stackView.arrangedSubviews.forEach {
            if let button = $0 as? UIControl {
                button.removeTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            }
        }
    }

    // MARK: Lifecycle

    override open func tintColorDidChange() {
        super.tintColorDidChange()
        reloadApperance()
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let position = touches.first?.location(in: self) else {
            super.touchesEnded(touches, with: event)
            return
        }

        let buttons = self.stackView.arrangedSubviews.compactMap { $0 as? CustomTabBarButton }.filter { !$0.isHidden }
        let distances = buttons.map { $0.center.ex.distance(to: position) }

        let buttonsDistances = zip(buttons, distances)

        if let closestButton = buttonsDistances.min(by: { $0.1 < $1.1 }) {
            buttonTapped(sender: closestButton.0)
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
        layer.cornerRadius = bounds.height / 2
    }

}

// MARK: - Public functions

extension CardTabBar {

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        addSubview(indicatorView)

        self.backgroundColor = .white

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 6
        self.layer.shadowOpacity = 0.15

        indicatorViewYConstraint?.isActive = false
        indicatorViewYConstraint = indicatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -10.5)
        indicatorViewYConstraint.isActive = true

        tintColorDidChange()
    }

    public func reloadApperance() {
        buttons().forEach { button in
            button.selectedColor = tintColor
        }

        indicatorView.tintColor = tintColor
    }

    // FIXME: Rx置き換え
    @objc private func buttonTapped(sender: CustomTabBarButton) {
        if let index = stackView.arrangedSubviews.firstIndex(of: sender) {
            select(at: index)
        }
    }

}

// MARK: - Private functions

extension CardTabBar {

    private func add(item: UITabBarItem) {
        self.items.append(item)
        self.addButton(with: item.image!)
    }

    private func remove(item: UITabBarItem) {
        if let index = self.items.firstIndex(of: item) {
            self.items.remove(at: index)
            let view = self.stackView.arrangedSubviews[index]
            self.stackView.removeArrangedSubview(view)
        }
    }

    private func buttons() -> [CustomTabBarButton] {
        return stackView.arrangedSubviews.compactMap { $0 as? CustomTabBarButton }
    }

    private func select(at index: Int) {
        /* move the indicator view */
        if indicatorViewXConstraint != nil {
            indicatorViewXConstraint.isActive = false
            indicatorViewXConstraint = nil
        }

        for (bIndex, button) in buttons().enumerated() {
            button.selectedColor = tintColor
            button.isSelected = bIndex == index

            if bIndex == index {
                indicatorViewXConstraint = indicatorView.centerXAnchor.constraint(equalTo: button.centerXAnchor)
                indicatorViewXConstraint.isActive = true
            }
        }

        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }

        // FIXME: Rx置き換え
        self.delegate?.cardTabBar(self, didSelectItemAt: index)
    }

    private func reloadViews() {
        indicatorViewYConstraint?.isActive = false
        indicatorViewYConstraint = indicatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -10.5)
        indicatorViewYConstraint.isActive = true

        for button in (stackView.arrangedSubviews.compactMap { $0 as? CustomTabBarButton }) {
            stackView.removeArrangedSubview(button)
            button.removeFromSuperview()
            button.removeTarget(self, action: nil, for: .touchUpInside)
        }

        for item in items {
            if let image = item.image {
                addButton(with: image)
            } else {
                addButton(with: UIImage())
            }
        }

        select(at: 0)
    }

    private func addButton(with image: UIImage) {
        let button = CustomTabBarButton(image: image)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.selectedColor = tintColor

        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        self.stackView.addArrangedSubview(button)
    }

    public func select(at index: Int, notifyDelegate: Bool = true) {
        for (bIndex, view) in stackView.arrangedSubviews.enumerated() {
            if let button = view as? UIButton {
                button.tintColor =  bIndex == index ? tintColor : #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
            }
        }

        if notifyDelegate {
            self.delegate?.cardTabBar(self, didSelectItemAt: index)
        }
    }

}
