// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

public protocol IOError : Error {
    
}

public enum ReaderError : Error {
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
