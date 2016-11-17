WHC_KeyboradManager
==============
[![Pod License](http://img.shields.io/cocoapods/l/WHC_Model.svg?style=flat)](https://opensource.org/licenses/MIT)
简介
==============
- **高效**: 轻量级拒绝复杂或看不懂的Api
- **安全**: 无入侵性
- **优势**: 集成简单设置灵活
- **特性**: 支持自定义键盘头视图
- **兼容**: 支持横竖屏切换适配
- **咨询**: 712641411
- **作者**: 吴海超

性能测试
==============
Time lost (Benchmark 1000 times)
<img src = "https://github.com/netyouli/WHC_KeyboradManager/blob/master/WHC_KeyboradManager/demo/k1.gif", width = 375><img src = "https://github.com/netyouli/WHC_KeyboradManager/blob/master/WHC_KeyboradManager/demo/k2.gif", width = 375>


要求
==============
* iOS 8.0 or later
* Xcode 8.0 or later

集成
==============
* 使用CocoaPods:
  -  pod 'WHC_KeyboradManager', '~> 1.0.0'
* 手工集成:
  -  导入文件夹WHC_KeyboradManager

用法
==============

```Swift
/// 创建键盘管理器
var keyborad = WHC_KeyboradManager()

/// 设置键盘头部视图如果不需要可以忽略
keyborad.whc_SetHeader(view: WHC_KeyboradHeaderView())

/// 设置当键盘挡住输入控件时的偏移视图
keyborad.whc_SetOffsetView {[unowned self] (field) -> UIView? in
    return self.tableView
}

/// 设置键盘挡住输入控件时偏移视图的里键盘头的偏移量
keyborad.whc_SetOffset { (field) -> CGFloat in
    return 40
}

/// 添加要监听的视图(包含输入的控件)
keyborad.whc_AutoMonitor(view: cell!)
```

推荐
==============
- WHC_DataModelFactory mac工具github地址：https://github.com/netyouli/WHC_DataModelFactory

文档
==============
```Swift

//MARK: - 公开接口Api -

/// 设置键盘头视图
///
/// - parameter view: 键盘出现时要置顶的视图
func whc_SetHeader(view: UIView?) {
    headerView = view
}

/// 自动监听容器视图里的输入视图的键盘状态或者单个UITextfield/UITextView
///
/// - parameter vc:
func whc_AutoMonitor(view: UIView) {
    autoMonitor(view: view)
}

/// 设置键盘挡住要移动视图的偏移量
///
/// - parameter block: 回调block
func whc_SetOffset(block: @escaping ((_ field: UIView?) -> CGFloat)) {
    offsetBlock = block
}


/// 设置键盘挡住的Field要移动的视图
///
/// - parameter block: 回调block
func whc_SetOffsetView(block: @escaping ((_ field: UIView?) -> UIView?)) {
    offsetViewBlock = block
}

/// 清空所有缓存的field(再reloadData需要调用)
func whc_ClearCacheField() {
    fieldViews.removeAll()
    fieldDelegates.removeAll()
}

/// 设置键盘将要出现的回调
///
/// - parameter block: 回调块
func whc_SetKeyboradWillShow(block: @escaping ((_ notify: Notification) -> Void)) {
    keyboradWillShowBlock = block
}

/// 设置键盘将要隐藏的回调
///
/// - parameter block: 回调块
func whc_SetKeyboradWillHide(block: @escaping ((_ notify: Notification) -> Void)) {
    keyboradWillHideBlock = block
}
```
## <a id="期待"></a>期待

- 如果您在使用过程中有任何问题，欢迎issue me! 很乐意为您解答任何相关问题!
- 与其给我点star，不如向我狠狠地抛来一个BUG！
- 如果您想要更多的接口来自定义或者建议/意见，欢迎issue me！我会根据大家的需求提供更多的接口！

## Licenses
All source code is licensed under the MIT License.
