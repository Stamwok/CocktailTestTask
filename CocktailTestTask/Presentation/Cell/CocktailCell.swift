//
//  CocktailViewCell.swift
//  CocktailTestTask
//
//  Created by  Егор Шуляк on 29.03.22.
//

import UIKit

final class CocktailCell: UICollectionViewCell {
    static let reuseID = String(describing: CocktailCell.self)
    
    private let label: UILabel = UILabel()
    private let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height * 0.3
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Colors.colorGray
        self.clipsToBounds = true
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel() {
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(5)
        }
    }
    
    func configureCell(cocktailName: String) {
        label.text = cocktailName
    }
    
    // MARK: - cell selection control
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.select()
            } else {
                self.deselect()
            }
        }
    }
    
    private func select() {
        gradientLayer.frame = bounds
        let colorPurple = Colors.colorPurple
        let colorRed = Colors.colorRed
        gradientLayer.colors = [colorRed.cgColor, colorPurple.cgColor]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func deselect() {
        gradientLayer.removeFromSuperlayer()
    }
    
    // MARK: - cell size control
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let labelSize = label.systemLayoutSizeFitting(layoutAttributes.size)
        let contentViewSize = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.width = CGFloat(ceilf(Float(labelSize.width * 1.3)))
        newFrame.size.height = CGFloat(ceilf(Float(contentViewSize.height)))
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}
