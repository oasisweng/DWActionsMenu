//
//  DWAction.swift
//  DWActionsMenu
//
//  Created by Dingzhong Weng on 27/12/2014.
//  Copyright (c) 2014 Dingzhong Weng. All rights reserved.
//

import Foundation
import UIKit

class DWAction: NSObject{
    var selString:String = ""
    var title:String?
    var imageNamed:String?
    var highlightedImageNamed:String?
    
    override init(){
        self.title = "?"
    }
    
    init(selString:String,title:String?,imageNamed:String?,highlightedImageNamed:String?) {
        super.init()
        
        self.selString = selString
        
        if (title != nil) {
            self.title = title
        }
        
        if (imageNamed != nil) {
            self.imageNamed = imageNamed
        }
        
        if (highlightedImageNamed != nil){
            self.highlightedImageNamed = highlightedImageNamed
        }

    }
}