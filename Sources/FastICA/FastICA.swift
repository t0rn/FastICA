import ClibICA

public func fastICA(_ signal: [[Double]], componentsCount: Int) -> [[Double]]? {
    let rows = signal.count
    let columns = signal.first!.count
    
    let X = UnsafeMutablePointer<UnsafeMutablePointer<Double>?>.allocate(capacity: rows)
    X.initialize(repeating: nil, count: rows)
    
    var rowPointers = [UnsafeMutablePointer<Double>]()
    
    for (rowIndex, rowValue) in signal.enumerated() {
        let p = UnsafeMutablePointer<Double>.allocate(capacity: columns)
        p.initialize(repeating: 0, count: columns)
        rowPointers.append(p)
        rowValue.enumerated().forEach { (colIndex, colValue) in
            X[rowIndex] = p
            X[rowIndex]?[colIndex] = colValue
        }
    }
    
    defer {
        rowPointers.forEach{ pointer in
            pointer.deinitialize(count: columns)
            pointer.deallocate()
        }
        S?.deinitialize(count: columns)
        S?.deallocate()
    }
    
    let S = calcFastICA(X, Int32(rows), Int32(columns), Int32(componentsCount))
    //convert to matrix
    guard let pointer = S else {return nil}
    var components = [[Double]]()
    for r in 0..<rows {
        var cols = [Double]()
        for c in 0..<columns {
            let value = pointer[r]![c]
            cols.append(value)
        }
        components.append(cols)
    }
    return components
}
