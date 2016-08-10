//
//  ViewController.m
//  ErWeiMa
//
//  Created by ylgwhyh on 16/8/10.
//  Copyright © 2016年 com.ylgwhyh.ErWeiMa. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIView * codebackView;
@property (nonatomic, strong) UIImageView  * codeImageView;

@end

@implementation ViewController

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define RGBAColor(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 300, 200, 50)];
    testButton.backgroundColor = [UIColor blueColor];
    testButton.layer.cornerRadius = 5;
    testButton.layer.masksToBounds = 5;
    [testButton setTitle:@"生成二维码(iOS原生)" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];

}

- (void ) testButtonAction {
    
    if (_codebackView == nil) {
        _codebackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _codebackView.backgroundColor = RGBAColor(0, 0, 0, 0.7);
        [self.view addSubview:_codebackView];
        
        _codeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        _codeImageView.center = _codebackView.center;
        _codeImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_codebackView addSubview:_codeImageView];
        
        //如果还想加上阴影，就在ImageView的Layer上使用下面代码添加阴影
        _codeImageView.layer.shadowOffset=CGSizeMake(0, 0.5);//设置阴影的偏移量
        _codeImageView.layer.shadowRadius=1;//设置阴影的半径
        _codeImageView.layer.shadowColor=[UIColor blackColor].CGColor;//设置阴影的颜色为黑色
        _codeImageView.layer.shadowOpacity=0.3;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
        [_codebackView addGestureRecognizer:tapGesture];
        
        [self setCodeImage];
    }
    _codebackView.hidden = NO;
}

- (void)setCodeImage {
    // 1.创建过滤器
    CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    
    // 3.给过滤器添加数据
    NSString * dataString = @"www.baidu.com";
    NSData * data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKey:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage * outPutImage = [filter outputImage];
    _codeImageView.image =  [self createNonInterpolatedUIImageFormCIImage:outPutImage withSize:200];
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)Actiondo:(UIGestureRecognizer *)_sender {
    _codebackView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
