//
//  HoliWebVC.m
//  Holi
//
//  Created by 马朝宇 on 2019/7/6.
//  Copyright © 2019 PC. All rights reserved.
//

#import "HoliWebVC.h"

#import <WebKit/WebKit.h>

@interface HoliWebVC ()<WKUIDelegate>

@property(nonatomic,weak) WKWebView * wkwebview;

@property (weak, nonatomic) IBOutlet UIView *bgBiew;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property(nonatomic,weak) NSTimer * timer;
@property(nonatomic,assign) NSInteger i;

@end

@implementation HoliWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    _bgBiew.layer.cornerRadius = 22.f;
    _bgBiew.clipsToBounds = YES;
    
  UIImageView *  imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];

    [self.view addSubview: imageView];

    [self.view insertSubview:imageView belowSubview:self.bgBiew];

    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]]];


    UIButton * btn  =  [[UIButton alloc] initWithFrame:CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 70)];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:(UIControlEventTouchDragInside)];

    [self.view addSubview:btn];

    [self.view addSubview:self.wkwebview];
    
    // 创建定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerChangeClick) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    _i = 5;
    _closeBtn.userInteractionEnabled = NO;
}


-(void)timerChangeClick{
    
    _i--;
    
    _label.text = [NSString stringWithFormat:@"等待%zd",_i];
    
    if (0 == _i) {
        _label.text = @"关闭";
        _closeBtn.userInteractionEnabled = YES;
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)btnClick{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlString]];
}

- (IBAction)bgBtnClcick:(id)sender {
    
    self.wkwebview = [[WKWebView alloc]initWithFrame:CGRectMake(0.0f,0.0f,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
    [self.wkwebview setUserInteractionEnabled:YES];
    
    self.wkwebview.UIDelegate = self;
    self.wkwebview.navigationDelegate = self;
    [self.wkwebview setOpaque:YES];
    [self.view addSubview:self.wkwebview];
    
    [self.wkwebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.jumpUrl]]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"");
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

    
    
    NSString * str = navigationAction.request.URL.absoluteString;
    if ([str containsString:@"apple.com"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    } else {
        
        if ([str containsString:@"//download"] ||
            [str containsString:@"download"]||
            [str hasPrefix:@"mqq"] ||
            [str hasPrefix:@"weixin://"] ||
            [str hasPrefix:@"wechat://"] ||
            [str hasPrefix:@"alipay://"] ||
            [str hasPrefix:@"alipays://"]) {
            decisionHandler(WKNavigationActionPolicyCancel);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }else{
            decisionHandler(WKNavigationActionPolicyAllow);
        }
   }
}


@end
