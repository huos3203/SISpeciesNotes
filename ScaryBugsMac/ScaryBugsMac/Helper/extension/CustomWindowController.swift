//
//  CustomWindowController.swift
//  ScaryBugsMac
//
//  Created by pengyucheng on 16/8/30.
//  Copyright © 2016年 recomend. All rights reserved.
//

import Cocoa

class CustomWindowController: NSWindowController {

    override func awakeFromNib() {
        //参看：http://aigudao.net/archives/314.html
        self.window!.titlebarAppearsTransparent = true // 标题栏透明，重要
        self.window!.contentView!.wantsLayer = true // 设置整个内容view都有layer
        
        // 自定义一个view
        var topBannerView = NSView.init(frame: NSZeroRect)
        topBannerView.wantsLayer = true
        
        var bannerColor = NSColor.init(patternImage: NSImage.init(named: "114")!).CGColor // 使用图片生成颜色
        
        topBannerView.layer!.backgroundColor = bannerColor
        self.window?.contentView?.addSubview(topBannerView)
        
        // 取出标题栏的view并且改变背景色
        var views = self.window!.contentView!.superview!.subviews
        
        var titlebarContainerView = views[1]
        var titlebarView = titlebarContainerView.subviews[0]
        titlebarView.layer!.backgroundColor = bannerColor
        //        CGColorRelease(bannerColor)
        //
        //        [topBannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.mas_equalTo(_window.contentView);
        //            make.left.mas_equalTo(_window.contentView);
        //            make.right.mas_equalTo(_window.contentView);
        //            make.height.mas_equalTo(100);
        //            }];
        //
        //        [((NSView *)self.window.contentView).superview addSubview:titleView
        //            positioned:NSWindowBelow
        //            relativeTo:firstView];
        self.window?.contentView?.superview?.addSubview(titlebarView,positioned: .Below,relativeTo: topBannerView)

    }
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        // Insert code here to initialize your application
        
            }

}
