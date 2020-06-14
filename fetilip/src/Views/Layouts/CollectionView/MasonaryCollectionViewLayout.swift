//
//  MasonaryCollectionViewLayout.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/06/14.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit

/// Protocol for reflecting the height of the displayed photo in UICollectionViewCell.
protocol MasonaryLayoutDelegate: class {

    // Reflecting image height in displayed cell.
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath index: IndexPath) -> CGFloat

}

/// Masonary Layout
final class MasonaryCollectionViewLayout: UICollectionViewLayout {

    // MARK: - Properties

    /// Delegate
    weak var delegate: MasonaryLayoutDelegate!

    /// The number of colimn to arrange and the gap between cells.(Defaults 2.)
    private let numberOfColumns: Int = 2

    private let paddingCell: CGFloat = 7.5

    private var storedLayoutAttributes: [UICollectionViewLayoutAttributes] = []

    private var collectionViewContentHeight: CGFloat = 0

    private var collectionViewContentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0.0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    // MARK: - Override

    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionViewContentWidth, height: collectionViewContentHeight)
    }

    override func prepare() {
        super.prepare()

        guard storedLayoutAttributes.isEmpty, let collectionView = collectionView else {
            return
        }

        let columnWidth = collectionViewContentWidth / CGFloat(numberOfColumns)
        let offsetX = (0..<numberOfColumns).map { CGFloat($0) * columnWidth }
        var offsetY = [CGFloat](repeating: 0, count: numberOfColumns)

        var column = 0
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let photoHeight = self.delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
            let fixedHeight = paddingCell * 2 + photoHeight
            let fixedFrame = CGRect(x: offsetX[column], y: offsetY[column], width: columnWidth, height: fixedHeight)
            let insetFrame = fixedFrame.insetBy(dx: paddingCell, dy: paddingCell)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            storedLayoutAttributes.append(attributes)

            collectionViewContentHeight = max(collectionViewContentHeight, fixedFrame.maxY)
            offsetY[column] = offsetY[column] + fixedHeight
            // ループ前に定義したvar columnの値を更新する
            if column < (numberOfColumns - 1) {
                column = column + 1
            } else {
                column = 0
            }
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let visibleLayoutAttributes = storedLayoutAttributes.filter { $0.frame.intersects(rect) }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let targetLayoutAttributes = storedLayoutAttributes[indexPath.item]
        return targetLayoutAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }

}
