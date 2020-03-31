//
//  CustomTabBarButton.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/29.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit


/**
 * TabBarに表示するボタン本体
 */
public class CustomTabBarButton: UIButton {

    // MARK: Properties

    /// 選択状態の色
    public var selectedColor: UIColor! = .black {
        didSet {
            reloadApperance()
        }
    }

    /// 未選択状態の色
    private var unselectedColor: UIColor! = .black {
        didSet {
            reloadApperance()
        }
    }

    // MARK: init

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

    /// 選択状態によって色を変える
    private func reloadApperance(){
        self.tintColor = isSelected ? selectedColor : unselectedColor
    }

}
