//
//  CustomTabBarButton.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/29.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

public class CustomTabBarButton: UIButton {

    var selectedColor: UIColor! = .black {
        didSet {
            reloadApperance()
        }
    }

    var unselectedColor: UIColor! = .black {
        didSet {
            reloadApperance()
        }
    }

    init(forItem item: UITabBarItem) {
        super.init(frame: .zero)
        setImage(item.image, for: .normal)
    }

    init(image: UIImage){
        super.init(frame: .zero)
        setImage(image, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    override public var isSelected: Bool {
        didSet {
            reloadApperance()
        }
    }

    func reloadApperance(){
        self.tintColor = isSelected ? selectedColor : unselectedColor
    }

}
