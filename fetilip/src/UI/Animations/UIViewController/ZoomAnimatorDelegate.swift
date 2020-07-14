//
//  ZoomAnimatorDelegate.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/03.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

// Reference: https://github.com/masamichiueta/FluidPhoto/tree/master/FluidPhoto/Animation

/**
 * handle zoom animation logic when present detail view from collection view.
 */
protocol ZoomAnimatorDelegate: class {
    func transitionWillStartWith(zoomAnimator: TransitionManager)
    func transitionDidEndWith(zoomAnimator: TransitionManager)
    func referenceImageView(for zoomAnimator: TransitionManager) -> UIImageView?
    func referenceImageViewFrameInTransitioningView(for zoomAnimator: TransitionManager) -> CGRect?
}
