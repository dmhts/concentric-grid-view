ConcentricGridView
=========

`ConcentricGridView` is a grid system that is used by UICollectionViewLayout to lay out UICollectionViewCells in a concentric way using different distribution algorithms: Concentric Uniform Distribution Algorithm (CUDA) and Concentric Consistent Distribution Algorithm (CCDA). You can see visualisations of aforementioned algorithms below (in the same order):

<img src="https://raw.githubusercontent.com/dmgts/concentric-grid-view/master/assets/ConcentricGridViewPolygon.gif" width="300" title="Concentric Unifrom Distribution Algorithm">
<img src="https://raw.githubusercontent.com/dmgts/concentric-grid-view/master/assets/ConcentricGridViewRectangle.gif" width="273" title="Concentric Consistent Distribution Algorithm">

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

## Usage
The extended example you are welcome to see in `Example` folder. Full descriptions of all classes you can find in appropriate files.

### Creating a virtual grid using CUDA algorithm:

```swift
import ConcentricGridView

var CUDAGridView = ConcentricGridViewPolygon(
        grid: CGSizeMake(300, 500),
        centralCell: CGSizeMake(50, 50),
        peripheralCell: CGSizeMake(50, 50),
        cellMargin: 5
   )

CUDAGridView.createGrid()

// Get coordinates for a cell under the index 5 - for example.
CUDAGridView.getPointAt(5)
```

### Creating a virtual grid using CCDA algorithm:

```swift
import ConcentricGridView

var CCDAGridView = ConcentricGridViewRectangle(
        grid: CGSizeMake(300, 500),
        isShifted: false,
        centralCell: CGSizeMake(50, 50),
        peripheralCell: CGSizeMake(50, 50),
        cellMargin: 5
   )

CCDAGridView.createGrid()

// Get coordinates for a cell under the index 5 - for example.
CCDAGridView.getPointAt(5)
```