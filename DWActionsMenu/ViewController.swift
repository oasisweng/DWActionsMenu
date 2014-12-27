//
//  ViewController.swift
//  DWActionsMenu
//
//  Created by Dingzhong Weng on 24/12/2014.
//  Copyright (c) 2014 Dingzhong Weng. All rights reserved.
//

import UIKit

class ViewController: UIViewController,DWActionsMenuDelegate {

    @IBOutlet var actionsMenu: DWActionsMenu!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        actionsMenu.delegate = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        var actions: [DWAction] = []
        for i in "abcdefghi"{
            actions.append(DWAction(selString: String(i), title: String(i), imageNamed: "placeholder", highlightedImageNamed: nil))
        }
        actionsMenu.actions = actions

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func actionsMenuDidResize(actionsMenu: DWActionsMenu, translation: CGPoint) {
        println("Actions menu resize to frame \(actionsMenu.frame)")
    }
    
    func a(){
        println("a")
    }
    
    func b(){
        println("b")
    }
    
    func c(){
        println("c")
    }
    
    func d(){
        println("d")
    }
    
    func e(){
        println("e")
    }
    
    func f(){
        println("f")
    }
    
    func g(){
        println("g")
    }
    
    func h(){
        println("h")
    }
    
    func i(){
        
    }
}

