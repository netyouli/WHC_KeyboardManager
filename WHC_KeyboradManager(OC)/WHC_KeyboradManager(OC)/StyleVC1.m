//
//  StyleVC1.m
//  WHC_KeyboardManager(OC)
//
//  Created by WHC on 16/11/26.
//  Copyright © 2016年 WHC. All rights reserved.
//

#import "StyleVC1.h"
#import "UIView+WHC_AutoLayout.h"
#import "WHC_KeyboardManager.h"

#define kCellName (@"whc")
@interface StyleVC1 ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation StyleVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    _tableView.whc_LeftSpace(0)
    .whc_RightSpace(0)
    .whc_TopSpace(0)
    .whc_BottomSpace(0);
    
    self.navigationItem.title = @"Tableview";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[WHC_KeyboardManager share] addMonitorViewController:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row % 2 == 0 ? 40 : 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellName];
        UITextField * field = [UITextField new];
        [cell.contentView addSubview:field];
        field.tag = 100;
        field.whc_LeftSpace(16)
        .whc_TopSpace(0)
        .whc_RightSpace(0)
        .whc_BottomSpace(0);
    }
    ((UITextField *)[cell.contentView viewWithTag:100]).placeholder = [NSString stringWithFormat:@"请输入内容%d",(int)indexPath.row];
    return cell;
}

@end
