//
//  ResizeControl.swift
//  DWActionsMenu
//
//  Created by Dingzhong Weng on 24/12/2014.
//  Copyright (c) 2014 Dingzhong Weng. All rights reserved.
//

import UIKit
import Foundation

protocol DWResizeControlDelegate {
    func resizeControlShouldSlide(translation:CGPoint) -> Bool
    func resizeControlDidSlide(translation:CGPoint,resizeControl:DWResizeControl)
}


class DWResizeControl: UIView {
    let kIndicatorSize = CGSizeMake(32, 2)
    let C = Constants()
    
    var delegate:DWResizeControlDelegate?
    init(parentView: UIView) {
        super.init(frame: CGRectMake(0, 0, parentView.frame.size.width, C.kRESIZECONTROLHEIGHT))
        //handle dragging, but only move vertically
        var panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
        self.addGestureRecognizer(panGesture)
        
        //initial background color
        self.backgroundColor = UIColor(red: 149/255, green: 165/255, blue: 166/255, alpha: 0.75)
        
        //add self to parent view
        parentView.addSubview(self)
        
        println("Resize Control init done")
        
    }
    
    convenience init(parentView: UIView, delegate:DWResizeControlDelegate) {
        self.init(parentView:parentView)
        
        //set delegate
        self.delegate = delegate
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(dirtyRect: CGRect) {
        super.drawRect(dirtyRect)
        println("drawRect Resize Control bound \(bounds)")
        var center = CGPointMake(bounds.size.width/2, bounds.size.height/2)
        var origin = CGPointMake(center.x-kIndicatorSize.width/2, (C.kRESIZECONTROLHEIGHT-kIndicatorSize.height)/2)
        var path = UIBezierPath()
        path.moveToPoint(origin)
        path.addLineToPoint(CGPointMake(origin.x+kIndicatorSize.width,origin.y))
        path.addLineToPoint(CGPointMake(origin.x+kIndicatorSize.width,origin.y+kIndicatorSize.height))
        path.addLineToPoint  (CGPointMake(origin.x,origin.y+kIndicatorSize.height))
        path.addLineToPoint(origin)
        UIColor.whiteColor().setStroke()
        UIColor.whiteColor().setFill()
        path.stroke()
        path.fill()
    }
    
    
    func handlePan(sender:UIPanGestureRecognizer){
        var translation = sender.translationInView(self)
        
        println("pan gesture recognized \(translation)")
        if ((self.delegate?.resizeControlShouldSlide(translation)) == true){
            self.delegate?.resizeControlDidSlide(translation,resizeControl: self)
        }
        
        //reset pan gesture recognizer
        sender.setTranslation(CGPointZero, inView: self)
        
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        
        var hitBox = UIEdgeInsetsInsetRect(bounds,UIEdgeInsetsMake(-22, 0, -22, -22))
        
        println("hitbox \(hitBox) vs original \(bounds) and point \(point)")
        return CGRectContainsPoint(hitBox,point)
    }
    
}