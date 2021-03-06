//
//  BBStoryRecordTableView.m
//  BBStory
//
//  Created by Fengzi on 15/10/26.
//  Copyright © 2015年 FengZi. All rights reserved.
//

#import "BBStoryRecordTableView.h"
#import "BBRecorderObject.h"
#import "BBDataManager.h"

@implementation BBStoryRecordTableView

- (id)initWithFrame:(CGRect)frame Data:(NSMutableArray*)data
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        _data = data;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section != 0)
    {
        return 0;
    }
    NSLog(@"count is %d", (int)[_data count]);
    return [_data count];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSUInteger index = [_data count] - [indexPath row] - 1;
        BBRecorderObject *data = [_data objectAtIndex:index];
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *recorderName = [NSString stringWithFormat:@"%@/story_%@.caf", docDir, data.recorderId];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:recorderName];
        if ( existed )
        {
            [fileManager removeItemAtPath:recorderName error:NULL];
        }
        [_data removeObjectAtIndex:index];
        NSString *recorderListKey;
        switch ([[BBDataManager getInstance] getCurContentDataType]) {
            case kContentDataTypeStory:
                recorderListKey = UD_RECORDER_STORY_LIST;
                break;
            case kContentDataTypeTangshi:
                recorderListKey = UD_RECORDER_TANGSHI_LIST;
                break;
                
            default:
                break;
        }
        if ([recorderListKey length] > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_data] forKey:recorderListKey];
        }
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
    }  
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 85;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section != 0)
//    {
//        return 55;
//    }
//    return 0;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    static NSString *CellWithIdentifier = @"localCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil)
    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//        
//        cell.accessoryType = UITableViewCellAccessoryNone;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selected = NO;
        
        UIImageView *imageP = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-44, 0, 44, 60)];
        imageP.image = [UIImage imageNamed:@"bt_04_J"];
        [cell addSubview:imageP];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 250, 60)];
        title.tag = 10001;
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = 0;
        title.textColor = [UIColor colorWithRed:.2 green:.2 blue:.2 alpha:1.0];
        title.font = [UIFont systemFontOfSize:16];
        [cell addSubview:title];
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width - 100, 0, 100, 60)];
        timeLabel.tag = 10002;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textAlignment = 0;
        timeLabel.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
        timeLabel.font = [UIFont systemFontOfSize:14];
        [cell addSubview:timeLabel];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 59, kDeviceWidth, 1)];
        line.image = [UIImage imageNamed:@"gwc_line_"];
        line.backgroundColor=[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0];
        [cell addSubview:line];
    }
    
    BBRecorderObject *data = [_data objectAtIndex:[_data count] - row - 1];
    
    ((UILabel*)[cell viewWithTag:10001]).text = [NSString stringWithFormat:@"No.%d  %@", (int)row+1, data.name];
    ((UILabel*)[cell viewWithTag:10002]).text = data.time;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)[indexPath row];
    [self.delegate pushInfoVCWithData:[_data objectAtIndex:[_data count] - row - 1] index:(int)([_data count] - row - 1)];
}

@end
