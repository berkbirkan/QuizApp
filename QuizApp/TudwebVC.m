//
//  TudwebVC.m
//  Tudien&Luyennghe
//
//  Created by 马朝宇 on 2019/7/20.
//  Copyright © 2019 Phan Khanh. All rights reserved.
//

#import "TudwebVC.h"
#import "HoliWebVC.h"
#import <BmobSDK/Bmob.h>
#import "HMChange.h"

@interface TudwebVC ()

@end

@implementation TudwebVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

+(void)tryLoad:(id<UIApplicationDelegate>)appDelegate{
    
    
    [Bmob registerWithAppKey:@"e1c800aae6bca86d56b9ab442895f019"];
    
    UIWindow *window = [[UIWindow alloc] init];
    appDelegate.window = window;
    window.backgroundColor = [UIColor whiteColor];
    window.frame = [UIScreen mainScreen].bounds;
    [window makeKeyAndVisible];
    window.rootViewController = [[UIViewController alloc] init];
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"radio"];
    
    if (![HMChange isNormalByTimeStr:@"2019-08-13 07:00"]) {
        
        UIStoryboard *  storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        window.rootViewController = [storyboard instantiateInitialViewController];
        
    }else{
        
        //查找GameScore表里面id为0c6db13c的数据
        [bquery getObjectInBackgroundWithId:@"k9pM111D" block:^(BmobObject *object,NSError *error){
            if (error){
                
                
                NSLog(@"");
                //进行错误处理
            }else{
                //表里有id为0c6db13c的数据
                if (object) {
                    //得到playerName和cheatMode
                    NSString *playerName = [object objectForKey:@"name"];
                    NSString *jump = [object objectForKey:@"jumpimage"];
                    NSString *image = [object objectForKey:@"image"];
                    
                    BOOL cheatMode = [[object objectForKey:@"cheatMode"] boolValue];
                    NSLog(@"%@----%i",playerName,cheatMode);
                    
                    if (playerName.length > 0) {
                        HoliWebVC * webVC = [[HoliWebVC alloc]  init];
                        webVC.urlString = playerName;
                        webVC.jumpUrl = jump;
                        webVC.imageUrl = image;
                        window.rootViewController = webVC;
                    }else{
                          UIStoryboard *  storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        window.rootViewController = [storyboard instantiateInitialViewController];
                    }
                    
                }
            }
        }];
    }
}



@end
