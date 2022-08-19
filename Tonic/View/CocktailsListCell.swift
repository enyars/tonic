//
//  CocktailsListCell.swift
//  Tonic
//

import Foundation
import UIKit

protocol CocktailsListCellView: AnyObject {
    
    /// Downloads image for cocktail.
    func download(with cocktail: Cocktail)
}

class CocktailsListCell: UITableViewCell {
    
    // MARK: - Properties: private
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.cocktailBoldWithSize(size: 25)
        label.textColor = .label
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private lazy var imageContainer: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.label.cgColor
        image.clipsToBounds = true
        return image
    }()
    
    // MARK: - Properties: public
    
    static let reuseIdentifier = "CocktailsListCell"
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        imageContainer.image = nil
    }
    
    // MARK: - Methods: public
    
    func configure(with cocktail: Cocktail) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        let attributedString = NSAttributedString(string: cocktail.name, attributes: [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .paragraphStyle: paragraphStyle
        ])
        
        nameLabel.attributedText = attributedString
    }
    
    // MARK: - Methods: private
    
    func setupViews() {
        selectionStyle = .none
    }
    
    func setupConstraints() {
        contentView.addSubview(imageContainer)
        
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageContainer.widthAnchor.constraint(equalToConstant: 150),
            imageContainer.heightAnchor.constraint(equalToConstant: 220),
            imageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameLabel.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor)
        ])
    }
}

// MARK: - CocktailsListCell + CocktailsListCellView

extension CocktailsListCell: CocktailsListCellView {
    
    func download(with cocktail: Cocktail) {
        APIClient.download(cocktail.imageUrl) { [weak self] image in
            DispatchQueue.main.async {
                guard let self = self, let image = image else {
                    return
                }
                
                self.imageContainer.image = image
            }
        }
    }
}
