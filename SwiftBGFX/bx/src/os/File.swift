//
//  File.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/25/16.
//  Copyright © 2016 SGC. All rights reserved.
//

import Foundation

public enum FileError : IOError {
    case PathError(String, String, Int32)
}

public struct File {
    let fd: UnsafeMutablePointer<FILE>
    let name: String
}

extension File: Reader {
    public func read(inout dest: [UInt8]) throws -> Int {
        let c = fread(&dest, 1, dest.count, fd)
        
        return c
    }
}

extension File: Closer {
    public func close() throws {
        fclose(fd)
    }
}

public func open(path: String) throws -> File {
    return try openFile(path)
}

internal func openFile(path: String) throws -> File {
    let fd = fopen(path, "r")
    guard fd != nil else {
        throw FileError.PathError("open", path, errno)
    }
    
    return File(fd: fd, name: path)
}