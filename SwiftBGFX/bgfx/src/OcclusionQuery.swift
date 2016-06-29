//
//  occlusionquery.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/22/16.
//  Copyright © 2016 SGC. All rights reserved.
//


/// Represents an occlusion query
public class OcclusionQuery {
    let handle: bgfx_occlusion_query_handle_t
    
    /// Gets the result of the query
    public var result: OcclusionQueryResult {
        return OcclusionQueryResult(rawValue: bgfx_get_result(handle).rawValue)!
    }
    
    /// Initializes a new occlusion query
    public init() {
        handle = bgfx_create_occlusion_query()
    }
    
    deinit {
        bgfx_destroy_occlusion_query(handle)
    }
    
    /// Sets the condition for which the query should check
    public func setCondition(_ visible: Bool) {
        bgfx_set_condition(handle, visible)
    }
}
