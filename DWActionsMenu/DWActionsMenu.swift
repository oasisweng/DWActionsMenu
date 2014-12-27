//
//  DWActionsMenu.swift
//  DWActionsMenu
//
//  Created by Dingzhong Weng on 24/12/2014.
//  Copyright (c) 2014 Dingzhong Weng. All rights reserved.
//

import UIKit
import Foundation

infix operator =?{ associativity left precedence 90 }
func =?(a:DWGridPath,b:DWGridPath) -> Bool{
    return ((a.row == b.row) && (a.col == b.col))
}

@objc protocol DWActionsMenuDelegate{
    optional func actionsMenuWillResize(actionsMenu:DWActionsMenu,translation:CGPoint)
    optional func actionsMenuDidResize(actionsMenu:DWActionsMenu,translation:CGPoint)
}


class DWActionsMenu : UIView, DWResizeControlDelegate{
    var rows : Int?
    var maxRows : Int?
    var maxVisibleCols : Int?
    var actions : [DWAction]{
        get{
            if _actions == nil {
                _actions = []
            }
            
            return _actions!
        }
        set {
            _actions = newValue
            setUp()

        }
        
    }
    private var actionButtons : [DWActionButton]{
        get{
            if (_actionButtons == nil){
                _actionButtons = []
            }
            return _actionButtons!
        }
        set{
            _actionButtons = newValue
        }
    }
    
    @IBOutlet var target : UIViewController?
    var resizeControl : DWResizeControl?
    var menuView:UIScrollView?
    var delegate:DWActionsMenuDelegate?
    
    var _actions : [DWAction]?
    var _actionButtons : [DWActionButton]?
    var _intrinsicContentSize : CGSize = CGSizeMake(320, 56)
    
    init(target:UIViewController,actions:[DWAction],delegate:DWActionsMenuDelegate){
        super.init(frame: CGRectMake(0,
            target.view.frame.height-Constants.kMENUHEIGHT-Constants.kRESIZECONTROLHEIGHT,
            target.view.frame.width,
            Constants.kMENUHEIGHT+Constants.kRESIZECONTROLHEIGHT))
        self._actions = actions
        self.target = target
        self.delegate = delegate
        self._actionButtons = []
        
        setUp()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self._actions = []
        self._actionButtons = []
        
        self.backgroundColor = UIColor.clearColor()
        
    }
    
    override func drawRect(rect: CGRect) {
        println("action menu rect\(rect)")
    }
    
    private func setUp(){

        if (resizeControl == nil){
            //add resize control and menu view
            resizeControl = DWResizeControl(parentView: self, delegate: self)
        }
        
        resizeControl!.frame = CGRectMake(0, 0, self.frame.size.width, Constants.kRESIZECONTROLHEIGHT)
        
        if (menuView == nil){
            //add menuview
            menuView = UIScrollView(frame: CGRectMake(0, Constants.kRESIZECONTROLHEIGHT, self.frame.width, Constants.kMENUHEIGHT))
            menuView!.showsVerticalScrollIndicator = false;
            menuView!.showsHorizontalScrollIndicator = false;
            menuView!.backgroundColor = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1.0)
            self.addSubview(menuView!)
        }
        
        menuView!.frame = CGRectMake(0, Constants.kRESIZECONTROLHEIGHT, self.frame.width, Constants.kMENUHEIGHT)
        menuView!.contentSize = CGSizeMake(CGFloat(self.actions.count)*Constants.kMENUHEIGHT, Constants.kMENUHEIGHT)
 
        
        //compute maxrows and maxcols for future convinience, and initilize necessary variables
        prepare()
        
        //fill menu with set actions
        renderMenu()
    }

    func prepare(){
        maxVisibleCols = Int(self.frame.width/Constants.kMENUHEIGHT)
        if let count = self._actions?.count{
            maxRows = count / maxVisibleCols! + (count % maxVisibleCols!>0 ? 1 : 0)
        } else {
            maxRows = 1
        }
        println("maxVisibleCols \(maxVisibleCols) and maxRows \(maxRows)")
        
        rows = 1
        
        menuView!.contentSize = CGSizeMake(CGFloat(self.actions.count)*Constants.kMENUHEIGHT, Constants.kMENUHEIGHT)
        println("menuView contentSize \(menuView!.contentSize)")

    }
    
    func resizeControlShouldSlide(translation: CGPoint) -> Bool {
        let maxHeight = Constants.kMENUHEIGHT * CGFloat(maxRows!)
        if (self.menuView?.frame.height == maxHeight) && (translation.y<0){
            //if it is at max height and user tries to slide up
            return false
        }
        
        if (self.menuView?.frame.height == Constants.kMENUHEIGHT) && translation.y>0{
            //if it is at min height and user tries to slide down
            return false
        }
        
        if (translation.y == 0){
            return false
        }
        
        return true
    }
    
    func resizeControlDidSlide(translation: CGPoint, resizeControl: DWResizeControl) {
        var tMenuHeight = floor(self.menuView!.frame.height - translation.y)
        if (tMenuHeight>Constants.kMENUHEIGHT*CGFloat(self.maxRows!)){
            tMenuHeight = Constants.kMENUHEIGHT*CGFloat(self.maxRows!)
        } else if (tMenuHeight<Constants.kMENUHEIGHT) {
            tMenuHeight = Constants.kMENUHEIGHT
        }
        
        println("tMenuHeight \(tMenuHeight) vs height \(self.menuView!.frame.height)")
        
        //if did slide, move resize control and change the frame of actions menu, as well as its menu view
        //resize action view
        let y = self.frame.origin.y
        self.delegate?.actionsMenuWillResize?(self, translation: translation)
        self.frame = CGRectMake(0, y-(tMenuHeight-self.menuView!.frame.height), self.frame.width, tMenuHeight+Constants.kRESIZECONTROLHEIGHT)
        self.resizeControl?.frame = CGRectMake(0, 0, self.frame.width, Constants.kRESIZECONTROLHEIGHT)
        self.menuView?.frame = CGRectMake(0, Constants.kRESIZECONTROLHEIGHT, self.frame.width, tMenuHeight)
        self.delegate?.actionsMenuDidResize?(self, translation: translation)
        
        var tRows = Int(tMenuHeight / Constants.kMENUHEIGHT)
        println("tRows \(tRows) vs rows \(rows)")
        if (tRows != rows){
            rows = tRows
            
            //resize menu view contentSize
            var cols = self.actions.count/rows!
            
            //if cols is less than minimal cols per column, set it to min
            if (maxVisibleCols>cols){
                cols = maxVisibleCols!
            }
            
            menuView!.contentSize = CGSizeMake(CGFloat(cols)*Constants.kMENUHEIGHT, Constants.kMENUHEIGHT)
        }
        
        renderMenu()
        
    }
    
    func renderMenu(){
        for i in 0...self.actions.count-1 {
            var gridPath = self.getGridPathForIndex(i)
            
            if (i>=self.actionButtons.count){
                //button hasn't yet been created?
                var fromFrame = self.getFrameForGridPath(gridPath)
                //initially off position
                fromFrame.origin.x -= 3
                fromFrame.origin.y -= 1
                
                //create a button
                var actionButton = DWActionButton(frame: fromFrame, gridPath: gridPath, target:self.target, action: self.actions[i])
                
                self.actionButtons.append(actionButton)
                
                //add to menu view
                self.menuView!.addSubview(actionButton)
                
                //create a sliding effect for button to enter the view
                self.moveButton(actionButton, toGridPath: gridPath, animated: true)
                
                println("actionButton \(i) of grid path \(gridPath) has frame \(actionButton.frame)")
            } else {
                //button has been created?
                if ((self.actionButtons[i].gridPath =? gridPath) == false){
                    //has its position updated?
                    println("actionButton \(i) of grid path \(self.actionButtons[i].gridPath) is now at \(gridPath)")
                    self.moveButton(self.actionButtons[i], toGridPath: gridPath, animated: true)
                    self.actionButtons[i].gridPath = gridPath
                } else {
                    self.moveButton(self.actionButtons[i], toGridPath: gridPath, animated: false)
                }
                
                if let tTarget : AnyObject = self.actionButtons[i].allTargets().anyObject() {
                    if let tAction = self.actionButtons[i].actionsForTarget(tTarget, forControlEvent: UIControlEvents.TouchUpInside)?.first as? String{
                        //has its action updated?
                        if tAction != self.actions[i].selString{
                            //remove all actions relating to this button
                            self.actionButtons[i].removeTarget(nil, action: nil, forControlEvents: .TouchUpInside)
                            //add new action
                            self.actionButtons[i].addTarget(self.target, action: NSSelectorFromString(self.actions[i].selString), forControlEvents: UIControlEvents.TouchUpInside)
                            //add text, but display is overwritten by image
                        }
                    }
                }
            }
        }
        
        //remove extra buttons
        if (self.actionButtons.count>self.actions.count){
            for i in self.actionButtons.count ... self.actions.count+1{
                self.actionButtons[i].removeFromSuperview()
                self.actionButtons.removeLast()
            }
        }
    }
    
    func getFrameForGridPath(gridPath:DWGridPath)->CGRect{
        // button offset
        var rowHeight = (self.frame.size.height-resizeControl!.frame.size.height) / CGFloat(rows!)
        var vOffset = (rowHeight-Constants.kBUTTONSIZE)/2
        var hOffset = (Constants.kMENUHEIGHT-Constants.kBUTTONSIZE)/2
        vOffset = vOffset>0 ? vOffset : 0
        hOffset = hOffset>0 ? hOffset : 0
        // button grid path
        var row = gridPath.row
        var col = gridPath.col
        var x = Constants.kMENUHEIGHT*CGFloat(col) + hOffset
        var y = Constants.kMENUHEIGHT*CGFloat(row) + vOffset
        
        return CGRectMake(x, y, Constants.kBUTTONSIZE, Constants.kBUTTONSIZE)
    }
    
    func moveButton(button:DWActionButton,toGridPath:DWGridPath, animated:Bool){
        if (animated){
            // start animation
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                button.frame = self.getFrameForGridPath(toGridPath)
                }, completion:{(finished:Bool) -> Void in
            })
        } else {
            button.frame = self.getFrameForGridPath(toGridPath)
        }
    }
    
    func getGridPathForIndex(index:Int)->DWGridPath{
        // how many columns are there in each row(total)
        var cols = self.actions.count/rows!
        
        //if cols is less than minimal cols per column, set it to min
        if (maxVisibleCols>cols){
            cols = maxVisibleCols!
        }
        
        var row=index/cols
        var col=index%cols
        
        return DWGridPath(row: row, col: col)
    }
    
    
    //custom auto layout
    override func intrinsicContentSize() -> CGSize{
        return _intrinsicContentSize
    }
    
    override func alignmentRectInsets() -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
}