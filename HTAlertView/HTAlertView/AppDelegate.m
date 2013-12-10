//
//  AppDelegate.m
//  HTAlertView
//
//  Created by Mr.Yang on 13-12-4.
//  Copyright (c) 2013年 MoonLightCompany. All rights reserved.
//

#import "AppDelegate.h"
#import "HTAlertView.h"
#import "UIView+Animation.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    self.window.backgroundColor = [UIColor greenColor];
    [self.window makeKeyAndVisible];
    
    HTMoreButtons *view = [HTMoreButtons alertViewButtons:@"1", @"2", @"3", @"4", nil];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor grayColor];
    CGRect rect = view.frame;
    rect.origin.x = 20;
    rect.origin.y = 50;
    view.frame = rect;
    [view setButtonClickBlock:^(UIButton *button, NSInteger i) {
        if (i == 0) {
            [self buttonClicked:nil];
        }else if (i == 1){
            [self buttonClicked1:nil];
        }else if (i == 2){
            
            [self buttonClicked2:nil];
        }else if (i == 3){
            
            [self buttonClicked3:nil];
        }else if (i == 4){
            
         
        }
    }];
    [self.window addSubview:view];
    
    return YES;
}

- (void)buttonClicked2:(UIButton *)button
{
    [HTAlertView alert:@"hello, world"];
}

- (void)buttonClicked3:(UIButton *)button
{
    [[HTAlertView alertViewWithTitle:@"hello" Content:@"my code world~" submitButton:@"确定", @"取消", nil] setButtonClickBlock:^(UIButton *button, NSInteger i){
    
    
    }];
    
}


- (void)buttonClicked:(UIButton *)button
{
    
    HTAlertView *view = [HTAlertView alert:@"水电费的是否"];
    [view setButtonClickBlock:^(UIButton *button, NSInteger i){
        NSLog(@"button:%@", button);
        NSLog(@"=====:%d", i);
    }];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    UITextField *view3 = [[UITextField alloc] initWithFrame:CGRectMake(60, 10, 200, 30)];
    UITextField *view2 = [[UITextField alloc] initWithFrame:CGRectMake(60, 50, 200, 30)];
    view3.borderStyle = UITextBorderStyleRoundedRect;
    view2.borderStyle = UITextBorderStyleRoundedRect;
    view1.autoresizesSubviews = YES;
    view3.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
    view2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
    [view1 addSubview:view2];
    [view1 addSubview:view3];
    view.contentView = view1;
}

- (void)buttonClicked1:(UIButton *)button
{
    HTAlertView *view1 = [HTAlertView alertViewWithTitle:@"123" Content:@"fsfesfsfsfsesdfsdfskdfsdfhdkslfjjsdlfjlksdjlkjflkdsjklfjsldkfjklsjdlkfjlksdjflkjdslkjflksjdlkflksdlkfjsldjfsfffsfesfsfsfsesdfsdfskdfsdfhdkslfjjsdlfjlksdjlkjflkdsjklfjsldkfjklsjdlkfjlksdjflkjdslkjflksjdlkflksdlkfjsldjfjsldkjfklsjdklsfesfsfsfsesdfsdfskdfsdfhdkslfjjsdlfjlksdjlkjflkdsjklfjsldkfjklsjdlkfjlksdjflkjdslkjflksjdlkflksdlkfjsldjfjsldkjfklsjdklfsfesfsfsfsesdfsdfskdfsdfhdkslfjjsdlfjlksdjlkjflkdsjklfjsldkfjklsjdlkfjlksdjflkjdslkjflksjdlkflksdlkfjsldjfjsldkjfklsjdklsfesfsfsfsesdfsdfskdfsdfhdkslfjjsdlfjlksdjlkjflkdsjklfjsldkfjklsjdlkfjlksdjflkjdslkjflksjdlkflksdlkfjsldjfjsldkjfklsjdklfesfsfsfsesdfsdfskdfsdfhdkslfjjsdlfjlksdjlkjflkdsjklfjsldkfjklsjdlkfjlksdjflkjdslkjflksjdlkflksdlkfjsldjfjsldkjfklsjdklfjslfsfesfsfsfsesdfsdfskdfsdfhdkslfjjsdlfjlksdjlkjflkdsjklfjsldkfjklsjdlkfjlksdjflkjdslkjflksjdlkflksdlkfjsldjfjsldkjfklsjdklfsfesfsfsfsesdfsdfskdfsdfhdkslfjjsdlfjlksdjlkjflkdsjklfjsldkfjklsjdlkfjlksdjflkjdslkjflksjdlkflksdlkfjsldjfjsldkjfklsjdklfsfesfsfsfsesdfsdfskdfsdfhdkslfjjsdlfjlksdjlkjflkdsjklfjsldkfjklsjdlkfjlksdjflkjdslkjflksjdlkflksdlkfjsldjfjsldkjfklsjdklfsfesfsfsfsesdfsdfskdfsdfhdkslfjjsdlfjlksdjlkjflkdsjklfjsldkfjklsjdlkfjlksdjflkjdslkjflksjdlkflksdlkfjsldjfjsldkjfklsjdkldkjfklsjdkl" submitButton:@"1",@"2",@"3", @"4", nil];

    [view1 setButtonClickBlock:^(UIButton *button, NSInteger i) {
        NSLog(@"button:%@", button);
        NSLog(@"=====:%d", i);
    }];
    
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    HTShdowView *view = [[HTShdowView alloc] init];
//    view.showGradient = YES;
//
//    [view setShdowViewTouchedBlock:^(HTShdowView *view) {
//        [view removeFromSuperview];
//    }];
//    [self.window addSubview:view];
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
