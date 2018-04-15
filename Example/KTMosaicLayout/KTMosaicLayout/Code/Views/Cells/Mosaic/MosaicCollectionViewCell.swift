//
//  MosaicCollectionViewCell.swift
//  KTMosaicLayout
//
//  Copyright © 2018 KTMosaicLayout. All rights reserved.
//

import UIKit
import Reusable

final class MosaicCollectionViewCell: CollectionViewCell, NibReusable {

  // MARK: Outlets

  @IBOutlet weak var ibLabel: UILabel!

  // MARK: Properties

  // MARK: - Initializers

  // MARK: - Overrides

  // MARK: - Internal methods

  func update(with color: UIColor, at indexPath: IndexPath) {
    self.contentView.backgroundColor = color
    self.ibLabel.text = "\(indexPath)"
    self.ibLabel.textColor = color == .black ? .white : .black
  }

  // MARK: - Actions
}
