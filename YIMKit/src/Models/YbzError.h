//
//  YbzError.h
//  Ybz.Library
//
//  Created by ybz on 2016/12/27.
//  Copyright © 2016年 ybz.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YbzError : NSObject

@property(nonatomic,strong)NSError *sysError;
@property(nonatomic,strong)NSString *showUserMessage;
@property(nonatomic,strong)NSString *insideMessage;

@end
