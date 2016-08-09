//
//  YJYYWebViewController.h
//  YJYYAdvertisementDemo
//
//  Created by 遇见远洋 on 16/8/9.
//  Copyright © 2016年 遇见远洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJYYWebViewController : UIViewController

@end


@interface UIViewController (YJYYPublic)
///该vc的navigationController
- (UINavigationController*)YJYY_navigationController;
@end
