//
//  PostLipCollectionViewCell.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/06/14.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit

/**
 * PostLipViewCell
 */
class PostLipCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets

    @IBOutlet weak var lipImage: UIImageView!

    // MARK: - LifeCycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        clear()
    }

    func clear() {
        lipImage.image = nil
    }

    func setupCell(_ model: PostDomainModel) {
        if let lip = model.image {
            lipImage.image = lip
        }
    }

}
