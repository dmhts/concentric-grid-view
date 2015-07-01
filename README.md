ConcentricGridView
=========

`ConcentricGridView` is a grid system that is used by UICollectionViewLayout to lay out UICollectionViewCells in a concentric way using different distribution algorithms.

## Requirements

- iOS 7.0+ / Mac OS X 10.9+
- Xcode 6.3

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 8 or OS X Mavericks.**
>
> To use ConcentricGridView with a project targeting iOS 7, you must include all Swift files located inside the `Pod` directory directly in your project.

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.36 adds supports for Swift and embedded frameworks. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate ConcentricGridView into your project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'ConcentricGridView', :git => 'https://github.com/dmgts/concentric-grid-view.git'
```

Then, run the following command:

```bash
$ pod install
```