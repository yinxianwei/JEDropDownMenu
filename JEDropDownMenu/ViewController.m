//
//  ViewController.m
//  JEDropDownMenu
//
//  Created by 尹现伟 on 15/4/7.
//  Copyright (c) 2015年 上海美问信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import "JEDropDownMenu.h"

@interface ViewController ()<JEDropDownMenuDataSouce,JEDropDownMenuDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    JEDropDownMenu *menu = [[JEDropDownMenu alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
    
    menu.delegate = self;
    menu.dataSouce = self;
    
    [self.view addSubview:menu];
    
}



- (void)dropDownMenu:(JEDropDownMenu *)menu didSelctedOfTitleIndex:(NSInteger)index
             leftRow:(NSInteger)leftIndex
            rightRow:(NSInteger)rightIndex
         isHaveLower:(BOOL)haveLower
          isSeparate:(BOOL)isSeparate{
    
}

- (NSString *)dropDownMenu:(JEDropDownMenu *)menu leftTitleAtIndexPath:(NSIndexPath *)indexPath{
    return [NSString stringWithFormat:@"-%ld-%ld-",indexPath.section,indexPath.row];
}
- (NSString *)dropDownMenu:(JEDropDownMenu *)menu rightTitleAtIndexPath:(NSIndexPath *)indexPath titleRow:(NSInteger)titleRow{
    return [NSString stringWithFormat:@"%ld-%ld-%ld",indexPath.section,indexPath.row,titleRow];
}
//选择数据的行数（左右）
- (NSInteger)dropDownMenu:(JEDropDownMenu *)menu leftRowAtIndex:(NSInteger)index{
    return index+2;
}
- (NSInteger)dropDownMenu:(JEDropDownMenu *)menu rightRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        return 0;
//    }
    return 4;
}

- (BOOL)titltHaveLoswerAtIndex:(NSInteger)index{
    if (index == 2) {
        return NO;
    }
    return YES;
}
//是否有第二级选项内容
- (BOOL)leftRowHaveLowerAtTitleIndex:(NSInteger)index leftRow:(NSInteger)leftRow{
//    if (leftRow == 0) {
//        return NO;
//    }
    return YES;
}

- (NSString *)dropDownMenu:(JEDropDownMenu *)menu titleAtIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"-%ld-",index];
}

- (NSInteger)numberOfRowDropDownMenu:(JEDropDownMenu *)menu{
    return 4;
}

- (void)dropDownMenu:(JEDropDownMenu *)menu didSelctedOfTitleIndex:(NSInteger)index{
    
    
//    NSLog(@"---%ld",(long)index);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
