//
//  DWActionButton.swift
//  DWActionsMenu
//
//  Created by Dingzhong Weng on 24/12/2014.
//  Copyright (c) 2014 Dingzhong Weng. All rights reserved.
//

import UIKit
import Foundation


class DWActionButton: UIButton{
    let C = Constants()
    var action : DWAction{
        get {
            if (_action == nil){
                _action = DWAction()
            }
            return _action!
        }
        set {
            _action = newValue
        }
    }
    var gridPath : DWGridPath {
        get {
            if (_gridPath == nil){
                _gridPath = DWGridPath(row: 0, col: 0)
            }
            return _gridPath!
        }
        set {
            _gridPath = newValue
        }
    }
    
    var _gridPath : DWGridPath?
    var _action : DWAction?
    var target: AnyObject?
    var actionImageView : UIImageView?
    
    init(frame:CGRect,gridPath:DWGridPath,target:AnyObject?,action:DWAction){
        super.init(frame: frame)
        self.contentEdgeInsets = UIEdgeInsetsMake(C.kBUTTONINSET,C.kBUTTONINSET,C.kBUTTONINSET,C.kBUTTONINSET)
        _gridPath = gridPath
        _action = action
        self.target = target
        self.updateButton()
        self.addTarget(self, action: "highlighted", forControlEvents: UIControlEvents.TouchDown)
        self.addTarget(self, action: "dehighlighted", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.updateButton()
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        // this method assures that this button will have at least 44*44px hit box
        let bounds = self.bounds
        var left : CGFloat = 0
        var right : CGFloat = 0
        var top : CGFloat = 0
        var bottom : CGFloat = 0
        if (bounds.width<44){
            let xOffset = (44.0 - bounds.width)/2
            left = xOffset
            right = xOffset
        }
        if (bounds.height<44){
            let yOffset = (44.0 - bounds.height)/2
            top = yOffset
            bottom = yOffset
        }
        
        var hitBox = UIEdgeInsetsInsetRect(bounds,UIEdgeInsetsMake(top, left, bottom, right))
        
        return CGRectContainsPoint(hitBox,point)
        
    }
    
    func updateButton(){
        //add text, but display is overwritten by image
        self.setTitle(self.action.title, forState: UIControlState.Normal)
        self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        //add image
        if let imageNamed = action.imageNamed{
            if (actionImageView == nil){
                actionImageView = UIImageView(frame: CGRectMake(C.kBUTTONINSET,C.kBUTTONINSET, C.kBUTTONIMAGESIZE, C.kBUTTONIMAGESIZE))
                actionImageView!.contentMode = UIViewContentMode.Center;
                self.addSubview(actionImageView!)
            }
            
            actionImageView!.image = UIImage(named: imageNamed)
            self.setTitle(nil, forState: UIControlState.Normal)
        }
        
        
        //link action
        self.addTarget(self.target, action: NSSelectorFromString(action.selString), forControlEvents: .TouchUpInside)
    }
    
    func highlighted(){
        if let highlightedImageNamed = self.action.highlightedImageNamed{
            actionImageView!.image = UIImage(named: highlightedImageNamed)
            self.setTitle(nil, forState: UIControlState.Normal)
        }
    }
    
    func dehighlighted(){
        if let imageNamed = action.imageNamed{
            actionImageView!.image = UIImage(named: imageNamed)
            self.setTitle(nil, forState: UIControlState.Normal)
        } else {
            self.setTitle(self.action.title, forState: UIControlState.Normal)
        }
    }
}
