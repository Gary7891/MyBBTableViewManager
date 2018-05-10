//
//  RootViewController.m
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/8.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "RootViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"



@interface RootViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) UIViewController                *firstViewController;

@property (nonatomic, strong) UIViewController                *secondeViewController;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:[self imageWithColor:HEX_COLOR(0xd9d9d9) size:CGSizeMake(ScreenWidth, 0.5)]];
    
    self.tabBar.translucent = NO;
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    
}

- (void)uiConfig
{
    
    _firstViewController = [self viewControllerWithTabTitle:@"ASTb" image:@"shouye-shouye" selectedImage:@"shouye-xuanzhongshouye" className:@"FirstViewController"]; //HomeASViewController   TTHomeViewController
    
    _secondeViewController = [self viewControllerWithTabTitle:@"UITb" image:@"shouye-fenle" selectedImage:@"shouye-xuanzhongfenlei" className:@"SecondViewController"];
    
    
    
    
    
    self.viewControllers = @[_firstViewController,_secondeViewController];
    
}


//默认图片设置以及选中状态图片设置
- (UINavigationController *)viewControllerWithTabTitle:(NSString*)title image:(NSString *)image selectedImage:(NSString *)selectedImage className:(NSString *)className
{
    Class cls = NSClassFromString(className);
    UIViewController *viewController = [[cls alloc] init];
    
    UIImage *Image = [UIImage imageNamed:image];
    UIImage *ImageSel = [UIImage imageNamed:selectedImage];
    
    Image = [Image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ImageSel = [ImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:Image selectedImage:ImageSel];
    
    self.tabBar.tintColor=[UIColor redColor];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navController.delegate = self;
    return navController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

@end
