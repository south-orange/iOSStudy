//
//
//  ViewController.swift
//  MetalDemo
//
//  Created by 霍橙 on 2021/7/9.
//  
//
    

import UIKit


class ViewController: UIViewController {
    
    var view01: HCMTKView01!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view01 = HCMTKView01.init(frame: self.view.bounds)
        view.addSubview(view01)
    }
    
}

