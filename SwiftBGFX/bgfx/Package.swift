//
//  Package.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/22/16.
//  Copyright © 2016 SGC. All rights reserved.
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
