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
        /*此处处理自己的代码，如删除数据*/
        /*删除tableView中的一行*/
        BBRecorderObject *data = [_data objectAtIndex:[_data count] - [indexPath row] - 1];
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *recorderName = [NSString stringWithFormat:@"%@/story_%@.caf", docDir, data.recorderId];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:recorderName];
        if ( existed )
        {
            [fileManager removeItemAtPath:recorderName error:NULL];
        }
        [_data removeObjectAtIndex:[indexPath row]];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_data] forKey:_recorderListKey];
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    BBRecorderObject *data = [_data objectAtIndex:[_data count] - row - 1];
    
    cell.textLabel.text = data.name;
    cell.detailTextLabel.text = data.time;
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
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
