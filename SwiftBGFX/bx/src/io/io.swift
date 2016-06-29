//
//  Reader.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/25/16.
//  Copyright © 2016 SGC. All rights reserved.
//

public protocol IOError : ErrorProtocol {
    
}

public enum ReaderError : ErrorProtocol {
    case eof
}

/// Reader is the protocol that wraps the basic read method.
public protocol Reader {
    /// read reads up to `dest.count` bytes into `dest`
    ///
    /// - throws: `IOError.EOF`
    ///
    func read(_ dest: inout [UInt8]) throws -> Int;
}

/// Closer is the protocol that wraps the basic Close method.
///
/// Specific implementations may document their own behavior.
///
public protocol Closer {
    func close() throws
}
