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

public protocol MosaicLayoutDelegate: class {
  func collectionView(_ collectionView: UICollectionView, numberOfColumnsInSection section: Int) -> Int
  func collectionView(_ collectionView: UICollectionView, shouldShowBigInSection section: Int) -> Bool
  func collectionView(_ collectionView: UICollectionView, heightForItemInSection section: Int) -> CGFloat // Called in case more than 1 column
  func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat // Called in case only 1 column

  func collectionView(_ collectionView: UICollectionView, insetForSectionAt section: Int) -> UIEdgeInsets
  func collectionView(_ collectionView: UICollectionView, minimumLineSpacingForSectionAt section: Int) -> CGFloat
  func collectionView(_ collectionView: UICollectionView, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat

  func collectionView(_ collectionView: UICollectionView, referenceSizeForHeaderInSection section: Int) -> CGSize
  func collectionView(_ collectionView: UICollectionView, referenceSizeForFooterInSection section: Int) -> CGSize
}
