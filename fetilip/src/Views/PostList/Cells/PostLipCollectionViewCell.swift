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

    @IBOutlet weak var reviewText: UILabel!

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
        reviewText.text = nil
    }

    func setupCell(_ model: PostDomainModel) {
        if let lip = model.image {
            lipImage.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.36) {
                self.lipImage.image = lip
                UIView.animate(withDuration: 0.36) {
                    self.lipImage.alpha = 1
                }
            }
        }
        reviewText.text = model.review
        setupDesign()
    }

    func setupDesign() {
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 7.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.ex.hex("#dddddd").cgColor

        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.ex.hex("#aaaaaa").cgColor
        self.layer.shadowOffset = CGSize(width: 3.00, height: 3.00)
        self.layer.shadowRadius = 2.5
        self.layer.shadowOpacity = 0.5

        // ドロップシャドウの形状をcontentViewに付与した角丸を考慮するようにする
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }

}
