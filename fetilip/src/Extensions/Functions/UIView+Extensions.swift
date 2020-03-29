//
//  UIView+Extensions.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/29.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit

extension UIView: ExtensionCompatible {}

extension Extension where Base: UIView {

    func pinToSafeArea(top: CGFloat? = 0, left: CGFloat? = 0, bottom: CGFloat? = 0, right: CGFloat? = 0){
        guard let superview = self.base.superview else { return }

        prepareForAutoLayout()

        var guide: UILayoutGuide
        if #available(iOS 11.0, *) {
            guide = superview.safeAreaLayoutGuide
        } else {
            guide = superview.layoutMarginsGuide
        }

        if let top = top {
            self.base.topAnchor.constraint(equalTo: guide.topAnchor, constant: top).isActive = true
        }

        if let bottom = bottom {
            self.base.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: bottom).isActive = true
        }

        if let left = left {
            self.base.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: left).isActive = true
        }

        if let right = right {
            self.base.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: right).isActive = true
        }
    }

    func pinToSuperView(top: CGFloat? = 0, left: CGFloat? = 0, bottom: CGFloat? = 0, right: CGFloat? = 0){
        guard let superview = self.base.superview else { return }

        prepareForAutoLayout()

        if let top = top {
            self.base.topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        }

        if let bottom = bottom {
            self.base.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom).isActive = true
        }

        if let left = left {
            self.base.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: left).isActive = true
        }

        if let right = right {
            self.base.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: right).isActive = true
        }
    }

    func centerInSuperView(){
        guard let superview = self.base.superview else { return }

        prepareForAutoLayout()

        self.base.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        self.base.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }

    func constraint(width: CGFloat){
        prepareForAutoLayout()
        self.base.widthAnchor.constraint(equalToConstant: width).isActive = true
    }

    func constraint(height: CGFloat){
        prepareForAutoLayout()
        self.base.heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    func makeWidthEqualHeight(){
        prepareForAutoLayout()
        self.base.widthAnchor.constraint(equalTo: self.base.heightAnchor).isActive = true
    }

    func prepareForAutoLayout(){
        self.base.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
