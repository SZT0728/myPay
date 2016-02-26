//
//  ViewController.m
//  myPay
//
//  Created by SZT on 16/1/6.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "ViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    商户app申请的的账号信息
    NSString *partner = @"";
    NSString *seller = @"";
    NSString *privateKey = @"";
    
    
    //1. 生成订单信息
    Order *order = [[Order alloc] init];
    //
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = @"2015xxxxxxx"; //订单ID(根据后台的接口返回信息来确定)
    order.productName = @"薯片";
    //商品标题
    order.productDescription = @"乐视薯片"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",9.99]; //商品的价格
    
    
    order.notifyURL = @"http://www.xxx.com/source=1"; //回调URL
    order.service = @"mobile.securitypay.pay";//这个字符串是支付宝规定的不可修改
    order.paymentType = @"1";//支付类型，默认是1，表示商品购买
    order.inputCharset = @"utf-8";//固定的编码
    order.itBPay = @"30m"; //未付款交 易的超时 时间
    
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdk123";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    
    //2. 签名
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];

    
    //将签名成功字符串格式化为订单字符串
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
//        当手机中没有客户端的时候再当前处理支付的回调
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
        

    }

    
}


@end
