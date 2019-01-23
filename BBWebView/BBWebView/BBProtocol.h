//
//  BBProtocol.h
//  BBWebView
//
//  Created by 程肖斌 on 2019/1/23.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBWebView;
@protocol BBProtocol <NSObject>
@required
- (void)loadWebRequest;

@optional
- (void)bb_webView:(BBWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation;

- (void)bb_webView:(BBWebView *)webView didFinishNavigation:(WKNavigation *)navigation;

- (void)bb_webView:(BBWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error;

- (void)bb_userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

- (void)bb_webView:(BBWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler;

//观察者回调
- (void)bb_estimatedProgressChange:(id)object change:(NSDictionary *)change context:(void *)context;

- (void)bb_titleChange:(id)object change:(NSDictionary *)change context:(void *)context;

@end

