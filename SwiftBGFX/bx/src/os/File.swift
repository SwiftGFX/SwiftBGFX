// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

#if os(Linux)
import Glibc
#else
import Darwin
#endif

public enum FileError : IOError {
    case pathError(String, String, Int32)
}

public struct File {
    let fd: UnsafeMutablePointer<FILE>
    let name: String
}

extension File: Reader {
    public func read(_ dest: inout [UInt8]) throws -> Int {
        let c = fread(&dest, 1, dest.count, fd)
        
        return c
    }
}

extension File: Closer {
    public func close() throws {
        fclose(fd)
    }
}

public func open(_ path: String) throws -> File {
    return try openFile(path)
}

internal func openFile(_ path: String) throws -> File {
    let fd = fopen(path, "r")
    guard fd != nil else {
        throw FileError.pathError("open", path, errno)
    }
    
    return File(fd: fd!, name: path)
}
