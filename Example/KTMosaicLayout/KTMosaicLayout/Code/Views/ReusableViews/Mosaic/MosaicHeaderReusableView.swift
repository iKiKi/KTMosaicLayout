//
//  MosaicHeaderReusableView.swift
//  KTMosaicLayout
//
//  Copyright © 2018 KTMosaicLayout. All rights reserved.
//

import UIKit
import Reusable

final class MosaicHeaderReusableView: CollectionReusableView, NibReusable {

  // MARK: Outlets

  @IBOutlet weak var ibLabel: UILabel!

  // MARK: Properties

  // MARK: - Initializers

  // MARK: - Overrides

  override func awakeFromNib() {
    super.awakeFromNib()

    self.layer.borderColor = UIColor.white.cgColor
    self.layer.borderWidth = 2
    self.backgroundColor = .darkGray
  }

  // MARK: - Internal methods

  func update(atIndexPath indexPath: IndexPath) {
    self.ibLabel.text = "HEADER at section: \(indexPath.section)"
    self.ibLabel.textColor = .white
  }

  // MARK: - Actions
}
