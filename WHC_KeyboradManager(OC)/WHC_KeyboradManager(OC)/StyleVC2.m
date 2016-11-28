//
//  StyleVC2.m
//  WHC_KeyboardManager(OC)
//
//  Created by WHC on 16/11/26.
//  Copyright © 2016年 WHC. All rights reserved.
//

#import "StyleVC2.h"
#import "WHC_StackView.h"
#import "WHC_KeyboardManager.h"

@interface StyleVC2 ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong)WHC_StackView * stackView;
@end

@implementation StyleVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"ScrollView无键盘头";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [_scrollView whc_AutoSize:0 top:0 right:0 bottom:0];
    /// 键盘处理配置
    /*******只需要在要处理键盘的界面创建WHC_KeyboardManager对象即可无需任何其他设置*******/
    WHC_KBMConfiguration * configuration = [[WHC_KeyboardManager share] addMonitorViewController:self];
    /// 不要键盘头
    configuration.enableHeader = false;
    
    /********************* 构建UI ***********************/
    _stackView = [WHC_StackView new];
    /// 设置垂直布局
    _stackView.whc_Orientation = Vertical;
    /// 设置分割线高度
    _stackView.whc_SegmentLineSize = 0.5;
    /// 设置子视图高度
    _stackView.whc_SubViewHeight = 40;
    /// 设置子视图内边距
    _stackView.whc_Edge = UIEdgeInsetsMake(0, 16, 0, 16);

    [_scrollView addSubview:_stackView];
    _stackView.whc_LeftSpace(0)
    .whc_TopSpace(0)
    .whc_RightSpaceToView(0, self.view)
    .whc_HeightAuto()
    .whc_BottomSpaceKeepHeightConstraint(0,YES);/// scrollview contentSize自动
    
    for (int i = 0; i < 30; i++) {
        if (i < 15) {
            UITextView * text = [UITextView new];
            text.text = [NSString stringWithFormat:@"UITextView %d",i];
            text.font = [UIFont systemFontOfSize:14];
            [_stackView addSubview: text];
        }else {
            UITextField * text = [UITextField new];
            text.placeholder = [NSString stringWithFormat:@"UITextField %d",i];
            [_stackView addSubview: text];
        }
    }
    [_stackView whc_StartLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
