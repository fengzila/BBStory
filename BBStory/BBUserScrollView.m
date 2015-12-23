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
#import "UMFeedback.h"

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
        _tableView.showsHorizontalScrollIndicator=NO;
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.separatorColor=[UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_baseView addSubview:_tableView];
        
        _baseView.contentSize = CGSizeMake(self.bounds.size.width, self.width*.6f+h + 100);
    }
    return self;
}

- (void)initData
{
    _data = [[NSMutableArray alloc] init];
    
    NSMutableArray *seg1 = [[NSMutableArray alloc] init];
    [seg1 addObject:@{@"img" : @"menu_recorder", @"title" : @"我的录音"}];
    [_data addObject:seg1];
    
    NSMutableArray *seg2 = [[NSMutableArray alloc] init];
    [seg2 addObject:@{@"img" : @"menu_game", @"title" : @"爸比的游戏"}];
    [seg2 addObject:@{@"img" : @"menu_rate", @"title" : @"问题反馈"}];
    [seg2 addObject:@{@"img" : @"menu_rate", @"title" : @"五星好评"}];
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
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selected = NO;
        
        UIImageView *imageP = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-44, (46-70)/2, 44, 70)];
        imageP.image = [UIImage imageNamed:@"bt_04_J"];
        [cell addSubview:imageP];
        
        UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(46/2-20/2, 46/2-20/2, 20, 20)];
        headImg.tag = 10001;
        [cell addSubview:headImg];
        headImg.backgroundColor=[UIColor clearColor];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(58, 0, 100, 46)];
        title.tag = 10002;
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = 0;
        title.textColor = [UIColor colorWithRed:.2 green:.2 blue:.2 alpha:1.0];
        title.font = [UIFont systemFontOfSize:14];
        [cell addSubview:title];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 45, kDeviceWidth, 1)];
        line.image = [UIImage imageNamed:@"gwc_line_"];
        line.backgroundColor=[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0];
        [cell addSubview:line];
    }
    
    ((UIImageView*)[cell viewWithTag:10001]).image = [UIImage imageNamed:[[[_data objectAtIndex:section] objectAtIndex:row] objectForKey:@"img"]];
    ((UILabel*)[cell viewWithTag:10002]).text = [[[_data objectAtIndex:section] objectAtIndex:row] objectForKey:@"title"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
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
            [self.delegate pushInfoVC:[UMFeedback feedbackViewController]];
        }
        else if(row == 2)
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
