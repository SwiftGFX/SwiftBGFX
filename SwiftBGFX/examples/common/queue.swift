/**
 Queue implements a FIFO container
 
 - remark: Supports exactly one producer and once consumer on separate threads
 */
public final class Queue<T> {
    
    typealias Element = T
    
    var _front: _QueueItem<T>
    var _back: _QueueItem<T>
    
    public init () {
        // Insert dummy item. Will disappear when the first item is added.
        _back = _QueueItem(nil)
        _front = _back
    }
    
    /// Add a new item to the back of the queue.
    public func enqueue(_ value: T) {
        _back.next = _QueueItem(value)
        _back = _back.next!
    }
    
    /// Return and remove the item at the front of the queue.
    public func dequeue() -> T? {
        guard let newhead = _front.next else {
            return nil
        }
        
        _front = newhead
        return newhead.value
    }
    
    public func front() -> T? {
        return _front.next?.value
    }
    
    public func isEmpty() -> Bool {
        return _front === _back
    }
}

final class _QueueItem<T> {
    let value: T?
    var next: _QueueItem?
    
    init(_ newvalue: T?) {
        self.value = newvalue
    }
}
