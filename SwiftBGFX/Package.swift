// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import PackageDescription

let package = Package(
    name: "SwiftBGFX",
	targets: [
		Target(name: "SwiftBGFX", dependencies: ["Cbgfx"])
	],
    dependencies: [
    .Package(url: "https://github.com/SwiftGFX/SwiftMath", majorVersion: 2, minor: 1)
    ]
)

let ar = Product(name: "SwiftBGFX", type: .Library(.Dynamic), modules: "SwiftBGFX")
products.append(ar)
