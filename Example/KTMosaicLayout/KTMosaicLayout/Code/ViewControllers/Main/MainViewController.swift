//
//  MainViewController.swift
//  KTMosaicLayout
//
//  Copyright © 2018 KTMosaicLayout. All rights reserved.
//

import UIKit
import Reusable
import KTMosaicLayout

final class MainViewController: ViewController {

  private struct Data {
    let colors: [UIColor]
    let numberOfColumns: Int
    let showBig: Bool
    let inset: UIEdgeInsets
  }
  
  // MARK: Outlets
  
  @IBOutlet weak var ibCollectionView: UICollectionView!
  
  // MARK: Properties
  
  private static let defaultsColors: [UIColor] = [.red, .green, .blue, .cyan, .yellow, .magenta, .gray, .lightGray, .orange, .purple, .brown, .black]
  private let dataSource: [Data] = [
    Data(colors: defaultsColors, numberOfColumns: 3, showBig: true,  inset: .zero),
    Data(colors: defaultsColors, numberOfColumns: 3, showBig: false, inset: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)),
    Data(colors: defaultsColors, numberOfColumns: 1, showBig: false, inset: .zero),
    Data(colors: defaultsColors, numberOfColumns: 2, showBig: false, inset: .zero),
    Data(colors: defaultsColors, numberOfColumns: 4, showBig: true,  inset: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
  ]
  
  // MARK: - Initializers
  
  // MARK: - Overrides
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = L10n.pod
    
//    self.ibCollectionView.contentInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    
    self.ibCollectionView.register(supplementaryViewType: MosaicHeaderReusableView.self, ofKind: UICollectionElementKindSectionHeader)
    self.ibCollectionView.register(supplementaryViewType: MosaicFooterReusableView.self, ofKind: UICollectionElementKindSectionFooter)
    self.ibCollectionView.register(cellType: MosaicCollectionViewCell.self)
    if let mosaicLayout = self.ibCollectionView.collectionViewLayout as? MosaicLayout {
      mosaicLayout.delegate = self
    }
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    self.ibCollectionView.collectionViewLayout.invalidateLayout()
  }
  
  // MARK: - Internal methods
  
  // MARK: - Actions
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.dataSource.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.dataSource[section].colors.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let mosaicCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath, cellType: MosaicCollectionViewCell.self)
    let color = self.dataSource[indexPath.section].colors[indexPath.item]
    mosaicCollectionViewCell.update(with: color, at: indexPath)
    return mosaicCollectionViewCell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionElementKindSectionHeader {
      let mosaicHeaderReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, viewType: MosaicHeaderReusableView.self)
      mosaicHeaderReusableView.update(atIndexPath: indexPath)
      return mosaicHeaderReusableView
    }
    if kind == UICollectionElementKindSectionFooter {
      let mosaicFooterReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, viewType: MosaicFooterReusableView.self)
      mosaicFooterReusableView.update(atIndexPath: indexPath)
      return mosaicFooterReusableView
    }
    return UICollectionReusableView()
  }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
  
}

// MARK: - MosaicLayoutDelegate
extension MainViewController: MosaicLayoutDelegate {
  
  func collectionView(_ collectionView: UICollectionView, shouldShowBigInSection section: Int) -> Bool {
    return self.dataSource[section].showBig
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfColumnsInSection section: Int) -> Int {
    return self.dataSource[section].numberOfColumns
  }
  
  func collectionView(_ collectionView: UICollectionView, heightForItemInSection section: Int) -> CGFloat { // Called in case more than 1 column
    return 200
  }
  
  func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat { // Called in case only 1 column
    return 100
  }
  
  func collectionView(_ collectionView: UICollectionView, insetForSectionAt section: Int) -> UIEdgeInsets {
    return self.dataSource[section].inset
  }
  
  func collectionView(_ collectionView: UICollectionView, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.bounds.size.width, height: 80)
  }
  
  func collectionView(_ collectionView: UICollectionView, referenceSizeForFooterInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.bounds.size.width, height: 80)
  }
}
