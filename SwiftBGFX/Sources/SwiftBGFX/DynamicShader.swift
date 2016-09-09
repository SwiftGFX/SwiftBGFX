// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

internal class DynamicShader {
    let language: ShaderLanguage
    let type: ShaderType
    
    var source: String
    private var uniforms: [Uniform]
    
    public var memory: MemoryBlock {
        let mb = MemoryBuffer()
        writeHeader(mb)
        writeUniforms(mb)
        writeSource(mb)
        
        return MemoryBlock(data: mb.data)
    }
    
    public init(source: String, language: ShaderLanguage, type: ShaderType) {
        self.source = source
        self.language = language
        self.type = type
        self.uniforms = []
    }
    
    public func add(uniformName: String, type: UniformType) -> Self {
        let num = UInt16(uniforms.count)
        uniforms.append(Uniform(name: uniformName, type: type, num: UInt8(num), regIndex: 0, regCount: num))
        return self
    }
    
    private func writeHeader(_ mb: MemoryBuffer) {
        switch type {
        case .vertex:
            mb.write("VSH\u{04}".utf8.map { UInt8($0) })
        case .fragment:
            mb.write("FSH\u{04}".utf8.map { UInt8($0) })
        case .compute:
            mb.write("CSH\u{02}".utf8.map { UInt8($0) })
        }
        
        mb.write(Int32(0x0000_0000)) // iohash
    }
    
    private func writeUniforms(_ mb: MemoryBuffer) {
        mb.write(UInt16(uniforms.count))
        for u in uniforms {
            mb.write(u.name)
            mb.write(UInt8(u.type.rawValue))
            mb.write(u.num)
            mb.write(u.regIndex)
            mb.write(u.regCount)
        }
    }
    
    private func writeSource(_ mb: MemoryBuffer) {
        mb.write(source)
        mb.write(UInt8(0))
    }
    
    private struct Uniform {
        var name: String
        var type: UniformType
        var num: UInt8
        var regIndex: UInt16
        var regCount: UInt16
    }
}

private class MemoryBuffer {
    var data: [UInt8]
    
    public init() {
        data = []
    }
    
    @discardableResult
    public func write(_ d: Int32) -> Int {
        data.append(UInt8((d >> 0x18) & 0xff))
        data.append(UInt8((d >> 0x10) & 0xff))
        data.append(UInt8((d >> 0x08) & 0xff))
        data.append(UInt8((d >> 0x00) & 0xff))
        return 4
    }
    
    @discardableResult
    public func write(_ d: [UInt8]) -> Int {
        data.append(contentsOf: d)
        return d.count
    }
    
    @discardableResult
    public func write(_ d: String) -> Int {
        let n = d.utf8.map { UInt8($0) }
        write(Int32(n.count))
        data.append(contentsOf: n)
        return n.count
    }
    
    @discardableResult
    public func write(_ d: UInt8) -> Int {
        data.append(d)
        return 1
    }
    
    @discardableResult
    public func write(_ d: UInt16) -> Int {
        data.append(UInt8((d >> 0x08) & 0xff))
        data.append(UInt8((d >> 0x00) & 0xff))
        return 2
    }
}
