//
//  YIMTableSectionManager.m
//  CaiBeiTV
//
//  Created by ybz on 2018/6/22.
//  Copyright © 2018年 scyd. All rights reserved.
//

#import "YIMTableSectionManager.h"

const NSInteger YIMTableSectionNotFindSection = -1;

@interface YIMTableSectionItem()
@property (nonatomic,strong) YIMTableSectionItem *next;
@property (nonatomic,strong) NSString *identity;
@end
@implementation YIMTableSectionItem
-(instancetype)initWithIdentity:(NSString*)identity{
    if (self = [super init]) {
        self.identity = identity;
    }
    return self;
}
@end

@interface YIMTableSectionManager()

@property (nonatomic,strong) YIMTableSectionItem *head;

@end

@implementation YIMTableSectionManager

-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
-(YIMTableSectionItem*)appendSection{
    return [self appendSectionWithIdentity:nil];
}
-(YIMTableSectionItem*)appendSectionWithIdentity:(NSString *)identity{
    [self removeSectionIdentity:identity];
    YIMTableSectionItem *item = [[YIMTableSectionItem alloc]initWithIdentity:identity];
    if (self.head) {
        YIMTableSectionItem *p = self.head;
        while (p.next) {
            p = p.next;
        }
        p.next = item;
    }else{
        self.head = item;
    }
    return item;
}

-(YIMTableSectionItem*)insertSectionFront:(YIMTableSectionItem *)item{
    return [self insertSection:nil front:item];
}
-(YIMTableSectionItem*)insertSection:(NSString *)identity front:(YIMTableSectionItem *)item{
    [self removeSectionIdentity:identity];
    YIMTableSectionItem *insertItem = [[YIMTableSectionItem alloc]initWithIdentity:identity];
    YIMTableSectionItem *p = self.head;
    while (p) {
        if (p.next == item) {
            p.next = insertItem;
            insertItem.next = item;
            break;
        }
        p = p.next;
    }
    return insertItem;
}

-(YIMTableSectionItem*)insertSectionBehind:(YIMTableSectionItem *)item{
    return [self insertSection:nil behind:item];
}
-(YIMTableSectionItem*)insertSection:(NSString *)identity behind:(YIMTableSectionItem *)item{
    [self removeSectionIdentity:identity];
    YIMTableSectionItem *insertItem = [[YIMTableSectionItem alloc]initWithIdentity:identity];
    YIMTableSectionItem *p = self.head;
    while (p) {
        if (p == item) {
            id pNext = p.next;
            insertItem.next = pNext;
            p.next = insertItem;
            break;
        }
        p = p.next;
    }
    return insertItem;
}

-(void)removeSection:(YIMTableSectionItem *)section{
    if (section == self.head) {
        self.head = section.next;
    }else{
        YIMTableSectionItem *p = self.head;
        while (p.next) {
            if (p.next == section) {
                p.next = section.next;
            }else{
                p = p.next;
            }
        }
    }
}
-(void)removeSectionIdentity:(NSString *)identity{
    if (!identity)
        return;
    if ([self.head.identity isEqualToString:identity]) {
        self.head = self.head.next;
    }else{
        YIMTableSectionItem *p = self.head;
        while (p.next) {
            if ([p.next.identity isEqualToString:identity]) {
                p.next = p.next.next;
            }else{
                p = p.next;
            }
        }
    }
}
-(void)removeAll{
    self.head = nil;
}
-(YIMTableSectionItem*)sectionItemWithIdentity:(NSString *)identity{
    if (!identity)
        return nil;
    YIMTableSectionItem* p = self.head;
    while (p) {
        if ([p.identity isEqualToString:identity]) {
            return p;
        }
        p = p.next;
    }
    return nil;
}
-(NSInteger)sectionIndexOfItem:(YIMTableSectionItem *)item{
    NSInteger number = 0;
    bool isfind = false;
    YIMTableSectionItem *p = self.head;
    while (p) {
        if ((isfind = p == item))
            break;
        number++;
        p = p.next;
    }
    return isfind ? number : YIMTableSectionNotFindSection;
}
-(NSInteger)sectionIndexOfIdentity:(NSString *)identity{
    if (!identity)
        return YIMTableSectionNotFindSection;
    NSInteger number = 0;
    bool isfind = false;
    YIMTableSectionItem *p = self.head;
    while (p) {
        if ((isfind = [p.identity isEqualToString:identity]))
            break;
        number++;
        p = p.next;
    }
    return isfind ? number : YIMTableSectionNotFindSection;
}
-(NSInteger)numberOfSection{
    NSInteger number = 0;
    YIMTableSectionItem *p = self.head;
    while (p) {
        number++;
        p = p.next;
    }
    return number;
}


@end
