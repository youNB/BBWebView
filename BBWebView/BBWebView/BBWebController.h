//
//  BBWebController.h
//  BBWebView
//
//  Created by 程肖斌 on 2019/1/23.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBFrame.h"
#import "BBWebView.h"

@interface BBWebController : UIViewController<BBProtocol>
@property(nonatomic, strong) BBWebView *web_view;

@property(nonatomic, strong) NSString *navigation_title;//可选
@property(nonatomic, strong) UIButton *back_btn;        //webView返回上一页
@property(nonatomic, strong) UIButton *close_btn;       //关闭webView

@property(nonatomic, strong, readonly) NSMutableArray<void (^)(BBWebView *web_view)> *exes;//执行js回调
@property(nonatomic, strong, readonly) NSMutableDictionary<NSString *, void (^)(WKScriptMessage *message)> *key_values; //注册事件
@end

@interface BBUrlWebController : BBWebController
@property(nonatomic, strong) NSString *url;
@end

@interface BBHtmlWebController : BBWebController
@property(nonatomic, strong) NSString *html;
@property(nonatomic, strong) NSURL *base_URL;
@end

@interface BBBundleWebController : BBWebController
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *type;
@end

@interface BBDataWebController : BBWebController
@property(nonatomic, strong) NSData   *data;
@property(nonatomic, strong) NSString *mime;
@property(nonatomic, strong) NSString *encode_name;
@property(nonatomic, strong) NSURL    *base_URL;

@end
