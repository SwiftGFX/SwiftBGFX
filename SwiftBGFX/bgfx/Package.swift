// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import PackageDescription

let package = Package(
    name: "SwiftBGFX",
    dependencies: [
      .Package(url: "../../3rdparty/Math", majorVersion: 1),
    ]
)

let ar = Product(name: "SwiftBGFX", type: .Library(.Static), modules: "SwiftBGFX")
products.append(ar)
