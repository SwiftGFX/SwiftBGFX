// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

protocol IOError : Error {
    
}

enum ReaderError : Error {
    case eof
}

/// Reader is the protocol that wraps the basic read method.
protocol Reader {
    /// read reads up to `dest.count` bytes into `dest` from the underlying
    /// stream
    ///
    /// - throws: `IOError.EOF`
    ///
    func read(_ dest: inout [UInt8]) throws -> Int;
}

/// Writer is the protocol that wraps the basic write method.
protocol Writer {
    
    /// write writes up to `data.count` bytes to the underlying stream
    ///
    /// - throws: `IOError.
    ///
    /// - returns: the number of bytes written to the stream
    func write<T>(_ data:[T]) throws -> Int;
}

typealias ReadWriter = Reader & Writer

/// Closer is the protocol that wraps the basic Close method.
///
/// Specific implementations may document their own behavior.
///
protocol Closer {
    func close() throws
}
