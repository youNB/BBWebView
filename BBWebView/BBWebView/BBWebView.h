//
//  BBWebView.h
//  BBWebView
//
//  Created by 程肖斌 on 2019/1/23.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "BBProtocol.h"

@interface BBWebView : WKWebView<WKUIDelegate, WKNavigationDelegate>
@property(nonatomic, weak) id<BBProtocol> weak_delegate;

//对进度条进行设置
- (UIView *)configureProgressView;

//添加观察者
- (void)addObserverWithKeyPath:(NSString *)keyPath
                        handle:(void (^)(id object, NSDictionary *change, void *context))callback;

//移除观察者
- (void)removeObserver:(NSString *)keyPath;

//添加交互
- (void)addInteract:(NSString *)name
             handle:(void (^)(WKScriptMessage *message))callback;

//移除交互
- (void)removeInteract:(NSString *)name;

@end

