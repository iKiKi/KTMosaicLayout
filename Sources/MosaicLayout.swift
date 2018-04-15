//  MIT License
//
//  Copyright (c) 2018 KTMosaicLayout
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

open class MosaicLayout: UICollectionViewLayout {

  fileprivate enum ItemType {
    case big
    case small
  }

  // MARK: Properties

  public weak var delegate: MosaicLayoutDelegate?
  private var headersLayoutAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
  private var footersLayoutAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
  private var itemsLayoutAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
  private let allKinds = [UICollectionElementKindSectionHeader, UICollectionElementKindSectionFooter]

  // MARK: - Initializers

  // MARK: - Overrides

  override open class var layoutAttributesClass: AnyClass {
    return MosaicLayoutAttributes.self
  }

  override open class var invalidationContextClass: AnyClass {
    return MosaicLayoutInvalidationContext.self
  }

  override open func prepare() {
    super.prepare()

    self.resetLayout()
    self.configureLayout()
  }

  override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    self.headersLayoutAttributes.forEach {
      if rect.intersects($1.frame) {
        layoutAttributes.append($1)
      }
    }
    self.footersLayoutAttributes.forEach {
      if rect.intersects($1.frame) {
        layoutAttributes.append($1)
      }
    }
    self.itemsLayoutAttributes.forEach {
      if rect.intersects($1.frame) {
        layoutAttributes.append($1)
      }
    }
    return layoutAttributes
  }

  override open func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    if elementKind == UICollectionElementKindSectionHeader {
      return self.headersLayoutAttributes[indexPath]
    }
    if elementKind == UICollectionElementKindSectionFooter {
      return self.footersLayoutAttributes[indexPath]
    }
    return nil
  }

  override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return self.itemsLayoutAttributes[indexPath]
  }

  override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    guard let collectionView = self.collectionView else { preconditionFailure("Should have a \(UICollectionView.self) using this layout.") }
    if !collectionView.bounds.size.equalTo(newBounds.size) {
      self.prepare()
      return true
    }
    return false
  }

  override open var collectionViewContentSize: CGSize {
    var height: CGFloat = 0
    guard let collectionView = self.collectionView else { preconditionFailure("Should have a \(UICollectionView.self) using this layout.") }
    let numberOfSections = collectionView.numberOfSections
    for section in 0..<numberOfSections {
      let elementKinds = [section: allKinds]
      height += self.height(ofSection: section, withKinds: elementKinds)
    }
    return CGSize(width: self.contentWidth, height: height)
  }

  // MARK: - Public methods
}

// MARK: - Private methods
private extension MosaicLayout {

  var contentWidth: CGFloat {
    guard let collectionView = self.collectionView else { preconditionFailure("Should have a \(UICollectionView.self) using this layout.") }
    return collectionView.bounds.size.width - collectionView.contentInset.left - collectionView.contentInset.right
  }

  func resetLayout() {
    self.headersLayoutAttributes = [:]
    self.footersLayoutAttributes = [:]
    self.itemsLayoutAttributes = [:]
  }

  func configureLayout() {
    guard let collectionView = self.collectionView else { preconditionFailure("Should have a \(UICollectionView.self) using this layout.") }
    let numberOfSections = collectionView.numberOfSections
    for section in 0..<numberOfSections {
      guard let delegate = self.delegate else { preconditionFailure("Should have a \(MosaicLayoutDelegate.self) for this layout.") }
      let numberOfColumnsInSection = delegate.collectionView(collectionView, numberOfColumnsInSection: section)
      guard numberOfColumnsInSection > 0 else { preconditionFailure("Section \(section) should have at least 1 column.") }
      if numberOfColumnsInSection > 1 {
        let minimumInteritemSpacing = delegate.collectionView(collectionView, minimumInteritemSpacingForSectionAt: section)
        let rowSpacing = CGFloat(numberOfColumnsInSection - 1) * minimumInteritemSpacing
        guard rowSpacing <= self.contentWidth else {
          preconditionFailure("The entire row spacing shall not exceed the entire available width in section \(section). Please specify a suitable minimumInteritemSpacing value.")
        }
      }
      for item in 0..<collectionView.numberOfItems(inSection: section) {
        let indexPath = IndexPath(item: item, section: section)
        self.configureHeader(atIndexPath: indexPath)
        self.configureFooter(atIndexPath: indexPath)
        self.configureItem(atIndexPath: indexPath)
      }
    }
  }

  func configureHeader(atIndexPath indexPath: IndexPath) {
    guard let collectionView = self.collectionView else { preconditionFailure("Should have a \(UICollectionView.self) using this layout.") }
    guard let delegate = self.delegate else { preconditionFailure("Should have a \(MosaicLayoutDelegate.self) for this layout.") }
    let section = indexPath.section
    let size = delegate.collectionView(collectionView, referenceSizeForHeaderInSection: section)
    guard indexPath.item == 0, size != .zero else { return }
    let kind = UICollectionElementKindSectionHeader
    let layoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
    let frame = self.headerRect(inSection: section, with: size)
    layoutAttributes.frame = frame
    self.headersLayoutAttributes[indexPath] = layoutAttributes
  }

  func headerRect(inSection section: Int, with size: CGSize) -> CGRect {
    let originX: CGFloat = 0
    let sectionOffsetY = self.headerOffsetY(of: section)
    let originY: CGFloat = sectionOffsetY
    let origin = CGPoint(x: originX, y: originY)
    return CGRect(origin: origin, size: size)
  }

  func headerOffsetY(of section: Int) -> CGFloat {
    var height: CGFloat = 0
    for section in 0..<section {
      let elementKinds = [section: allKinds]
      height += self.height(ofSection: section, withKinds: elementKinds)
    }
    return height
  }

  func configureFooter(atIndexPath indexPath: IndexPath) {
    guard let collectionView = self.collectionView else { preconditionFailure("Should have a \(UICollectionView.self) using this layout.") }
    guard let delegate = self.delegate else { preconditionFailure("Should have a \(MosaicLayoutDelegate.self) for this layout.") }
    let section = indexPath.section
    let size = delegate.collectionView(collectionView, referenceSizeForFooterInSection: section)
    guard indexPath.item == 0, size != .zero else { return }
    let kind = UICollectionElementKindSectionFooter
    let layoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
    let frame = self.footerRect(inSection: section, with: size)
    layoutAttributes.frame = frame
    self.footersLayoutAttributes[indexPath] = layoutAttributes
  }

  func footerRect(inSection section: Int, with size: CGSize) -> CGRect {
    let originX: CGFloat = 0
    let sectionOffsetY = self.footerOffsetY(of: section)
    let originY: CGFloat = sectionOffsetY
    let origin = CGPoint(x: originX, y: originY)
    return CGRect(origin: origin, size: size)
  }

  func footerOffsetY(of section: Int) -> CGFloat {
    guard let collectionView = self.collectionView else { preconditionFailure("Should have a \(UICollectionView.self) using this layout.") }
    guard let delegate = self.delegate else { preconditionFailure("Should have a \(MosaicLayoutDelegate.self) for this layout.") }
    let footerSize = delegate.collectionView(collectionView, referenceSizeForFooterInSection: section)
    return self.headerOffsetY(of: section + 1) - footerSize.height
  }

  func configureItem(atIndexPath indexPath: IndexPath) {
    let itemType: ItemType = self.itemType(atIndexPath: indexPath)
    let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
    let frame = self.itemRect(with: itemType, atIndexPath: indexPath)
    layoutAttributes.frame = frame
    self.itemsLayoutAttributes[indexPath] = layoutAttributes
  }

  func itemRect(with itemType: ItemType, atIndexPath indexPath: IndexPath) -> CGRect {
    guard let collectionView = self.collectionView else { preconditionFailure("Should have a \(UICollectionView.self) using this layout.") }
    guard let delegate = self.delegate else { preconditionFailure("Should have a \(MosaicLayoutDelegate.self) for this layout.") }
    let numberOfColumnsInSection = delegate.collectionView(collectionView, numberOfColumnsInSection: indexPath.section)
    let rowOfItem = self.rowOfItem(with: itemType, atIndexPath: indexPath)
    let columnOfItem = self.columnOfItem(with: itemType, atIndexPath: indexPath)
    let minimumInteritemSpacing = delegate.collectionView(collectionView, minimumInteritemSpacingForSectionAt: indexPath.section)
    let rowSpacing = CGFloat(numberOfColumnsInSection - 1) * minimumInteritemSpacing
    let sectionInset = delegate.collectionView(collectionView, insetForSectionAt: indexPath.section)
    let columWidth: CGFloat = (self.contentWidth - sectionInset.left - sectionInset.right - rowSpacing) / CGFloat(numberOfColumnsInSection)
    let originX = sectionInset.left + CGFloat(columnOfItem) * columWidth + CGFloat(columnOfItem) * minimumInteritemSpacing
    let rowHeight = self.rowHeight(atIndexPath: indexPath)
    let sectionOffsetY = self.contentOffsetY(toSection: indexPath.section, sectionInset: sectionInset)
    let minimumLineSpacing = delegate.collectionView(collectionView, minimumLineSpacingForSectionAt: indexPath.section)
    let columnSpacing = CGFloat(rowOfItem) * minimumLineSpacing
    let originY: CGFloat = CGFloat(rowOfItem) * rowHeight + columnSpacing + sectionOffsetY
    let width = self.itemWidth(with: itemType, atIndexPath: indexPath)
    let height = self.itemHeight(with: itemType, atIndexPath: indexPath)
    return CGRect(x: originX, y: originY, width: width, height: height)
  }

  func itemWidth(with itemType: ItemType, atIndexPath indexPath: IndexPath) -> CGFloat {
    guard let collectionView = self.collectionView else { preconditionFailure("Should have a \(UICollectionView.self) using this layout.") }
    guard let delegate = self.delegate else { preconditionFailure("Should have a \(MosaicLayoutDelegate.self) for this layout.") }
    let numberOfColumnsInSection = delegate.collectionView(collectionView, numberOfColumnsInSection: indexPath.section)
    let minimumInteritemSpacing = delegate.collectionView(collectionView, minimumInteritemSpacingForSectionAt: indexPath.section)
    let rowSpacing = CGFloat(numberOfColumnsInSection - 1) * minimumInteritemSpacing
    let sectionInset = delegate.collectionView(collectionView, insetForSectionAt: indexPath.section)
    let width: CGFloat = (self.contentWidth - sectionInset.left - sectionInset.right - rowSpacing) / CGFloat(numberOfColumnsInSection)
    let canShowBig = self.canShowBig(inSection: indexPath.section)
    if canShowBig && itemType == .big {
      let columns = CGFloat(numberOfColumnsInSection - 1)
      return width * columns + minimumInteritemSpacing * (columns - 1)
    }
    return width
  }

  func itemHeight(with itemType: ItemType, atIndexPath indexPath: IndexPath) -> CGFloat {
    guard let collectionView = self.collectionView else { preconditionFailure("Should have a \(UICollectionView.self) using this layout.") }
    guard let delegate = self.delegate else { preconditionFailure("Should have a \(MosaicLayoutDelegate.self) for this layout.") }
    let numberOfColumnsInSection = delegate.collectionView(collectionView, numberOfColumnsInSection: indexPath.section)
    let rowHeight = self.rowHeight(atIndexPath: indexPath)
    let canShowBig = self.canShowBig(inSection: indexPath.section)
    if canShowBig && itemType == .big {
      let minimumLineSpacing = delegate.collectionView(collectionView, minimumLineSpacingForSectionAt: indexPath.section)
      let spacing = CGFloat(numberOfColumnsInSection - 2) * minimumLineSpacing
      return rowHeight * CGFloat(numberOfColumnsInSection - 1) + spacing
    }
    return rowHeight
  }

  func rowHeight(atIndexPath indexPath: IndexPath) -> CGFloat {
    guard let collectionView = self.collectionView else { preconditionFailure("Should have a \(UICollectionView.self) using this layout.") }
    guard let delegate = self.delegate else { preconditionFailure("Should have a \(MosaicLayoutDelegate.self) for this layout.") }
    let numberOfColumnsInSection = delegate.collectionView(collectionView, numberOfColumnsInSection: indexPath.section)
    if numberOfColumnsInSection > 1 {
      return delegate.collectionView(collectionView, heightForItemInSection: indexPath.section)
    }
    return delegate.collectionView(collectionView, heightForItemAt: indexPath)
  }

  func rowOfItem(with itemType: ItemType, atIndexPath indexPath: IndexPath) -> Int {
    guard let collectionView = self.collectionView else { preconditionFailure("Should have a \(UICollectionView.self) using this layout.") }
    guard let delegate = self.delegate else { preconditionFailure("Should have a \(MosaicLayoutDelegate.self) for this layout.") }
    let numberOfColumnsInSection = delegate.collectionView(collectionView, numberOfColumnsInSection: indexPath.section)
    if itemType == .big { return 0 }
    let canShowBig = self.canShowBig(inSection: indexPath.section)
    if canShowBig {
      if self.isRowContainsBig(atIndexPath: indexPath) {
        return indexPath.item - 1
      }
      let offset = numberOfColumnsInSection - 2
      return indexPath.item / numberOfColumnsInSection + offset
    }
    if numberOfColumnsInSection > 1 {
      return indexPath.item / numberOfColumnsInSection
    }
    return indexPath.item
  }

  func columnOfItem(with itemType: ItemType, atIndexPath indexPath: IndexPath) -> Int {
    guard let collectionView = self.collectionView else { preconditionFailure("Should have a \(UICollectionView.self) using this layout.") }
    guard let delegate = self.delegate else { preconditionFailure("Should have a \(MosaicLayoutDelegate.self) for this layout.") }
    let numberOfColumnsInSection = delegate.collectionView(collectionView, numberOfColumnsInSection: indexPath.section)
    if itemType == .big { return 0 }
    let canShowBig = self.canShowBig(inSection: indexPath.section)
    if canShowBig {
      if self.isRowContainsBig(atIndexPath: indexPath) {
        return numberOfColumnsInSection - 1
      }
      return indexPath.item % numberOfColumnsInSection
    }
    if numberOfColumnsInSection > 1 {
      return indexPath.item % numberOfColumnsInSection
    }
    return 0
  }

  func height(ofSection section: Int, withKinds elementKinds: [Int: [String]] = [:]) -> CGFloat {
    guard let collectionView = self.collectionView else { preconditionFailure("Should have a \(UICollectionView.self) using this layout.") }
    let numberOfItems = collectionView.numberOfItems(inSection: section)
    guard let delegate = self.delegate else { preconditionFailure("Should have a \(MosaicLayoutDelegate.self) for this layout.") }
    let numberOfColumnsInSection = delegate.collectionView(collectionView, numberOfColumnsInSection: section)
    var contentHeight: CGFloat = 0
    if let elementKinds = elementKinds[section], elementKinds.contains(UICollectionElementKindSectionHeader) {
      let headerSize = delegate.collectionView(collectionView, referenceSizeForHeaderInSection: section)
      contentHeight += headerSize.height
    }
    let sectionInset = delegate.collectionView(collectionView, insetForSectionAt: section)
    contentHeight += sectionInset.top
    let minimumLineSpacing = delegate.collectionView(collectionView, minimumLineSpacingForSectionAt: section)
    if numberOfColumnsInSection > 1 { // More than 1 column
      var numberOfRowsInSection = numberOfItems / numberOfColumnsInSection
      let canShowBig = self.canShowBig(inSection: section)
      if canShowBig {
        let offset = numberOfColumnsInSection - 2
        numberOfRowsInSection += offset
      }
      let rowHeight = delegate.collectionView(collectionView, heightForItemInSection: section)
      let extraRow = numberOfItems % numberOfColumnsInSection != 0 ? 1 : 0
      let rows = CGFloat(numberOfRowsInSection + extraRow)
      let spacing = CGFloat(rows - 1) * minimumLineSpacing
      contentHeight += rows * rowHeight + spacing
    } else { // Only 1 column
      var height: CGFloat = 0
      for item in 0..<collectionView.numberOfItems(inSection: section) {
        let indexPath = IndexPath(item: item, section: section)
        let spacing = item > 0 ? minimumLineSpacing : 0
        height += delegate.collectionView(collectionView, heightForItemAt: indexPath) + spacing
      }
      contentHeight += height
    }
    contentHeight += sectionInset.bottom
    if let elementKinds = elementKinds[section], elementKinds.contains(UICollectionElementKindSectionFooter) {
      let footerSize = delegate.collectionView(collectionView, referenceSizeForFooterInSection: section)
      contentHeight += footerSize.height
    }
    return contentHeight
  }

  func contentOffsetY(toSection section: Int, sectionInset: UIEdgeInsets) -> CGFloat {
    var height: CGFloat = 0
    for section in 0..<section {
      let elementKinds = [section: allKinds]
      height += self.height(ofSection: section, withKinds: elementKinds)
    }
    guard let collectionView = self.collectionView else { preconditionFailure("Should have a \(UICollectionView.self) using this layout.") }
    guard let delegate = self.delegate else { preconditionFailure("Should have a \(MosaicLayoutDelegate.self) for this layout.") }
    let headerSize = delegate.collectionView(collectionView, referenceSizeForHeaderInSection: section)
    return headerSize.height + sectionInset.top + height
  }

  func itemType(atIndexPath indexPath: IndexPath) -> ItemType {
    let canShowBig = self.canShowBig(inSection: indexPath.section)
    return canShowBig && indexPath.item == 0 ? .big : .small
  }

  func canShowBig(inSection section: Int) -> Bool {
    guard let collectionView = self.collectionView else { preconditionFailure("Should have a \(UICollectionView.self) using this layout.") }
    guard let delegate = self.delegate else { preconditionFailure("Should have a \(MosaicLayoutDelegate.self) for this layout.") }
    let numberOfColumnsInSection = delegate.collectionView(collectionView, numberOfColumnsInSection: section)
    let shouldShow = delegate.collectionView(collectionView, shouldShowBigInSection: section)
    if shouldShow {
      guard numberOfColumnsInSection > 2 else { preconditionFailure("Section \(section) should have at least 3 columns to display a big.") }
    }
    return shouldShow
  }

  func isRowContainsBig(atIndexPath indexPath: IndexPath) -> Bool {
    guard let collectionView = self.collectionView else { preconditionFailure("Should have a \(UICollectionView.self) using this layout.") }
    guard let delegate = self.delegate else { preconditionFailure("Should have a \(MosaicLayoutDelegate.self) for this layout.") }
    let numberOfColumnsInSection = delegate.collectionView(collectionView, numberOfColumnsInSection: indexPath.section)
    let canShowBig = self.canShowBig(inSection: indexPath.section)
    return canShowBig && indexPath.item < numberOfColumnsInSection
  }
}
