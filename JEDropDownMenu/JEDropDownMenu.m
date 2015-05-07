//
//  JEDropDownMenu.m
//
//  Created by 尹现伟 on 15/5/6.
//  Copyright (c) 2015年 尹现伟. All rights reserved.
//

#import "JEDropDownMenu.h"


#define JE_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]


@interface JEDropDownMenu()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong) UIControl *bgControl;

@property (nonatomic, strong) UIImageView *tabBgImageView;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;


@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) UITableView *leftTableView;

@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) NSMutableArray *segIndexArray;

@property (nonatomic, assign) NSInteger titleSelectIndex;

@property (nonatomic, assign) NSInteger leftSelectIndex;
@property (nonatomic, assign) NSInteger segmentedIndex;
/*
 col btn 背景 tabbg seg
  |   |   |   |     |
  |   |   |   |     tab
  |   |   |   |     |
  |   |   |   |     |
--->>>>
*/


@end

@implementation JEDropDownMenu




- (void)willMoveToSuperview:(UIView *)newSuperview{
    
//添加到父view的时候把需要的view试图放到父view上

    
    [self initTitle];
    
    [self initSubViewsInView:newSuperview];
    
    [super willMoveToSuperview:newSuperview];
    
}

//背景等初始化
- (void)initSubViewsInView:(UIView *)newSuperview{

    
    self.bgControl.frame = CGRectMake(self.frame.origin.x, self.frame.size.height+self.frame.origin.y, self.frame.size.width, newSuperview.frame.size.height - self.frame.size.height - self.frame.origin.y);
    [newSuperview addSubview:self.bgControl];
    self.bgControl.backgroundColor = [UIColor whiteColor];
    
    
    self.bgImageView.frame = CGRectMake(0, 0, self.bgControl.frame.size.width, self.bgControl.frame.size.height);
    self.bgImageView.backgroundColor = [UIColor lightGrayColor];
    [self.bgControl addSubview:self.bgImageView];
    
    
    self.tabBgImageView.frame = CGRectMake(0, -self.bgControl.frame.size.height/3*2, self.bgControl.frame.size.width, self.bgControl.frame.size.height/3*2);
    _tabBgImageView.backgroundColor = [UIColor whiteColor];
    _tabBgImageView.userInteractionEnabled = YES;
    [self.bgControl addSubview:_tabBgImageView];

    //TODO://分段选择UI优化
    
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@" ",@" "]];
    self.segmentedControl.center = CGPointMake(self.frame.size.width/2, 20);
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
    [self.tabBgImageView addSubview:self.segmentedControl];
    
    self.leftTableView.frame = CGRectMake(0, 0, newSuperview.frame.size.width/3, _tabBgImageView.frame.size.height);    
    self.rightTableView.frame = CGRectMake(self.leftTableView.frame.size.width, self.leftTableView.frame.origin.y, newSuperview.frame.size.width-self.leftTableView.frame.size.width, self.leftTableView.frame.size.height);

    
    
    self.bgControl.hidden = YES;
    if (self.superview) {
        [newSuperview insertSubview:self.bgControl belowSubview:self];
    }
}



- (void)segmentedClick:(id)sender{
    
    JEIndexModel *model = [self indexModelInTitleIndex:self.titleSelectIndex];
    model.segmentedIndex = self.segmentedControl.selectedSegmentIndex;
    self.leftSelectIndex = [self indexTitleIndex:self.titleSelectIndex withSegmendIndex:self.segmentedControl.selectedSegmentIndex].leftIndex;
    
    [self tabPlacedAtTheTop];
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
    
}

- (void)titleCilck:(id)sender{

    //当无数据时禁止显示下拉菜单
//    if ([self.dataSouce dropDownMenu:self leftRowNumAtIndex:[JEIndexModel tIndex:self.titleSelectIndex segIndex:self.segmentedControl.selectedSegmentIndex leftIndex:0 rightIndex:0]] == 0) {
//        return;
//    }
    if (!self.rightTableView.superview) {
        [_tabBgImageView addSubview:self.rightTableView];
        [_tabBgImageView addSubview:self.leftTableView];
    }
    
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag -100;
    
    CGAffineTransform transform = button.imageView.transform;
    transform = CGAffineTransformRotate(transform, M_PI);
    
    //重置左侧选择
    self.leftSelectIndex = [self indexTitleIndex:index withSegmendIndex:self.segmentedControl.selectedSegmentIndex].leftIndex;
    self.segmentedIndex = [self indexModelInTitleIndex:index].segmentedIndex;

    //显示
    if (self.bgControl.hidden) {
        self.titleSelectIndex = index;

        [UIView animateWithDuration:0.2 animations:^{
            button.imageView.transform = transform;

        }];
        [self showAnimation];
    }
    else if (self.titleSelectIndex != index) {
        UIButton *oldBtn = (UIButton *)[self viewWithTag:self.titleSelectIndex+100];
        self.titleSelectIndex = index;
        //切换
        [UIView animateWithDuration:0.2 animations:^{
            oldBtn.imageView.transform = CGAffineTransformIdentity;
            button.imageView.transform = transform;
            
            [self tabBGimageViewFrameyPos:-150];
            
        } completion:^(BOOL finished) {
            [self showAnimation];
        }];
        
    }
    else{
        [self dismiss];
    }
    
    
}

- (NSInteger)leftIndexInTitleIndex:(NSInteger)index withSegmentedIndex:(NSInteger)segindex{

    JEIndexModel *model = [self indexModelInTitleIndex:index];
    if (model.segmentedIndex == segindex) {
        return model.leftIndex;
    }
    return -1;
}

- (NSInteger)segmentedIndexInTitleIndex:(NSInteger)index{
    
    return [self indexModelInTitleIndex:index].segmentedIndex;
}



- (JEIndexModel *)indexTitleIndex:(NSInteger)index withSegmendIndex:(NSInteger)segIndex{
    JEIndexModel *model;
    if (self.segIndexArray.count<=index) {
        int count = (int)self.segIndexArray.count;
        
        for (int i = 0; i<(index+1-count); i++) {
            [self.segIndexArray addObject:[NSMutableArray new]];
        }
        
    }
    NSMutableArray *ary = self.segIndexArray[index];
    if (ary.count<= segIndex) {
        int count = (int)ary.count;
        
        for (int i = 0; i<(segIndex+1-count); i++) {
            [ary addObject:[JEIndexModel new]];
        }
    }
    model = self.segIndexArray[index][segIndex];
    model.titleIndex = index;
    model.segmentedIndex = segIndex;
    
    return model;
}

- (void)setTitle:(NSString *)title withIndex:(NSInteger)index{
    UIButton *button = (UIButton *)[self viewWithTag:index+100];
    [button setTitle:title forState:UIControlStateNormal];


}

- (JEIndexModel *)indexModelInTitleIndex:(NSInteger)index{
    JEIndexModel *model;
    if (self.selectArray.count>index) {
        model = self.selectArray[index];
    }
    else{
        int count = (int)self.selectArray.count;
        for (int i = 0; i<index+1 - count; i++) {
            JEIndexModel *indexModel = [JEIndexModel new];
            [self.selectArray addObject:indexModel];
        }
        model = self.selectArray[index];
        model.titleIndex = index;
    }
    return model;
}

- (void)tabPlacedAtTheTop{
    
    [_leftTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    [_rightTableView setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void)tabLoadData{
    [_leftTableView reloadData];
    [_rightTableView reloadData];
}
- (void)tabBGimageViewFrameyPos:(CGFloat)yPos{
    _tabBgImageView.frame = CGRectMake(0, yPos, _tabBgImageView.frame.size.width, _tabBgImageView.frame.size.height);
}

- (void)tabviewFrameyPos:(CGFloat)yPos{
    _leftTableView.frame = CGRectMake(_leftTableView.frame.origin.x, yPos, _leftTableView.frame.size.width, self.tabBgImageView.frame.size.height - yPos);
    
    _rightTableView.frame = CGRectMake(_rightTableView.frame.origin.x, yPos, _rightTableView.frame.size.width, _leftTableView.frame.size.height);
}

- (void)leftTabviewFrameWidth:(CGFloat)width{
    _leftTableView.frame = CGRectMake(_leftTableView.frame.origin.x, _leftTableView.frame.origin.y, width, _leftTableView.frame.size.height);
}

- (void)showAnimation{
    
    self.bgControl.hidden = NO;
    
    JEIndexModel *model = [self indexModelInTitleIndex:self.titleSelectIndex];
    self.segmentedControl.selectedSegmentIndex = model.segmentedIndex;
    
    [self tabPlacedAtTheTop];

    [self tabLoadData];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self tabBGimageViewFrameyPos:0];
        
        self.bgImageView.alpha = 0.6;
        
    } completion:^(BOOL finished) {
        
    }];
     //1. 是否漏出分段
    if ([self.dataSouce respondsToSelector:@selector(segmentedForTitleIndex:)] ) {
        int count = (int)[self.dataSouce segmentedForTitleIndex:self.titleSelectIndex];

        if (count>1) {
            
            
            if (count>self.segmentedControl.numberOfSegments) {
                for (int i =0 ; i<count - self.segmentedControl.numberOfSegments; i++) {
                    [self.segmentedControl insertSegmentWithTitle:@" " atIndex:0 animated:NO];
                }
                
            }
            else if (count<self.segmentedControl.numberOfSegments){
                for (int i =0 ; i<self.segmentedControl.numberOfSegments - count; i++) {
                    [self.segmentedControl removeSegmentAtIndex:0 animated:NO];
                }
            }
            
            for (int i = 0; i<count; i++) {
                if([self.dataSouce respondsToSelector:@selector(segmentedTitleIndex:segIndex:)]){
                    [self.segmentedControl setTitle:[self.dataSouce segmentedTitleIndex:self.titleSelectIndex segIndex:i] forSegmentAtIndex:i];
                }
            }
            self.segmentedControl.bounds = CGRectMake(0, 0, self.frame.size.width/3*2, 30);
            self.segmentedControl.center = CGPointMake(self.frame.size.width/2, self.segmentedControl.center.y);

            self.segmentedControl.hidden = NO;
            [self tabviewFrameyPos:40];

        }
        else{
            self.segmentedControl.hidden = YES;
            [self tabviewFrameyPos:0];
        }
    }
    else{
        self.segmentedControl.hidden = YES;
       [self tabviewFrameyPos:0];
    }
    //2. 是否单选列表
    //单选代理实现且为yes，右侧二级列表数量
    if ([self.dataSouce respondsToSelector:@selector(multipleOptionsAtTitleIndex:)] && [self.dataSouce multipleOptionsAtTitleIndex:self.titleSelectIndex]) {
        self.rightTableView.hidden = YES;
        [self leftTabviewFrameWidth:self.frame.size.width];
    }
    else{
        self.rightTableView.hidden = NO;
        [self leftTabviewFrameWidth:self.frame.size.width/3];
    }
    
    self.tabBgImageView.backgroundColor = [UIColor whiteColor];
}


- (void)dismiss{
    
    UIButton *oldBtn = (UIButton *)[self viewWithTag:self.titleSelectIndex+100];
    [UIView animateWithDuration:0.2 animations:^{
      
        oldBtn.imageView.transform = CGAffineTransformIdentity;
        _bgImageView.alpha = 0.0f;

        [self tabBGimageViewFrameyPos:-self.tabBgImageView.frame.size.height];

    }completion:^(BOOL finished) {
        _bgControl.hidden = YES;
    }];
}

//初始化标题按钮
- (void)initTitle{
    NSInteger row = [self.dataSouce numberOfRowDropDownMenu:self];
    CGFloat titleHeight = self.frame.size.height;
    CGFloat titleWidth  = self.frame.size.width/row;
    
    self.titleBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.titleBgImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleBgImageView];
    
    for (int i = 0; i<row; i++) {
        CGFloat xPos = i * titleWidth;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(xPos, 0, titleWidth, titleHeight)];
        
        button.tag = i+100;
        
        [button addTarget:self action:@selector(titleCilck:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [UIImage imageNamed:TITLE_IMAGE];
        [button setImage:image forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, titleWidth - image.size.width, 0, 0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, image.size.width)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setBackgroundImage:[UIImage imageNamed:TITLE_BG_IMAGE] forState:UIControlStateNormal];
        
        [button setTitle:[self.dataSouce dropDownMenu:self titleAtIndex:i] forState:UIControlStateNormal];

        [self addSubview:button];
    }
    
}


//MARK: - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        return [self.dataSouce dropDownMenu:self leftRowNumAtIndex:[JEIndexModel tIndex:self.titleSelectIndex segIndex:self.segmentedIndex leftIndex:0 rightIndex:0]];
    }
    else if (tableView == self.rightTableView){
        if([self.dataSouce respondsToSelector:@selector(dropDownMenu:rightRowNumAtIndex:)]){
            return [self.dataSouce dropDownMenu:self rightRowNumAtIndex:[JEIndexModel tIndex:self.titleSelectIndex segIndex:self.segmentedIndex leftIndex:self.leftSelectIndex rightIndex:0]];
        }
    }
    return 0;
}

/*全局只记录当前左侧选择的。*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    DropDownCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[DropDownCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    JEIndexModel *model = [self indexModelInTitleIndex:self.titleSelectIndex];
    cell.isSelect = NO;
    cell.accessoryType = UITableViewCellAccessoryNone;


    JEIndexModel *indexModel = [self indexTitleIndex:self.titleSelectIndex withSegmendIndex:self.segmentedControl.selectedSegmentIndex];
    NSString *title;
    if (tableView == self.leftTableView) {
        
        //箭头
        //不是单选
        //是可展开的

        if ([self.dataSouce respondsToSelector:@selector(multipleOptionsAtTitleIndex:)] && [self.dataSouce multipleOptionsAtTitleIndex:self.titleSelectIndex]) {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }else if ([self.dataSouce respondsToSelector:@selector(leftRowIsSelectClick:)]) {
            
            if ([self.dataSouce leftRowIsSelectClick:[JEIndexModel tIndex:self.titleSelectIndex segIndex:self.segmentedControl.selectedSegmentIndex leftIndex:indexPath.row rightIndex:0]]) {
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                
            }else{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        }
        
        
        if (indexPath.row == indexModel.leftIndex) {
            
            cell.isSelect = YES;

        }
        title = [self.dataSouce dropDownMenu:self leftTitleAtIndex:[JEIndexModel tIndex:self.titleSelectIndex segIndex:self.segmentedControl.selectedSegmentIndex leftIndex:indexPath.row rightIndex:0]];
    }
    
    else{
        if (indexPath.row == indexModel.rightIndex && self.leftSelectIndex == model.leftIndex) {
            
            cell.isSelect = YES;
            
        }
    
        if ([self.dataSouce respondsToSelector:@selector(dropDownMenu:rightTitleAtIndex:)]) {
            title = [self.dataSouce dropDownMenu:self rightTitleAtIndex:[JEIndexModel tIndex:self.titleSelectIndex segIndex:self.segmentedControl.selectedSegmentIndex leftIndex:self.leftSelectIndex rightIndex:indexPath.row]];
        }
    }
 
    
    cell.textLabel.text = title;
    return cell;
//TODO: CellUI优化

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}



//MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    JEIndexModel *model = [self indexModelInTitleIndex:self.titleSelectIndex];
    JEIndexModel *indexModel = [self indexTitleIndex:self.titleSelectIndex withSegmendIndex:self.segmentedControl.selectedSegmentIndex];
   
    
    if (tableView == self.leftTableView) {
        
        self.leftSelectIndex = indexPath.row;
        indexModel.leftIndex = indexPath.row;
        
       
        if (([self.dataSouce respondsToSelector:@selector(leftRowIsSelectClick:)] && [self.dataSouce leftRowIsSelectClick:indexModel]) || ([self.dataSouce respondsToSelector:@selector(multipleOptionsAtTitleIndex:)] && [self.dataSouce multipleOptionsAtTitleIndex:self.titleSelectIndex])) {
            
            //直接调用代理
            if ([self.delegate respondsToSelector:@selector(dropDownMenu:didSelecedLeftRowAtIndex:)]) {
                [self.delegate dropDownMenu:self didSelecedLeftRowAtIndex:model];
            }
            model.leftIndex = self.leftSelectIndex;
            model.segmentedIndex = self.segmentedControl.selectedSegmentIndex;

            indexModel.segmentedIndex  =self.segmentedControl.selectedSegmentIndex;
            NSString *title = [self.dataSouce dropDownMenu:self leftTitleAtIndex:model];
            //  标题切换
            [self setTitle:title withIndex:self.titleSelectIndex];
            [self dismiss];
        }
         //展开
        else{
            self.rightTableView.hidden = NO;
            [self.rightTableView reloadData];
        }
        
        [self.leftTableView reloadData];
        
    }
    else if (tableView == self.rightTableView){
        model.segmentedIndex = self.segmentedControl.selectedSegmentIndex;
        model.leftIndex = self.leftSelectIndex;
        model.rightIndex = indexPath.row;
        indexModel.rightIndex = indexPath.row;
        indexModel.segmentedIndex  = self.segmentedControl.selectedSegmentIndex;
    
        
        //代理
        if ([self.delegate respondsToSelector:@selector(dropDownMenu:didSelecedRightRowAtIndex:)]) {
            [self.delegate dropDownMenu:self didSelecedRightRowAtIndex:model];
        }
    
        if ([self.dataSouce respondsToSelector:@selector(dropDownMenu:rightTitleAtIndex:)]) {
            NSString *title = [self.dataSouce dropDownMenu:self rightTitleAtIndex:model];

            //  标题切换
            [self setTitle:title withIndex:self.titleSelectIndex];
        }
    
        
        [self dismiss];
        
        [self.rightTableView reloadData];
    }
    
}

- (NSMutableArray *)segIndexArray{
    if (_segIndexArray == nil) {
        _segIndexArray = [NSMutableArray array];
    }
    return _segIndexArray;
}

- (NSMutableArray *)selectArray{
    if (_selectArray == nil) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}


- (UITableView *)leftTableView{
    if (_leftTableView==nil) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/[self.dataSouce numberOfRowDropDownMenu:self], 200) style:UITableViewStylePlain];
        _leftTableView.dataSource = self;
        _leftTableView.delegate   = self;
        [self clearLine2:_leftTableView];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView{
    if (_rightTableView==nil) {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - self.frame.size.width/[self.dataSouce numberOfRowDropDownMenu:self], 200) style:UITableViewStylePlain];
        _rightTableView.dataSource = self;
        _rightTableView.delegate   = self;
        [self clearLine2:_rightTableView];
        _rightTableView.backgroundColor = JE_RGBCOLOR(245, 245, 245);
    }
    return _rightTableView;
}


- (UIImageView *)bgImageView{
    if (_bgImageView == nil) {
        _bgImageView = [UIImageView new];
    }
    return _bgImageView;
}
- (UIImageView *)tabBgImageView{
    if (_tabBgImageView == nil) {
        _tabBgImageView = [UIImageView new];
    }
    return _tabBgImageView;
}

- (UIControl *)bgControl{
    if (_bgControl == nil) {
        _bgControl = [UIControl new];
        [_bgControl addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgControl;
}

- (void)clearLine2:(UITableView *)tableView{
    UIView *view =[UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
}

    

@end


@implementation JEIndexModel


- (instancetype)init{
    self = [super init];
    if (self) {
        self.leftIndex = self.rightIndex  = self.titleIndex = 0;
        self.segmentedIndex  = 0;
        
    }
    return self;
}
+ (instancetype)tIndex:(NSInteger)t segIndex:(NSInteger)s leftIndex:(NSInteger)l rightIndex:(NSInteger)r{
    JEIndexModel *model = [JEIndexModel new];
    model.titleIndex = t;
    model.segmentedIndex = s;
    model.leftIndex  = l;
    model.rightIndex = r;
    return model;
}
@end



@implementation DropDownCell

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
 
    self.textLabel.textColor = _isSelect ? [UIColor blueColor] : [UIColor blackColor];
    
}

@end












