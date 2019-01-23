//
//  BBProxy.h
//  BBWebView
//
//  Created by 程肖斌 on 2019/1/23.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface BBProxy : NSProxy<WKScriptMessageHandler>

+ (BBProxy *)proxy:(id)target;

@end
