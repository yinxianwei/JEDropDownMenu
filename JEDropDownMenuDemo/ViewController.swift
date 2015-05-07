//
//  ViewController.swift
//  JEDropDownMenuDemo
//
//  Created by 尹现伟 on 15/5/7.
//  Copyright (c) 2015年 尹现伟. All rights reserved.
//

import UIKit

class ViewController: UIViewController,DropDownMenuDataSouce,DropDownMenuDelegate {
    
    var reservationArray:NSMutableArray = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.initSubViews();
        
        self.loadData();
    }
    
    func initSubViews(){
        var drop = JEDropDownMenu(frame: CGRectMake(0, 64, self.view.frame.size.width, 40))
        drop.dataSouce = self;
        drop.delegate = self;
        self.view.addSubview(drop);
        
        
    }
    func loadData(){
        
    }
    func dropDownMenu(menu: JEDropDownMenu!, didSelecedLeftRowAtIndex index: JEIndexModel!) {
        println("点击了---->>\(index.titleIndex)--\(index.segmentedIndex)--\(index.leftIndex)")
        
    }
    func dropDownMenu(menu: JEDropDownMenu!, didSelecedRightRowAtIndex index: JEIndexModel!) {
        println("点击了---->>\(index.titleIndex)--\(index.segmentedIndex)--\(index.leftIndex)--\(index.rightIndex)")
    }
    
    func dropDownMenu(menu: JEDropDownMenu!, leftRowNumAtIndex indexModel: JEIndexModel!) -> Int {
        
        return Int(arc4random()%10+2);
    }
    
    func dropDownMenu(menu: JEDropDownMenu!, leftTitleAtIndex indexModel: JEIndexModel!) -> String! {
        return "xx22xx";
    }
    func dropDownMenu(menu: JEDropDownMenu!, rightTitleAtIndex indexModel: JEIndexModel!) -> String! {
        
        return "xxxz2";
    }
    
    func dropDownMenu(menu: JEDropDownMenu!, titleAtIndex index: Int) -> String! {
        return "标题"
    }
    func numberOfRowDropDownMenu(menu: JEDropDownMenu!) -> Int {
        return 3;
    }
    
    
    func dropDownMenu(menu: JEDropDownMenu!, rightRowNumAtIndex indexModel: JEIndexModel!) -> Int {
        return Int(arc4random()%10+2);
    }
    func segmentedForTitleIndex(index: Int) -> Int {
        if index == 0{
            return 2
        }
        else{
            return 0;
        }
    }
    
    func multipleOptionsAtTitleIndex(index: Int) -> Bool {
        if index == 0{
            return false
        }
        else{
            return true;
        }
    }
    func leftRowIsSelectClick(indexModel: JEIndexModel!) -> Bool {

        if indexModel.titleIndex == 0 && indexModel.leftIndex == 0{
            
            return true;
        }
        return false;
    }
    
    func segmentedTitleIndex(index: Int, segIndex: Int) -> String! {
        if index == 0{
            return segIndex == 0 ? "商圈" :"地铁"
        }
        return "";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

