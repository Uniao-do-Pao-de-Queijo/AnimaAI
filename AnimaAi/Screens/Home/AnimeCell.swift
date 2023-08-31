import UIKit

class AnimeCell: UICollectionViewCell {
    private let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        
        stack.spacing = 8
        return stack
    }()
    
    private let animeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .equalCentering
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = UIColor(red: 0.98, green: 1.00, blue: 0.99, alpha: 1.00)
        label.numberOfLines = 0
        return label
    }()
    

    override init(frame: CGRect) {
         super.init(frame: frame)
        setupView()
        addViewsInHierarchy()
        setupConstraints()
     }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    public func setup(anime: Anime) {
        titleLabel.text = anime.attributes.titles?.enJp ?? " - "
        animeImageView.download(from: anime.attributes.posterImage?.medium ?? "https://ih1.redbubble.net/image.4870404907.6541/bg,f8f8f8-flat,750x,075,f-pad,750x1000,f8f8f8.jpg")
    }
    
    private func setupView() {
    }
    
    private func addViewsInHierarchy() {
        contentView.addSubview(horizontalStack)
        horizontalStack.addArrangedSubview(animeImageView)
        horizontalStack.addArrangedSubview(verticalStack)
        verticalStack.addArrangedSubview(titleLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            animeImageView.widthAnchor.constraint(equalToConstant: 110),
            animeImageView.heightAnchor.constraint(equalToConstant: 153)
        ])
    }
}
