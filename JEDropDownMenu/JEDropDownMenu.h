//
//  JEDropDownMenu.h
//  JEDropDownMenu
//
//  Created by 尹现伟 on 15/4/7.
//  Copyright (c) 2015年 上海美问信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JEDropDownMenu;

@protocol JEDropDownMenuDelegate <NSObject>

@optional
- (void)dropDownMenu:(JEDropDownMenu *)menu didSelctedOfTitleIndex:(NSInteger)index;

/**
 *  @author 尹现伟, 15-04-07 15:04:29
 *
 *  点击菜单代理
 *
 *  @param menu       菜单对象
 *  @param index      标题索引
 *  @param leftIndex  左侧选项索引
 *  @param rightIndex 右侧选项索引
 *  @param haveLower  是否有第二层选项内容
 *  @param isSeparate 是否有第二层选项
 */
- (void)dropDownMenu:(JEDropDownMenu *)menu didSelctedOfTitleIndex:(NSInteger)index
             leftRow:(NSInteger)leftIndex
            rightRow:(NSInteger)rightIndex
         isHaveLower:(BOOL)haveLower
          isSeparate:(BOOL)isSeparate;

@end


@protocol JEDropDownMenuDataSouce <NSObject>

- (NSString *)dropDownMenu:(JEDropDownMenu *)menu titleAtIndex:(NSInteger)index;

- (NSInteger)numberOfRowDropDownMenu:(JEDropDownMenu *)menu;

//选择数据的行数（左右）
- (NSInteger)dropDownMenu:(JEDropDownMenu *)menu leftRowAtIndex:(NSInteger)index;
- (NSInteger)dropDownMenu:(JEDropDownMenu *)menu rightRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)dropDownMenu:(JEDropDownMenu *)menu leftTitleAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)dropDownMenu:(JEDropDownMenu *)menu rightTitleAtIndexPath:(NSIndexPath *)indexPath titleRow:(NSInteger)titleRow;

//某行是否有第二级选项内容
- (BOOL)leftRowHaveLowerAtTitleIndex:(NSInteger)index leftRow:(NSInteger)leftRow;

//某列是否有第二级选项
- (BOOL)titltHaveLoswerAtIndex:(NSInteger)index;

@end

@interface JEDropDownMenu : UIView<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, weak) id<JEDropDownMenuDelegate>delegate;
@property (nonatomic, weak) id<JEDropDownMenuDataSouce>dataSouce;



/*
 1. 数据源
 2. 标题列数
 3. 标题内容
 3. 左侧分类
 4. 右侧分类
 5. 是否分页
 # 代理
 1. 点击标题
 2. 点击左侧是否展开数据
 3. 点击右侧
 
 */
@end
