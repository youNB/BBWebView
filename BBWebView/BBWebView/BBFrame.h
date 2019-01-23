//
//  BBFrame.h
//  BBFrame
//
//  Created by 程肖斌 on 2019/1/22.
//  Copyright © 2019年 ICE. All rights reserved.
//

#ifndef BBFrame_h
#define BBFrame_h

#define TOP (UIScreen.mainScreen.bounds.size.height > 800.0 ? 88.0 : 64.0)

typedef NS_OPTIONS(NSInteger, XZRectOption) {
    XZRectOptionX = 1 << 0,
    XZRectOptionY = 1 << 1,
    XZRectOptionW = 1 << 2,
    XZRectOptionH = 1 << 3,
    XZRectOptionXY = XZRectOptionX | XZRectOptionY, //只改起点
    XZRectOptionWH = XZRectOptionW | XZRectOptionH, //只改长宽
    XZRectOptionXW = XZRectOptionX | XZRectOptionW,
    XZRectOptionXH = XZRectOptionX | XZRectOptionH,
    XZRectOptionYW = XZRectOptionY | XZRectOptionW,
    XZRectOptionYH = XZRectOptionY | XZRectOptionH,
    XZRectOptionXYW = XZRectOptionX | XZRectOptionY | XZRectOptionW,
    XZRectOptionXYH = XZRectOptionX | XZRectOptionY | XZRectOptionH,
    XZRectOptionXWH = XZRectOptionX | XZRectOptionW | XZRectOptionH,
    XZRectOptionYWH = XZRectOptionY | XZRectOptionW | XZRectOptionH
};

//屏幕适配比例系数,只计算一次,按照width来算
static inline CGFloat factor(CGFloat value){
    static dispatch_once_t once_t = 0;
    static CGFloat scale = 0;
    dispatch_once(&once_t, ^{
        scale = [UIScreen mainScreen].bounds.size.width / 375;
    });
    return scale * value;
}

//屏幕适配比例系数，只计算一次，按照height来算
static inline CGFloat Ymul(CGFloat value){
    static dispatch_once_t once_t = 0;
    static CGFloat scale = 0;
    dispatch_once(&once_t, ^{
        scale = [UIScreen mainScreen].bounds.size.height / 667;
    });
    return scale * value;
}

//某一个view的尺寸适配
static inline CGRect fitRect(CGRect frame, BOOL consider){
    CGRect rect = frame;
    if(consider){rect.origin.y -= 64;}
    rect.origin.x = factor(rect.origin.x);
    rect.origin.y = factor(rect.origin.y);
    rect.size.width  = factor(rect.size.width);
    rect.size.height = factor(rect.size.height);
    if(consider){rect.origin.y += TOP;}
    return rect;
}

//主要是针对collectionView设置itemSize
static inline CGSize fitSize(CGSize size){
    CGSize Size = size;
    Size.width  = factor(Size.width);
    Size.height = factor(Size.height);
    return Size;
}

static inline CGPoint fitPoint(CGPoint point, BOOL consider){
    CGPoint Point = point;
    if(consider){Point.y -= 64;}
    Point.x = factor(Point.x);
    Point.y = factor(Point.y);
    if(consider){Point.y += TOP;}
    return Point;
}

//坐标某几个值要定死
static inline CGRect modifyRect(CGRect frame, BOOL consider, XZRectOption opt){
    CGRect rect = frame;
    if(consider){rect.origin.y -= 64;}
    if(opt & XZRectOptionX){
        rect.origin.x = factor(rect.origin.x);
    }
    if(opt & XZRectOptionY){
        rect.origin.y = factor(rect.origin.y);
    }
    if(opt & XZRectOptionW){
        rect.size.width = factor(rect.size.width);
    }
    if(opt & XZRectOptionH){
        rect.size.height = factor(rect.size.height);
    }
    if(consider){rect.origin.y += TOP;}
    return rect;
}

//Y轴上需要按照纵向缩放
static inline CGRect fitY(CGRect frame, BOOL consider){
    CGRect rect = frame;
    if(consider){rect.origin.y -= 64;}
    rect.origin.x = factor(rect.origin.x);
    rect.origin.y = Ymul(rect.origin.y);
    rect.size.width  = factor(rect.size.width);
    rect.size.height = factor(rect.size.height);
    if(consider){rect.origin.y += TOP;}
    return rect;
}


#endif /* BBFrame_h */
