//
//  BBCycleScrollCell.m
//  BB
//
//  Created by FengZi on 14-1-18.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBUserScrollView.h"
#import "BBRecordCategoryListController.h"
#import "BBGamesViewController.h"
#import "MobClick.h"

@implementation BBUserScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initData];
        
        // 加载图片
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width*.6f)];
        _imageView.image = [UIImage imageNamed:@"icon_user"];
        [self addSubview:_imageView];
        
        _baseView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_baseView];
        _baseView.delegate = self;
        
        float h = 300;
        if (h < kDeviceHeight - kDeviceWidth*.6f) {
            h = kDeviceHeight - kDeviceWidth*.6f;
        }
        _tableView.frame = CGRectMake(0, 0, self.frame.size.width, h);
        
        _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, _imageView.height - 30, self.frame.size.width, h) style:UITableViewStyleGrouped];
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 8.0;
        [_baseView addSubview:_tableView];
        
        _baseView.contentSize = CGSizeMake(self.bounds.size.width, self.width*.6f+h + 100);
    }
    return self;
}

- (void)initData
{
    _data = [[NSMutableArray alloc] init];
    
    NSMutableArray *seg1 = [[NSMutableArray alloc] init];
    [seg1 addObject:@{@"img" : @"logo", @"title" : @"我的录音"}];
    [_data addObject:seg1];
    
    NSMutableArray *seg2 = [[NSMutableArray alloc] init];
    [seg2 addObject:@{@"img" : @"logo", @"title" : @"爸比的游戏"}];
    [seg2 addObject:@{@"img" : @"logo", @"title" : @"五星好评"}];
    [_data addObject:seg2];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset = _baseView.contentOffset.y;
    
    CGFloat ImageWidth  = self.width;
    CGFloat ImageHeight  = self.width*.6f;
    if (yOffset < 0)
    {
        CGFloat factor = ((ABS(yOffset)+ImageHeight)*ImageWidth)/ImageHeight;
        CGRect f = CGRectMake(-(factor-ImageWidth)/2, 0, factor, ImageHeight+ABS(yOffset));
        _imageView.frame = f;
    }
    else
    {
        CGRect f = _imageView.frame;
        f.origin.y = -yOffset;
        _imageView.frame = f;
    }
    
    [self.delegate scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    [self.delegate scrollViewDidEndDecelerating:scrollView];
}


#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_data objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 定义静态标识符
    static NSString *cellIdentifier = @"cell";
    NSInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    // 检查表视图中是否存在闲置的单元格
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [[[_data objectAtIndex:section] objectAtIndex:row] objectForKey:@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    //    cell.imageView.image = [[[_data objectAtIndex:section] objectAtIndex:row] objectForKey:@"img"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    if (section == 0)
    {
        if (row == 0)
        {
            // 我的录音
            BBRecordCategoryListController *recordVC = [[BBRecordCategoryListController alloc] init];
            [self.delegate pushInfoVC:recordVC];
        }
    }
    else if (section == 1)
    {
        if (row == 0)
        {
            // 爸比的游戏
            BBGamesViewController *gameVC = [[BBGamesViewController alloc] init];
            [self.delegate pushInfoVC:gameVC];
        }
        else if(row == 1)
        {
            [MobClick event:@"btn_menu_rate"];
            [BBFunction goToAppStoreEvaluate:842439221];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
