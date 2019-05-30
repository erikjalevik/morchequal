//
//  TrackCell.swift
//  morchequal
//
//  Created by Erik Jälevik on 29.05.19.
//  Copyright © 2019 Fileside. All rights reserved.
//

import UIKit


// MARK: Constants

fileprivate let outerMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
fileprivate let innerMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

fileprivate let innerSpacing: CGFloat = 2

fileprivate let textSizeL: CGFloat = 14
fileprivate let textSizeS: CGFloat = 12

fileprivate let albumCoverSize: CGFloat = 84


// MARK: Implementation

class TrackCell: UITableViewCell {
    static let id = "TrackCell"
    static let height = albumCoverSize

    private let mainStack = UIStackView()
    private let infoStack = UIStackView()

    private let nameLabel = UILabel(frame: .zero)
    private let albumLabel = UILabel(frame: .zero)
    private let spacer = UIView(frame: .zero)
    private let dateLabel = UILabel(frame: .zero)
    private let albumCover = UIImageView(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = UIColor.clear
        separatorInset = innerMargins

        contentView.layoutMargins = outerMargins
        contentView.preservesSuperviewLayoutMargins = false

        mainStack.axis = .horizontal
        mainStack.alignment = .fill
        mainStack.spacing = 0

        infoStack.axis = .vertical
        infoStack.alignment = .leading
        infoStack.spacing = innerSpacing
        infoStack.layoutMargins = innerMargins
        infoStack.isLayoutMarginsRelativeArrangement = true

        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.systemFont(ofSize: textSizeL, weight: .medium)
        nameLabel.numberOfLines = 2
        infoStack.addArrangedSubview(nameLabel)

        albumLabel.textColor = UIColor.gray
        albumLabel.font = UIFont.systemFont(ofSize: textSizeS, weight: .medium)
        infoStack.addArrangedSubview(albumLabel)

        infoStack.addArrangedSubview(spacer)

        dateLabel.textColor = UIColor.gray
        dateLabel.font = UIFont.systemFont(ofSize: textSizeS, weight: .light)
        infoStack.addArrangedSubview(dateLabel)

        mainStack.addArrangedSubview(infoStack)
        mainStack.addArrangedSubview(albumCover)

        contentView.addSubview(mainStack)

        constrain()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constrain() {
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        albumLabel.translatesAutoresizingMaskIntoConstraints = false
        spacer.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        albumCover.translatesAutoresizingMaskIntoConstraints = false

        let margins = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            mainStack.topAnchor.constraint(equalTo: margins.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            
            albumCover.widthAnchor.constraint(equalTo: albumCover.heightAnchor),
        ])
        
        spacer.setContentCompressionResistancePriority(.required, for: .vertical)
        albumCover.setContentHuggingPriority(.required, for: .horizontal)
        albumCover.setContentHuggingPriority(.required, for: .vertical)
    }

    func setInfo(from track: Track) {
        nameLabel.text = track.name
        albumLabel.text = track.album
    }
    
    func setArtwork(image: UIImage) {
        albumCover.image = image
    }
    
    func setReleaseDate(formatted: String) {
        dateLabel.text = formatted
    }
}
