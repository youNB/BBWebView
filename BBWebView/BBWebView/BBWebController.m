//
//  BBWebController.m
//  BBWebView
//
//  Created by 程肖斌 on 2019/1/23.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import "BBWebController.h"

@implementation BBWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(@available(iOS 11.0, *)){}
    else{self.automaticallyAdjustsScrollViewInsets = NO;}
    self.view.backgroundColor = UIColor.whiteColor;
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    configuration.userContentController = userContentController;
    
    CGFloat length = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    CGRect frame = CGRectMake(0, TOP, length, height-TOP);
    self.web_view = [[BBWebView alloc]initWithFrame:frame
                                      configuration:configuration];
    self.web_view.weak_delegate = self;
    [self.view addSubview:self.web_view];
    
    frame = CGRectMake(0, 0, 28, 28);
    self.back_btn = [[UIButton alloc]initWithFrame:frame];
    [self.back_btn setImage:[UIImage imageNamed:@"back"]
                   forState:UIControlStateNormal];
    self.back_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *back_item = [[UIBarButtonItem alloc]initWithCustomView:self.back_btn];
    
    self.close_btn = [[UIButton alloc]initWithFrame:frame];
    [self.close_btn setImage:[UIImage imageNamed:@"close"]
                    forState:UIControlStateNormal];
    self.close_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *close_item = [[UIBarButtonItem alloc]initWithCustomView:self.close_btn];
    
    self.navigationItem.leftBarButtonItems = @[back_item, close_item];
    
    self.close_btn.hidden = YES;
    [self.back_btn addTarget:self
                      action:@selector(gotoPrevious)
            forControlEvents:UIControlEventTouchUpInside];
    [self.close_btn addTarget:self
                       action:@selector(closeWebView)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self loadWebRequest];
}

//response
- (void)gotoPrevious{
    BOOL state = self.web_view.canGoBack;
    if(state){[self.web_view goBack];}
    else{[self.navigationController popViewControllerAnimated:YES];}
    self.close_btn.hidden = (self.web_view.backForwardList.backList.count <= 1);
}

- (void)closeWebView{
    [self.navigationController popViewControllerAnimated:YES];
}

//delegate
- (void)loadWebRequest{}

//title改变了
- (void)bb_titleChange:(id)object change:(NSDictionary *)change context:(void *)context{
    self.title = self.navigation_title ? self.navigation_title : [change[@"new"] description];
}

//进度条改变了
- (void)bb_estimatedProgressChange:(id)object change:(NSDictionary *)change context:(void *)context{
}

//开始加载了
- (void)bb_webView:(BBWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
}

//加载完成了
- (void)bb_webView:(BBWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    for(void (^callback)(BBWebView *web) in self.exes){
        callback(webView);
    }
    
    [self.key_values enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, void (^ _Nonnull obj)(WKScriptMessage *), BOOL * _Nonnull stop) {
        [webView addInteract:key handle:obj];
    }];
}

//加载失败
- (void)bb_webView:(BBWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    self.title = @"加载失败了";
}

//是否可以跳转链接
- (void)bb_webView:(BBWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
    self.close_btn.hidden = !webView.canGoBack;
}

//lazy load
@synthesize exes = _exes;
@synthesize key_values = _key_values;
- (NSMutableArray<void (^)(BBWebView *)> *)exes{
    if(!_exes){
        _exes = [NSMutableArray array];
    }
    return _exes;
}

- (NSMutableDictionary<NSString *,void (^)(WKScriptMessage *)> *)key_values{
    if(!_key_values){
        _key_values = [NSMutableDictionary dictionary];
    }
    return _key_values;
}

- (void)dealloc{
    NSLog(@"%@销毁了",self.class);
}

@end

@implementation BBUrlWebController

- (void)loadWebRequest{
    NSURL *URL = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self.web_view loadRequest:request];
}

@end

@implementation BBHtmlWebController

- (void)loadWebRequest{
    [self.web_view loadHTMLString:self.html
                          baseURL:self.base_URL];
}

@end

@implementation BBBundleWebController

- (void)loadWebRequest{
    NSString *path = [NSBundle.mainBundle pathForResource:self.name
                                                   ofType:self.type];
    NSURL *URL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self.web_view loadRequest:request];
}

@end

@implementation BBDataWebController

- (void)loadWebRequest{
    [self.web_view loadData:self.data
                   MIMEType:self.mime
      characterEncodingName:self.encode_name
                    baseURL:self.base_URL];
}

@end
