// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

/// Represents an occlusion query
public class OcclusionQuery {
    let handle: bgfx_occlusion_query_handle_t
    
    /// Gets the result of the query
    public var result: OcclusionQueryResult {
        return OcclusionQueryResult(rawValue: bgfx_get_result(handle, nil).rawValue)!
    }
    
    public var resultWithNumberOfPixels: (result: OcclusionQueryResult, pixelCount: Int32) {
        var pixelCount: Int32 = 0
        let result = bgfx_get_result(handle, &pixelCount).rawValue
        
        return (result: OcclusionQueryResult(rawValue: result)!, pixelCount: pixelCount)
    }
    
    /// Creates a new occlusion query
    public init() {
        handle = bgfx_create_occlusion_query()
    }
    
    deinit {
        bgfx_destroy_occlusion_query(handle)
    }
    
    /// Sets the condition for which the query should check
    public func setCondition(visible: Bool) {
        bgfx_set_condition(handle, visible)
    }
}
