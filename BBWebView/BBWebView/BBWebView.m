//
//  BBWebView.m
//  BBWebView
//
//  Created by 程肖斌 on 2019/1/23.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import "BBWebView.h"
#import "BBProxy.h"
#import <objc/runtime.h>

@interface BBWebView()
@property(nonatomic, strong) BBProxy *proxy;
@property(nonatomic, strong) UIView *progress_view;
@property(nonatomic, strong) NSMutableDictionary<NSString *, void (^)(id object, NSDictionary *change, void *context)> *observer_handle;
@property(nonatomic, strong) NSMutableDictionary<NSString *, void (^)(WKScriptMessage *message)> *name_scripts;
@end

@implementation BBWebView

- (void)addSubview:(UIView *)view{
    [super addSubview:view];
    [self bringSubviewToFront:self.progress_view];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        [self INIT];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                configuration:(WKWebViewConfiguration *)configuration{
    if([super initWithFrame:frame configuration:configuration]){
        [self INIT];
    }
    return self;
}

- (void)INIT{
    self.layer.masksToBounds = YES;
    if(@available(iOS 11.0, *)){
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.UIDelegate = self;
    self.navigationDelegate = self;
    self.scrollView.showsVerticalScrollIndicator   = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    CGRect frame = CGRectMake(0, 0, 0, 2);
    self.progress_view = [[UIView alloc]initWithFrame:frame];
    self.progress_view.backgroundColor = UIColor.greenColor;
    [self addSubview:self.progress_view];
    
    __weak typeof(self) weak_self = self;
    [self addObserverWithKeyPath:@"estimatedProgress"
                          handle:^(id object, NSDictionary *change, void *context) {
        SEL sel = @selector(bb_estimatedProgressChange:change:context:);
        if(![weak_self.weak_delegate respondsToSelector:sel]){return ;}
        [weak_self.weak_delegate bb_estimatedProgressChange:object
                                                     change:change
                                                    context:context];
    }];
    [self addObserverWithKeyPath:@"title"
                          handle:^(id object, NSDictionary *change, void *context) {
        SEL sel = @selector(bb_titleChange:change:context:);
        if(![weak_self.weak_delegate respondsToSelector:sel]){return ;}
        [weak_self.weak_delegate bb_titleChange:object
                                         change:change
                                        context:context];
    }];
}

//对进度条进行设置
- (UIView *)configureProgressView{
    return self.progress_view;
}

//添加观察者
- (void)addObserverWithKeyPath:(NSString *)keyPath
                        handle:(void (^)(id object, NSDictionary *change, void *context))callback{
    NSAssert(keyPath, @"keyPath不能为空");
    NSAssert(callback, @"请实现回调");
    
    void (^handle)(id object, NSDictionary *change, void *context) = self.observer_handle[keyPath];
    self.observer_handle[keyPath] = callback;
    if(handle){return;}
    
    NSKeyValueObservingOptions opt = NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew;
    [self addObserver:self
           forKeyPath:keyPath
              options:opt
              context:NULL];
}

//移除观察者
- (void)removeObserver:(NSString *)keyPath{
    NSAssert(keyPath, @"keyPath不能为空");
    
    id obj = self.observer_handle[keyPath];
    if(!obj){return;}
    
    [self removeObserver:self forKeyPath:keyPath];
    self.observer_handle[keyPath] = nil;
}

//观察到值变了
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context{
    void (^callback)(id object, NSDictionary *change, void *context) = self.observer_handle[keyPath];
    !callback ?: callback(object, change, context);
}

//添加交互
- (void)addInteract:(NSString *)name
             handle:(void (^)(WKScriptMessage *message))callback{
    NSAssert(name, @"name不能为空");
    NSAssert(callback, @"请实现回调");
    
    id obj = self.name_scripts[name];
    self.name_scripts[name] = callback;
    if(obj){return;}
    
    [self.configuration.userContentController addScriptMessageHandler:self.proxy
                                                                 name:name];
}

//移除交互
- (void)removeInteract:(NSString *)name{
    NSAssert(name, @"name不能为空");
    
    id obj = self.name_scripts[name];
    if(!obj){return;}
    
    [self.configuration.userContentController removeScriptMessageHandlerForName:name];
    self.name_scripts[name] = nil;
}

//delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.progress_view.frame = CGRectMake(0, 0, 0, 2);
    
    BOOL state = [self.weak_delegate respondsToSelector:@selector(bb_webView:didStartProvisionalNavigation:)];
    if(state){
        [self.weak_delegate bb_webView:self
         didStartProvisionalNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    __weak typeof(self) weak_self = self;
    [UIView animateWithDuration:0.25f animations:^{
        CGRect frame = CGRectMake(0, 0, 2 * webView.bounds.size.width, 2);
        weak_self.progress_view.frame = frame;
    } completion:^(BOOL finished) {
        weak_self.progress_view.frame = CGRectMake(0, 0, 0, 2);
    }];
    
    BOOL state = [self.weak_delegate respondsToSelector:@selector(bb_webView:didFinishNavigation:)];
    if(state){
        [self.weak_delegate bb_webView:self
                   didFinishNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error{
    __weak typeof(self) weak_self = self;
    [UIView animateWithDuration:0.1f animations:^{
        CGRect frame = CGRectMake(0, 0, 2 * webView.bounds.size.width, 2);
        weak_self.progress_view.frame = frame;
    } completion:^(BOOL finished) {
        weak_self.progress_view.frame = CGRectMake(0, 0, 0, 2);
    }];
    
    BOOL state = [self.weak_delegate respondsToSelector:@selector(bb_webView:didFailProvisionalNavigation:withError:)];
    if(state){
        [self.weak_delegate bb_webView:self
                didFailProvisionalNavigation:navigation withError:error];
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if(!message.name){return;}
    void (^callback)(WKScriptMessage *message) = self.name_scripts[message.name];
    !callback ?: callback(message);
    
    BOOL state = [self.weak_delegate respondsToSelector:@selector(bb_userContentController:didReceiveScriptMessage:)];
    if(state){
        [self.weak_delegate bb_userContentController:userContentController
                                   didReceiveScriptMessage:message];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
    
    BOOL state = [self.weak_delegate respondsToSelector:@selector(bb_webView:decidePolicyForNavigationAction:decisionHandler:)];
    if(!state){decisionHandler(WKNavigationActionPolicyAllow);}
    else{
        [self.weak_delegate bb_webView:self
        decidePolicyForNavigationAction:navigationAction
                        decisionHandler:decisionHandler];
    }
}

//lazy load
- (BBProxy *)proxy{
    if(!_proxy){
        _proxy = [BBProxy proxy:self];
    }
    return _proxy;
}

- (NSMutableDictionary<NSString *,void (^)(id, NSDictionary *, void *)> *)observer_handle{
    if(!_observer_handle){
        _observer_handle = [NSMutableDictionary dictionary];
    }
    return _observer_handle;
}

- (NSMutableDictionary<NSString *,void (^)(WKScriptMessage *)> *)name_scripts{
    if(!_name_scripts){
        _name_scripts = [NSMutableDictionary dictionary];
    }
    return _name_scripts;
}

- (void)dealloc{
    self.UIDelegate = nil;
    self.navigationDelegate = nil;
    
    //移除观察者
    for(NSString *keyPath in self.observer_handle.allKeys){
        [self removeObserver:self forKeyPath:keyPath];
    }
    //移除交互
    for(NSString *name in self.name_scripts.allKeys){
        [self removeInteract:name];
    }
    
    NSLog(@"%@销毁了",[self class]);
}

@end
