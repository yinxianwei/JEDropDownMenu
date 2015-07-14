//
//  JEDropDownMenu.h
//
//  Created by 尹现伟 on 15/5/6.
//  Copyright (c) 2015年 尹现伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TITLE_BG_IMAGE @"action_button_bg"

#define TITLE_IMAGE @"btn_down"

#define TITLE_IMAGE_LINE @"image_line_v"

@class JEDropDownMenu,JEIndexModel;

@protocol DropDownMenuDelegate <NSObject>

@optional
//左侧
- (void)dropDownMenu:(JEDropDownMenu *)menu didSelecedLeftRowAtIndex:(JEIndexModel *)index;

//右侧
- (void)dropDownMenu:(JEDropDownMenu *)menu didSelecedRightRowAtIndex:(JEIndexModel *)index;

//标题
- (void)dropDownMenu:(JEDropDownMenu *)menu didSelecedTitleAtIndex:(NSInteger)index;

@end


@protocol DropDownMenuDataSouce <NSObject>
//MARK: - dataSource
@required
//*1. 多少列
- (NSInteger)numberOfRowDropDownMenu:(JEDropDownMenu *)menu;

//*3. 某列某个分段下左侧列表数
- (NSInteger)dropDownMenu:(JEDropDownMenu *)menu leftRowNumAtIndex:(JEIndexModel *)indexModel;

//*6. 某列某个分段下左侧列表标题
- (NSString *)dropDownMenu:(JEDropDownMenu *)menu leftTitleAtIndex:(JEIndexModel *)indexModel;

//*9. 按钮标题
- (NSString *)dropDownMenu:(JEDropDownMenu *)menu titleAtIndex:(NSInteger)index;


@optional
//2. 某列下有多少分段(>1有效)
- (NSInteger)segmentedForTitleIndex:(NSInteger)index;
//9. 分段标题
- (NSString *)segmentedTitleIndex:(NSInteger)index segIndex:(NSInteger)segIndex;
//4. 某列某个分段某个左侧行下二级选项数(不实现则为下拉单选列表)
- (NSInteger)dropDownMenu:(JEDropDownMenu *)menu rightRowNumAtIndex:(JEIndexModel *)indexModel;
//5. 某列某个分段下左侧列表某行是否有二级选项(此处主要区分有二级选项但无内容和无二级选项(如：全部))(不实现则为下拉单选列表)
- (BOOL)leftRowIsSelectClick:(JEIndexModel *)indexModel;
//7. 某列某个分段某个左侧行下二级选项标题
- (NSString *)dropDownMenu:(JEDropDownMenu *)menu rightTitleAtIndex:(JEIndexModel *)indexModel;
//8. 某列下是否为单选（一个列表无二级）
- (BOOL)multipleOptionsAtTitleIndex:(NSInteger)index;


@end

@interface JEDropDownMenu : UIView


@property (nonatomic, assign) id<DropDownMenuDataSouce> dataSouce;

@property (nonatomic, assign) id<DropDownMenuDelegate> delegate;

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *titleBgImageView;
@property (nonatomic, strong) UIImageView *segBgImageView;

- (void)dismiss;

- (void)reloadData;
@end





@interface JEIndexModel : NSObject

@property (nonatomic, assign) NSInteger titleIndex;
@property (nonatomic, assign) NSInteger segmentedIndex;
@property (nonatomic, assign) NSInteger leftIndex;
@property (nonatomic, assign) NSInteger rightIndex;

+ (instancetype)tIndex:(NSInteger)t segIndex:(NSInteger)s leftIndex:(NSInteger)l rightIndex:(NSInteger)r;

@end


@interface  DropDownCell : UITableViewCell

@property (nonatomic, assign) BOOL isSelect;

@end

