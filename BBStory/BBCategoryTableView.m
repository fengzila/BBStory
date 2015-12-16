//
//  BBStoryRecordTableView.m
//  BBStory
//
//  Created by Fengzi on 15/10/26.
//  Copyright © 2015年 FengZi. All rights reserved.
//

#import "BBCategoryTableView.h"
#import "BBDataManager.h"

@implementation BBCategoryTableView

- (id)initWithFrame:(CGRect)frame Data:(NSMutableArray*)data
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
        
        _tableView.frame = CGRectMake(0, 0, self.frame.size.width, [data count]*90);
        
        _data = data;
    }
    return self;
}

- (NSInteger)adaptFrameHeight
{
    return _tableView.height;
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 定义静态标识符
    static NSString *cellIdentifier = @"cell";
    NSInteger row = [indexPath row];
    //    NSUInteger section = [indexPath section];
    
    // 检查表视图中是否存在闲置的单元格
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selected = NO;
        cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        
        UIImageView *imageP = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-44, (90-70)/2, 44, 70)];
        imageP.image = [UIImage imageNamed:@"bt_04_J"];
        [cell addSubview:imageP];
        
        UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(90/2-80/2, 5, 80, 80)];
        headImg.tag = 10001;
        [cell addSubview:headImg];
        headImg.backgroundColor=[UIColor clearColor];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(88, 25, 100, 20)];
        title.tag = 10002;
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = 0;
        title.textColor = [UIColor blackColor];
        title.font = [UIFont systemFontOfSize:15];
        [cell addSubview:title];
        
        UILabel *desc = [[UILabel alloc]initWithFrame:CGRectMake(88, 55, 100, 20)];
        desc.tag = 10003;
        desc.backgroundColor = [UIColor clearColor];
        desc.textAlignment = 0;
        desc.textColor = [UIColor grayColor];
        desc.font = [UIFont systemFontOfSize:13];
        [cell addSubview:desc];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(10, 89, kDeviceWidth - 20, 1)];
        line.image = [UIImage imageNamed:@"gwc_line_"];
        line.backgroundColor=[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0];
        [cell addSubview:line];
    }
    
    ((UIImageView*)[cell viewWithTag:10001]).image = [UIImage imageNamed:[[_data objectAtIndex:row] objectForKey:@"img"]];
    ((UILabel*)[cell viewWithTag:10002]).text = [[_data objectAtIndex:row] objectForKey:@"title"];
    NSString *numStr = [[_data objectAtIndex:row] objectForKey:@"num"];
    ((UILabel*)[cell viewWithTag:10003]).text = [NSString stringWithFormat:@"数量：%d", [numStr intValue]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)[indexPath row];
    [self.delegate pushInfoVCWithIndex:(int)row];
}

@end
