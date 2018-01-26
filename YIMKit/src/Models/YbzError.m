//
//  YbzError.m
//  Ybz.Library
//
//  Created by ybz on 2016/12/27.
//  Copyright © 2016年 ybz.com. All rights reserved.
//

#import "YbzError.h"

@implementation YbzError

-(NSString*)insideMessage{
    if (!_insideMessage && self.sysError) {
        return self.sysError.description;
    }
    return _insideMessage;
}
-(NSString*)description{
    return [NSString stringWithFormat:@"showUserMessage:%@\ninsideMessage:%@",self.showUserMessage,self.insideMessage];
}
-(NSString*)debugDescription{
    return [NSString stringWithFormat:@"showUserMessage:%@\ninsideMessage:%@",self.showUserMessage,self.insideMessage];
}

@end
