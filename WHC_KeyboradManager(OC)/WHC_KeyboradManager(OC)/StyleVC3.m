//
//  StyleVC3.m
//  WHC_KeyboardManager(OC)
//
//  Created by WHC on 16/11/26.
//  Copyright © 2016年 WHC. All rights reserved.
//

#import "StyleVC3.h"
#import "WHC_StackView.h"
#import "WHC_KeyboardManager.h"

@interface StyleVC3 ()
@property (nonatomic, strong)WHC_StackView * stackView;
@end

@implementation StyleVC3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"UIView";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    /// 键盘处理配置
    /*******只需要在要处理键盘的界面创建WHC_KeyboardManager对象即可无需任何其他设置*******/
    [[WHC_KeyboardManager share] addMonitorViewController:self];
    /********************* 构建UI ***********************/
    _stackView = [WHC_StackView new];
    /// 设置垂直布局
    _stackView.whc_Orientation = Vertical;
    /// 设置子视图高度
    _stackView.whc_SubViewHeight = 40;
    /// 设置垂直间隙
    _stackView.whc_VSpace = 20;
    /// 设置子视图内边距
    _stackView.whc_Edge = UIEdgeInsetsMake(16, 16, 0, 16);
    
    [self.view addSubview:_stackView];
    _stackView.whc_LeftSpace(0)
    .whc_TopSpace(0)
    .whc_RightSpaceToView(0, self.view)
    .whc_HeightAuto();
    
    for (int i = 0; i < 10; i++) {
        UITextField * text = [UITextField new];
        text.placeholder = [NSString stringWithFormat:@"UITextField %d",i];
        text.backgroundColor = [UIColor colorWithRed:253.0 / 255 green:246.0 / 255 blue:220.0 / 255 alpha:1.0];
        [_stackView addSubview: text];
    }
    [_stackView whc_StartLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
