//
//  ViewMode.swift
//  SwiftBGFX
//
//  Created by Andrey Volodin on 25.06.17.
//

import Cbgfx

public enum ViewMode {
    case `default`, sequental, depthAscending, depthDescending, ccount
}

internal extension ViewMode {
    var bgfxValue: bgfx_view_mode_t {
        switch self {
        case .default: return BGFX_VIEW_MODE_DEFAULT
        case .sequental: return BGFX_VIEW_MODE_SEQUENTIAL
        case .depthAscending: return BGFX_VIEW_MODE_DEPTH_ASCENDING
        case .depthDescending: return BGFX_VIEW_MODE_DEPTH_DESCENDING
        case .ccount: return BGFX_VIEW_MODE_CCOUNT
        }
    }
}
