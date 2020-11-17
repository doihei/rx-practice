//___FILEHEADER___

import Foundation
import Reusable

// MARK: - Section
extension ___VARIABLE_productName___ {
    
    enum Section {
        // TODO: enum section
    }
}

// MARK: - SectionProtocol
extension ___VARIABLE_productName___.Section: SectionProtocol {
    
    typealias DataType = ___VARIABLE_productName___
    typealias CellType = Cell
    typealias HeaderType = Any
    typealias FooterType = Any
    
    var numberOfRows: Int {
        switch self {
            // TODO: section numberOfRows
        }
    }
    
    func cellType(at row: Int) -> ___VARIABLE_productName___.Section.Cell {
        switch self {
            // TODO: section cellType
        }
    }
}

// MARK: - Cell
extension Home.Section {
    
    enum Cell {
        // TODO: enum cell
    }
}

// MARK: - CellTypeProtocol
extension ___VARIABLE_productName___.Section.Cell: CellTypeProtocol {
    
    static var allCells: [NibReusable.Type] {
        return [
            // TODO: cell of NibReusable array
        ]
    }
    
    var type: NibReusable.Type {
        switch self {
            // TODO: cell of NibReusable type
        }
    }
}
