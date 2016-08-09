//
//  CMAdvertisement.m
//  Chemucao
//
//  Created by 遇见远洋 on 16/8/8.
//  Copyright © 2016年 CMC_IOS. All rights reserved.
//

#import "CMAdvertisement.h"
#import "YJYYWebViewController.h"

@interface CMAdvertisement ()
@property (nonatomic, strong) UIWindow* window;
@property (nonatomic, assign) NSInteger downCount;
@property (nonatomic, weak) UIButton* downCountButton;

@end

@implementation CMAdvertisement
///在load 方法中，启动监听，可以做到无注入
+ (void)load
{
    [self shareInstance];
}

+ (instancetype)shareInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        ///应用启动, 首次开屏广告
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            ///要等DidFinished方法结束后才能初始化UIWindow，不然会检测是否有rootViewController
            dispatch_async(dispatch_get_main_queue(), ^{
                [self checkAD];
            });
        }];
        ///进入后台
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self requestNewData];
        }];
        ///后台启动,二次开屏广告
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self checkAD];
        }];
    }
    return self;
}


/**
 *  进入后台再返回时请求信的广告数据
 */
- (void)requestNewData
{
    ///.... 请求新的广告数据
}


/**
 *  检查是否有跟控制器
 */
- (void)checkAD
{
    ///如果有则显示，无则请求， 下次启动再显示。
    ///我们这里都当做有
    [self showImageView];
}


/**
 *  展示启动页广告图片
 */
- (void)showImageView
{
    ///初始化一个Window， 做到对业务视图无干扰。
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    ///广告布局
    [self setupSubviews:window];
    
    ///设置为最顶层，防止 AlertView 等弹窗的覆盖
    window.windowLevel = UIWindowLevelStatusBar + 1;
    
    ///默认为YES，当你设置为NO时，这个Window就会显示了
    window.hidden = NO;
    
    ///来个渐显动画
    window.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        window.alpha = 1;
    }];
    
    ///防止释放，显示完后  要手动设置为 nil
    self.window = window;
}



/**
 *  初始化显示的视图， 可以挪到具
 *
 *  @param window
 */
- (void)setupSubviews:(UIWindow*)window
{
    ///随便写写
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:window.bounds];
    imageView.image = [UIImage imageNamed:@"ADImage"];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.userInteractionEnabled = YES;
    
    //给非UIControl的子类，增加点击事件
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToADViewController)];
    [imageView addGestureRecognizer:tap];
    
    [window addSubview:imageView];
    
    ///增加一个倒计时跳过按钮
    self.downCount = 3;
    
    UIButton * goout = [[UIButton alloc] initWithFrame:CGRectMake(window.bounds.size.width - 100 - 20, 20, 100, 60)];
    [goout setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [goout addTarget:self action:@selector(dismissAdImageView) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:goout];
    
    self.downCountButton = goout;
    [self timer];
}



/**
 *  点击广告跳转页面 这就是你要做的广告页面
 */
- (void)pushToADViewController {
    ///不直接取KeyWindow 是因为当有AlertView 或者有键盘弹出时， 取到的KeyWindow是错误的。
    UIViewController* rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    [[rootVC YJYY_navigationController] pushViewController:[YJYYWebViewController new] animated:YES];
    
    [self hide];
}


/**
 *  移除视图
 */
- (void)dismissAdImageView
{
    [self hide];
}



/**
 *  移除视图
 */
- (void)hide
{
    ///来个渐显动画
    [UIView animateWithDuration:0.3 animations:^{
        self.window.alpha = 0;
    } completion:^(BOOL finished) {
        [self.window.subviews.copy enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        self.window.hidden = YES;
        self.window = nil;
    }];
    
}


/**
 *  时间递减到0时移除视图
 */
- (void)timer
{
    [self.downCountButton setTitle:[NSString stringWithFormat:@"跳过：%ld",(long)self.downCount] forState:UIControlStateNormal];
    if (self.downCount <= 0) {
        [self hide];
    }
    else {
        self.downCount --;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self timer];
        });
    }
}

@end
