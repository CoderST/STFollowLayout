//
//  STFollowLayout.h
//  STFollowLayout
//
//  Created by xiudou on 2016/11/21.
//  Copyright © 2016年 xiudo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class STFollowLayout;
@protocol STFollowLayoutDelegate <NSObject>

@required
// Variable height support
- (CGFloat)stLayout:(STFollowLayout *)stLayout heightForRowAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

@optional
// Number of Columns
- (NSUInteger)stLayoutColumnCountStLayout:(STFollowLayout *)stLayout;
// Space of Colums
- (CGFloat)stLayoutcolumnSpacingStLayout:(STFollowLayout *)stLayout;
// Spacing of Row
- (CGFloat)stLayoutRowSpacingStLayout:(STFollowLayout *)stLayout;
// TOP DOWN LEFT RIGHT
- (UIEdgeInsets)stLayoutEdgeInsetsStLayout:(STFollowLayout *)stLayout;

@end
@interface STFollowLayout : UICollectionViewLayout
@property (nonatomic,weak) id<STFollowLayoutDelegate> delegate;
@end
