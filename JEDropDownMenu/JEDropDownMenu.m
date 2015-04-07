//
//  JEDropDownMenu.m
//  JEDropDownMenu
//
//  Created by 尹现伟 on 15/4/7.
//  Copyright (c) 2015年 上海美问信息技术有限公司. All rights reserved.
//

#import "JEDropDownMenu.h"

@interface JEDropDownMenu ()


@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, strong) UITableView *leftTableView;

@property (nonatomic, strong) UIControl *bgControl;

@property (nonatomic, assign) NSInteger selectRow;

@property (nonatomic, assign) NSInteger selectSection;

@property (nonatomic, strong) UIImageView *tabBgImageView;
@property (nonatomic, strong) UIImageView *bgImageView;


@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) NSMutableArray *selectRightArray;
@end

@implementation JEDropDownMenu


- (void)initTitle{
    NSInteger row = [self.dataSouce numberOfRowDropDownMenu:self];
    CGFloat titleHeight = self.frame.size.height;
    CGFloat titleWidth  = self.frame.size.width/row;
    for (int i = 0; i<row; i++) {
        CGFloat xPos = i * titleWidth;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(xPos, 0, titleWidth, titleHeight)];
        
        button.tag = i;
        
        [button addTarget:self action:@selector(titleCilck:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[self.dataSouce dropDownMenu:self titleAtIndex:i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor blackColor];
        [self addSubview:button];
    }
}


- (void)titleCilck:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == self.selectRow) {
        [self dismiss];
    }else{
        self.selectRow = button.tag;
        [self show];
    }
    
    if ([self.delegate respondsToSelector:@selector(dropDownMenu:titleAtIndex:)]) {
        [self.delegate dropDownMenu:sender didSelctedOfTitleIndex:button.tag];
    }
    
    
//    选择第一个
    
}

- (void)show{
    
    //TODO: 动画
/*
 1. 背景
 2. tabview从上至下
 */
    
    if ([self.dataSouce titltHaveLoswerAtIndex:self.selectRow]) {
        self.leftTableView.frame = CGRectMake(self.leftTableView.frame.origin.x, self.leftTableView.frame.origin.y, self.frame.size.width/[self.dataSouce numberOfRowDropDownMenu:self], self.leftTableView.frame.size.height);
            _rightTableView.hidden = NO;
    }
    else{
        self.leftTableView.frame = CGRectMake(self.leftTableView.frame.origin.x, self.leftTableView.frame.origin.y, self.frame.size.width, self.leftTableView.frame.size.height);
            _rightTableView.hidden = YES;
    }
    _bgControl.hidden = NO;
    _leftTableView.hidden = NO;

   
    
    [_leftTableView reloadData];
    [_rightTableView reloadData];

    
}

- (void)dismiss{
    _bgControl.hidden = YES;
    _selectRow = -1;

}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    [self initTitle];
    
    _selectRow = -1;
    
    for (int i = 0; i<[self.dataSouce numberOfRowDropDownMenu:self]; i++) {
        [self.selectArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self.selectRightArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    }

    self.bgControl.frame = CGRectMake(self.frame.origin.x, self.frame.size.height+self.frame.origin.y, self.frame.size.width, newSuperview.frame.size.height - self.frame.size.height - self.frame.origin.y);
    [newSuperview addSubview:self.bgControl];
    
    self.bgImageView.frame = CGRectMake(0, 0, self.bgControl.frame.size.width, self.bgControl.frame.size.height);
    self.bgImageView.backgroundColor = [UIColor lightGrayColor];
    self.bgImageView.alpha = 0.6;
    [self.bgControl addSubview:self.bgImageView];
    
    self.tabBgImageView.frame = CGRectMake(0, 0, self.bgControl.frame.size.width, self.bgControl.frame.size.height/3*2);
    _tabBgImageView.backgroundColor = [UIColor whiteColor];
    _tabBgImageView.userInteractionEnabled = YES;
    [self.bgControl addSubview:_tabBgImageView];
    
    self.leftTableView.frame = CGRectMake(0, 0, newSuperview.frame.size.width/[self.dataSouce numberOfRowDropDownMenu:self], _tabBgImageView.frame.size.height);
    [_tabBgImageView addSubview:self.leftTableView];
    
    self.rightTableView.frame = CGRectMake(self.leftTableView.frame.size.width, 0, newSuperview.frame.size.width-self.leftTableView.frame.size.width, self.leftTableView.frame.size.height);
    [_tabBgImageView addSubview:self.rightTableView];

    self.bgControl.hidden = YES;
    
    [super willMoveToSuperview:newSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectRow == -1) {
        return 0;
    }
    if (tableView == self.leftTableView) {
        return [self.dataSouce dropDownMenu:self leftRowAtIndex:self.selectRow];
    }
    else if (tableView == self.rightTableView){
        NSIndexPath *indexpath2 = self.selectArray[self.selectRow];
        return [self.dataSouce dropDownMenu:self rightRowAtIndexPath:[NSIndexPath indexPathForRow:indexpath2.section inSection:self.selectRow]];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSIndexPath *indexpath2 = self.selectArray[self.selectRow];
    
    if (tableView == self.leftTableView) {
        cell.textLabel.text = [self.dataSouce dropDownMenu:self leftTitleAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:self.selectRow]];
        if ([self.dataSouce leftRowHaveLowerAtTitleIndex:self.selectRow leftRow:indexPath.row]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if (indexPath.row == indexpath2.section) {
            cell.textLabel.textColor = [UIColor blueColor];
        }
        else{
            cell.textLabel.textColor = [UIColor blackColor];
            cell.selected =  NO;
        }
    }
    else if (tableView == self.rightTableView){
      cell.textLabel.text = [self.dataSouce dropDownMenu:self rightTitleAtIndexPath:[NSIndexPath indexPathForRow:indexpath2.section inSection:self.selectRow] titleRow:indexPath.row];
        if (indexPath.row == indexpath2.row) {
//            NSLog(@"----->>%ld",[self.selectRightArray[self.selectRow] section]);
            NSIndexPath *indexpath3 = [self.leftTableView indexPathForSelectedRow];
            NSLog(@"---%ld",indexpath3.row);
            if (indexpath2.section == indexpath3.row) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                NSLog(@"index2:%ld indexrow:%ld self:%ld",indexpath2.section,indexPath.row,self.selectSection);
            }
            
        }else
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
 
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSIndexPath *indexpath2 = self.selectArray[self.selectRow];

    
    if (tableView == self.leftTableView) {
        self.selectSection = indexPath.row;
        indexpath2 = [NSIndexPath indexPathForRow:indexpath2.row inSection:indexPath.row];
        [self.selectArray replaceObjectAtIndex:self.selectRow withObject:[NSIndexPath indexPathForRow:indexpath2.row inSection:indexPath.row]];
        
        //展开
        if ([self.dataSouce leftRowHaveLowerAtTitleIndex:self.selectRow leftRow:indexPath.row]) {
            if ([self.dataSouce titltHaveLoswerAtIndex:self.selectRow]) {
                self.rightTableView.hidden = NO;
                [self.rightTableView reloadData];
            }else{
                
                if ([self.delegate respondsToSelector:@selector(dropDownMenu:didSelctedOfTitleIndex:leftRow:rightRow:isHaveLower:isSeparate:)]) {
                    
                    [self.delegate dropDownMenu:self didSelctedOfTitleIndex:self.selectRow leftRow:indexPath.row rightRow:0 isHaveLower:NO isSeparate:NO];
                }
                [self dismiss];
            }
        }
        else{
            //直接调用代理
            
            if ([self.delegate respondsToSelector:@selector(dropDownMenu:didSelctedOfTitleIndex:leftRow:rightRow:isHaveLower:isSeparate:)]) {
                
                [self.delegate dropDownMenu:self didSelctedOfTitleIndex:self.selectRow leftRow:indexPath.row rightRow:0 isHaveLower:NO isSeparate:NO];
            }
            [self dismiss];
        }
        
         [self.leftTableView reloadData];
        
    }
    else if (tableView == self.rightTableView){

        indexpath2 = [NSIndexPath indexPathForRow:indexPath.row inSection:indexpath2.section];
        [self.selectArray replaceObjectAtIndex:self.selectRow withObject:indexpath2];
        NSLog(@"--<<%ld",indexpath2.section);
        [self.selectRightArray replaceObjectAtIndex:self.selectRow withObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexpath2.section]];
        
//        代理
     
        if ([self.delegate respondsToSelector:@selector(dropDownMenu:didSelctedOfTitleIndex:leftRow:rightRow:isHaveLower:isSeparate:)]) {
            
            [self.delegate dropDownMenu:self didSelctedOfTitleIndex:self.selectRow leftRow:indexpath2.section rightRow:indexPath.row isHaveLower:YES isSeparate:YES];
        }
        [self dismiss];
        
        [self.rightTableView reloadData];
    }
    
    
}

- (NSMutableArray *)selectRightArray{
    if (_selectRightArray == nil) {
        _selectRightArray = [NSMutableArray array];
    }
    return _selectRightArray;
}
- (NSMutableArray *)selectArray{
    if (_selectArray == nil) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
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



/*
 1. 要创建一个横幅有三个可选项
 2. 两个tableview
 3. 代理方法和数据填充
 4. 点击取消或调用代理
 */

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (UITableView *)leftTableView{
    if (_leftTableView==nil) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/[self.dataSouce numberOfRowDropDownMenu:self], 200) style:UITableViewStylePlain];
        _leftTableView.dataSource = self;
        _leftTableView.delegate   = self;
        [self clearLine:_leftTableView];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView{
    if (_rightTableView==nil) {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - self.frame.size.width/[self.dataSouce numberOfRowDropDownMenu:self], 200) style:UITableViewStylePlain];
        _rightTableView.dataSource = self;
        _rightTableView.delegate   = self;
        [self clearLine:_rightTableView];
    }
    return _rightTableView;
}


- (void)clearLine:(UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
}


//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    if ([result isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbarC = (UITabBarController *)result;
        result = tabbarC.viewControllers[tabbarC.selectedIndex];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)result;
        result = [nav.viewControllers firstObject];
    }
    
    return result;
}


@end