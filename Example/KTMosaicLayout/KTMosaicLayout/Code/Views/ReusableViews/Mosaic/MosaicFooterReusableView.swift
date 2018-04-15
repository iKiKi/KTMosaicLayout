//
//  MosaicFooterReusableView.swift
//  KTMosaicLayout
//
//  Copyright © 2018 KTMosaicLayout. All rights reserved.
//

import UIKit
import Reusable

final class MosaicFooterReusableView: CollectionReusableView, NibReusable {

  // MARK: Outlets

  @IBOutlet weak var ibLabel: UILabel!

  // MARK: Properties

  // MARK: - Initializers

  // MARK: - Overrides

  override func awakeFromNib() {
    super.awakeFromNib()

    self.layer.borderColor = UIColor.darkGray.cgColor
    self.layer.borderWidth = 2
    self.backgroundColor = .white
  }

  // MARK: - Internal methods

  func update(atIndexPath indexPath: IndexPath) {
    self.ibLabel.text = "FOOTER at section: \(indexPath.section)"
    self.ibLabel.textColor = .black
  }

  // MARK: - Actions
}
