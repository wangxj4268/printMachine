//
//  ViewController.m
//  打印机
//
//  Created by 王雪剑 on 17/7/24.
//  Copyright © 2017年 zkml－wxj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

{
    UIWebView *myWebView;
    id myPDFData;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self printAction];
    
    //[self clike:nil];
}

#pragma mark ---打印图片、pdf文件
-(void)printAction{
    
    
    NSString *str = [[NSBundle mainBundle] pathForResource:@"4.行驶中_0_spec.png" ofType:nil];
    myPDFData = [NSData dataWithContentsOfFile:str];
    
    UIPrintInteractionController* pic = [UIPrintInteractionController sharedPrintController];
    NSData *imageData = [NSData dataWithData:myPDFData];
    if (pic && [UIPrintInteractionController canPrintData:imageData])
    {
        pic.delegate = self;
        
        //        打印任务细节在 UIPrintInfo 实例中设置。可以使用以下属性：
        UIPrintInfo* printInfo = [UIPrintInfo printInfo];
        
        //        UIPrintInfoOutputType：给 UIKit 提供要打印内容的类型提示。可以是以下任意一个：
        //        .General（默认）：文本和图形混合类型；允许双面打印。
        //        .Grayscale：如果你的内容只包括黑色文本，那么该类型比 .General 更好。
        //        .Photo：彩色或黑白图像；禁用双面打印，更适用于图像媒体的纸张类型。
        //        .PhotoGrayscale：对于仅灰度的图像，根据打印机的不同，该类型可能比 .Photo 更好。
        printInfo.outputType = UIPrintInfoOutputGeneral;
        //        jobName String：此打印任务的名称。这个名字将被显示在设备的打印中心，对于有些打印机则显示在液晶屏上
        printInfo.jobName = @"PrintingImage";
        //         UIPrintInfoDuplex：.None、.ShortEdge 或 .LongEd​​ge。short- 和 long- 的边界设置指示如何装订双面页面，而 .None 不支持双面打印（这里不是 UI 切换为双面打印，令人困惑）
        printInfo.duplex = UIPrintInfoDuplexShortEdge;
        
        //        UIPrintInfo：之前所述的打印任务的配置
        pic.printInfo = printInfo;
        //        showsPageRange Bool：当值为 true 时，让用户从打印源中选择一个子范围。这只在多页内容时有用，它默认关闭了图像。
        pic.showsPageRange = NO;
        
        pic.printingItem = imageData;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"FAILED! due to error in domain %@ with error code %lu", error.domain, error.code);
            }
        };
        
        //        [pic presentAnimated:YES completionHandler:completionHandler];
        
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            [pic presentFromRect:self.view.frame inView:self.view animated:YES completionHandler:completionHandler];
        }
        else {
            [pic presentAnimated:YES completionHandler:completionHandler];
        }
    }
}

#pragma mark ---打印网页
- (void)clike:(UIButton *)sender {
    myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 375, 667)];
    [self.view addSubview:myWebView];
    
    UIPrintInteractionController *printC = [UIPrintInteractionController sharedPrintController];//显示出打印的用户界面。
    printC.delegate = self;
    
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];//准备打印信息以预设值初始化的对象。
    printInfo.outputType = UIPrintInfoOutputGeneral;//设置输出类型。
    printC.showsPageRange = YES;//显示的页面范围
    
    //    打印网页
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];//网页
    
    printC.printFormatter = [myWebView viewPrintFormatter];//布局打印视图绘制的内容。
    
    
    //     //    打印文本
    //     UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc]
    //     initWithText:@"ここの　ういえい　子に　うぃっl willingseal  20655322　　你好么？ ＃@¥％……&＊"];
    //     textFormatter.startPage = 0;
    //     textFormatter.contentInsets = UIEdgeInsetsMake(200, 300, 0, 72.0); // 插入内容页的边缘 1 inch margins
    //     textFormatter.maximumContentWidth = 16 * 72.0;//最大范围的宽
    //     printC.printFormatter = textFormatter;
    //
    
    
    //    等待完成
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"可能无法完成，因为印刷错误: %@", error);
        }
    };
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:sender];//调用方法的时候，要注意参数的类型－下面presentFromBarButtonItem:的参数类型是 UIBarButtonItem..如果你是在系统的UIToolbar or UINavigationItem上放的一个打印button，就不需要转换了。
        [printC presentFromBarButtonItem:item animated:YES completionHandler:completionHandler];//在ipad上弹出打印那个页面
        
        //        [printC presentFromRect:CGRectMake(500, 500, 100, 200) inView:self.webView animated:YES completionHandler:completionHandler];//第二种方法
        
        
    } else {  
        [printC presentAnimated:YES completionHandler:completionHandler];//在iPhone上弹出打印那个页面  
    }  
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
