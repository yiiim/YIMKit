//
//  YIMTableSectionManager.h
//  CaiBeiTV
//
//  Created by ybz on 2018/6/22.
//  Copyright © 2018年 scyd. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT const NSInteger YIMTableSectionNotFindSection;

@interface YIMTableSectionItem : NSObject

@end

/**表的组管理*/
@interface YIMTableSectionManager : NSObject

/**追加一个组*/
-(YIMTableSectionItem*)appendSection;
/**使用id追加一个组*/
-(YIMTableSectionItem*)appendSectionWithIdentity:(NSString*)identity;
/**在指定组前面插入一个组*/
-(YIMTableSectionItem*)insertSectionFront:(YIMTableSectionItem*)item;
/**在指定组前面插入一个指定id的组*/
-(YIMTableSectionItem*)insertSection:(NSString*)identity front:(YIMTableSectionItem*)item;
/**在指定组后面插入一个组*/
-(YIMTableSectionItem*)insertSectionBehind:(YIMTableSectionItem *)item;
/**在指定组后面插入一个指定id的组*/
-(YIMTableSectionItem*)insertSection:(NSString*)identity behind:(YIMTableSectionItem *)item;
/**移除指定组*/
-(void)removeSection:(YIMTableSectionItem*)section;
/**移除指定ID的组*/
-(void)removeSectionIdentity:(NSString*)identity;
/**全部移除*/
-(void)removeAll;
/**根据id获取组实例*/
-(YIMTableSectionItem*)sectionItemWithIdentity:(NSString*)identity;
/**获得指定组的组Index*/
-(NSInteger)sectionIndexOfItem:(YIMTableSectionItem*)item;
/**根据ID获得组的Index*/
-(NSInteger)sectionIndexOfIdentity:(NSString*)identity;
/**获得组数量*/
-(NSInteger)numberOfSection;

@end
