WHC_KeyboardManager
==============
![Build Status](https://api.travis-ci.org/netyouli/WHC_KeyboardManager.svg?branch=master)
[![Pod Version](http://img.shields.io/cocoapods/v/WHC_KeyboardManager.svg?style=flat)](http://cocoadocs.org/docsets/WHC_KeyboardManager/)
[![Pod Platform](http://img.shields.io/cocoapods/p/WHC_KeyboardManager.svg?style=flat)](http://cocoadocs.org/docsets/WHC_KeyboardManager/)
[![Pod License](http://img.shields.io/cocoapods/l/WHC_KeyboardManager.svg?style=flat)](https://opensource.org/licenses/MIT)
简介
==============
- **高效**: 轻量级实用键盘管理器
- **安全**: 无入侵性,局部控制器键盘自动管理
- **优势**: 集成简单设置灵活
- **简单**: 无需任何配置
- **灵活**: 可自定义键盘处理配置
- **兼容**: 支持横竖屏切换适配
- **咨询**: 712641411
- **作者**: 吴海超

**bug修复：修复headerview 在push或者pop不消失bug**

演示
==============
![](https://github.com/netyouli/WHC_KeyboardManager/blob/master/WHC_KeyboradManager/demo/k1.gif)


要求
==============
* iOS 6.0 or later
* Xcode 8.0 or later

集成
==============
* 使用CocoaPods:

    **【Objective-c】** pod 'WHC_KeyboardManager_oc'

    **【Swift4.0+】** pod 'WHC_KeyboardManager'

使用到第三方库
==============
* 自动布局库[WHC_AutoLayoutKit](https://github.com/netyouli/WHC_AutoLayoutKit)</br>

用法
==============

- 无配置演示
```Swift
override func viewDidLoad() {
    super.viewDidLoad()
    /*******只需要在要处理键盘的界面创建WHC_KeyboardManager对象即可无需任何其他设置*******/
    WHC_KeyboardManager.share.addMonitorViewController(self)
}
```
- 自定义配置演示

```Swift
override func viewDidLoad() {
    super.viewDidLoad()
    /*******只需要在要处理键盘的界面创建WHC_KeyboardManager对象即可无需任何其他设置*******/
    let configuration = WHC_KeyboardManager.share.addMonitorViewController(self)
    /// 不要键盘头
    configuration.enableHeader = false

    /***configuration里面有丰富实用的自定义配置具体可参看代码***/
}
```

推荐
==============
* iOS平台最好用自动布局库: [AutoLayoutKit](https://github.com/netyouli/WHC_AutoLayoutKit)
* iOS开发辅助Mac工具: [DataModelFactory](https://github.com/netyouli/WHC_DataModelFactory)
* iOS平台最强大Sqlite库: [ModelSqliteKit](https://github.com/netyouli/WHC_ModelSqliteKit)

## <a id="期待"></a>期待

- 如果您在使用过程中有任何问题，欢迎issue me! 很乐意为您解答任何相关问题!
- 与其给我点star，不如向我狠狠地抛来一个BUG！
- 如果您想要更多的接口来自定义或者建议/意见，欢迎issue me！我会根据大家的需求提供更多的接口！

## Licenses
All source code is licensed under the MIT License.
