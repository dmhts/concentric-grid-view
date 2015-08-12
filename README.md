ConcentricGridView
=========

`ConcentricGridView` is a grid system that is used by UICollectionViewLayout to lay out UICollectionViewCells in a concentric way using different distribution algorithms: Concentric Uniform Distribution Algorithm (CUDA) and Concentric Consistent Distribution Algorithm (CCDA). You can see visualisations of aforementioned algorithms below (in the same order):

<div style="text-align: center">
<img src="https://raw.githubusercontent.com/dmgts/concentric-grid-view/master/assets/ConcentricGridViewPolygon.gif" width="320" title="Concentric Unifrom Distribution Algorithm">
<img src="https://raw.githubusercontent.com/dmgts/concentric-grid-view/master/assets/ConcentricGridViewRectangle.gif" width="291" title="Concentric Consistent Distribution Algorithm">
</div>

## Requirements

- iOS 7.0+ / Mac OS X 10.9+
- Xcode 7.0+

## Installation

Just drop the Pod folder into your project. That's it!

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