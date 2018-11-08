//
//  ViewController.m
//  Keychain
//
//  Created by ybz on 2018/5/28.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong)UITextField *text;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(16, 64, CGRectGetWidth(self.view.frame) - 32, 32)];
    text.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:text];
    
    UIButton *insertButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [insertButton addTarget:self action:@selector(insert) forControlEvents:UIControlEventTouchUpInside];
    insertButton.frame = CGRectMake(0, CGRectGetMaxY(text.frame) + 16, CGRectGetWidth(self.view.frame), 44);
    [insertButton setTitle:@"Insert" forState:UIControlStateNormal];
    [self.view addSubview:insertButton];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [deleteButton addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.frame = CGRectMake(0, CGRectGetMaxY(insertButton.frame) + 16, CGRectGetWidth(self.view.frame), 44);
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [self.view addSubview:deleteButton];
    
    UIButton *queryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [queryButton addTarget:self action:@selector(query) forControlEvents:UIControlEventTouchUpInside];
    queryButton.frame = CGRectMake(0, CGRectGetMaxY(deleteButton.frame) + 16, CGRectGetWidth(self.view.frame), 44);
    [queryButton setTitle:@"Query" forState:UIControlStateNormal];
    [self.view addSubview:queryButton];
    
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [updateButton addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
    updateButton.frame = CGRectMake(0, CGRectGetMaxY(queryButton.frame) + 16, CGRectGetWidth(self.view.frame), 44);
    [updateButton setTitle:@"Update" forState:UIControlStateNormal];
    [self.view addSubview:updateButton];
    
    self.text = text;
    // Do any additional setup after loading the view, typically from a nib.
}
/**增*/
-(void)insert{
    //指定keychain的attribute，keychain有很多attribute可供使用
    NSDictionary *query = @{(__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleWhenUnlocked,          //指示何时可以访问该条目，这里设置的是仅在为锁屏下可获取，这也是默认选项
                            (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,                         //指示该条项目的类型，这里是设置为密码类型
                            (__bridge id)kSecValueData : [self.text.text dataUsingEncoding:NSUTF8StringEncoding],       //指示值
                            (__bridge id)kSecAttrAccount : @"account name",                                         //指示该条项目的名称，密码才有此属性
                            (__bridge id)kSecAttrService : @"loginPassword",                                        //指示该条项目的服务，密码才有此属性
                            };
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, NULL); //插入到keychain
    if (status == errSecSuccess) {
        NSLog(@"success");
    }else{
        NSLog(@"fail");
    }
}
/**删*/
-(void)delete{
    //会删除所有满足attribute的条目
    NSDictionary *query = @{
                            (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService : @"loginPassword",
                            (__bridge id)kSecAttrAccount : @"account name"
                            };
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    if (status == errSecSuccess) {
        NSLog(@"success");
    }else{
        NSLog(@"fail");
    }
}
/**查*/
-(void)query{
    NSDictionary *query = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecReturnData : @YES,                             //指示是否是返回数据
                            (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitOne,   //指示返回的结果数，kSecMatchLimitOne为单个，KSeMatChimLimTALL为所有
                            (__bridge id)kSecAttrAccount : @"account name",
                            (__bridge id)kSecAttrService : @"loginPassword",
                            };
    
    CFTypeRef dataTypeRef = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &dataTypeRef);
    if (status == errSecSuccess) {
        NSString *pwd = [[NSString alloc] initWithData:(__bridge NSData * _Nonnull)(dataTypeRef) encoding:NSUTF8StringEncoding];
        NSLog(@"==result:%@", pwd);
    }else{
        NSLog(@"fail");
    }
}
/**改*/
-(void)update{
    NSDictionary *query = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrAccount : @"account name",
                            (__bridge id)kSecAttrService : @"loginPassword",
                            };
    NSDictionary *update = @{
                             (__bridge id)kSecValueData : [self.text.text dataUsingEncoding:NSUTF8StringEncoding],
                             };
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)update);
    if (status == errSecSuccess) {
        NSLog(@"success");
    }else{
        NSLog(@"fail");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
