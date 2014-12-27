//
//  DWGridPath.swift
//  DWActionsMenu
//
//  Created by Dingzhong Weng on 24/12/2014.
//  Copyright (c) 2014 Dingzhong Weng. All rights reserved.
//

import UIKit
import Foundation

class DWGridPath: NSObject{
    var row : Int{
        get {
            return _row
        }
        set {
            _row = newValue
        }
    }
    var _row: Int
    var col : Int{
        get {
            return _col
        }
        set {
            _col = newValue
        }
    }
    var _col : Int
    
    override var description: String {
        return "GridPath(\(row),\(col))"
    }
    
    init(row:Int,col:Int){
        _row = row
        _col = col
    }
    
    func equals(g:DWGridPath) -> Bool{
        return ((g.row == self.row) && (g.col == self.col))
    }
    

    
}