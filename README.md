# KTMosaicLayout

<p align="center">
  <img alt="Reusable" src="logo.png" width="150" height="150"/>
</p>

![Xcode 9.0+](https://img.shields.io/badge/Xcode-9.0%2B-blue.svg)
![iOS 9.0+](https://img.shields.io/badge/iOS-9.0%2B-blue.svg)
![tvOS 9.0+](https://img.shields.io/badge/tvOS-9.0%2B-blue.svg)
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Swift-4.0%2B-orange.svg" alt="Swift 4.0+" /></a>
[![Version](https://img.shields.io/cocoapods/v/KTMosaicLayout.svg?style=flat)](http://cocoapods.org/pods/KTMosaicLayout)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/KTMosaicLayout.svg?style=flat)](https://github.com/iKiKi/KTMosaicLayout/blob/master/LICENSE?raw=true)
[![Twitter](https://img.shields.io/badge/twitter-@kthoron-blue.svg?style=flat)](http://twitter.com/kthoron)

**KTMosaicLayout** is a Swift `UICollectionViewLayout` being able to display `UICollectionView` items on different columns.

<p align="center"><img width=32% src="./Documentation/img/without_big.png"></p>

### Features

In case at least 3 columns is defined for a section, **KTMosaicLayout** can display the first item of this section in a **big** style. When a section displays the first item as **big**, it means that the first row of this section displays all the last items on a single column, to layout the first as a **big**.

<p align="center"><img width=32% src="./Documentation/img/with_big.png"></p>

> 💡 In case you don't really need to display big styled items in sections as illustrated above, this layout can be replaced by a usual `UICollectionViewFlowLayout`.

## 📱Example

<p align="center"><img width=32% src="./Documentation/img/big_3_columns_iphonexspacegrey_portrait.png"><img width=32% src="./Documentation/img/no_big_3_columns__iphonexspacegrey_portrait.png"><img width=32% src="./Documentation/img/big_4_columns_iphonexspacegrey_portrait.png"></p>

> 💡 To run the [example project](https://github.com/iKiKi/KTMosaicLayout/tree/master/Example), clone the repo, pod install, and run the iOS application.

## Installation

### CocoaPods

The preferred installation method is with [CocoaPods](http://cocoapods.org). Add the following to your `Podfile`:

```ruby
pod 'KTMosaicLayout'
```

### Carthage

For [Carthage](https://github.com/Carthage/Carthage), add the following to your `Cartfile`:

```ogdl
github "iKiKi/KTMosaicLayout"
```

## Usage

You just need to set a `KTMosaicLayout` to your `UICollectionView` layout (using IB or code), set a `MosaicLayoutDelegate` to this layout and implement the necessary methods:

```swift
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
```

> 💡 `heightForItemInSection` is called in case a section has more than 1 column. `heightForItemAt` is called in case the section has only 1 column (to layout items with different heights).

## License

`KTMosaicLayout` is released under the MIT license. [See LICENSE](https://github.com/iKiKi/KTMosaicLayout/blob/master/LICENSE) for details.
