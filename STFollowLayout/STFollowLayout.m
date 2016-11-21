//
//  STFollowLayout.m
//  STFollowLayout
//
//  Created by xiudou on 2016/11/21.
//  Copyright © 2016年 xiudo. All rights reserved.
//

#import "STFollowLayout.h"
#define WINDOW_WIDTH [UIScreen mainScreen].bounds.size.width
#define WINDOW_HEIGHT [UIScreen mainScreen].bounds.size.height

#pragma mark - 常量
/** 总列数 */
static const NSUInteger  stColumnCount = 3;
/** 列间距 */
static const CGFloat  stColumSpacing = 10;
/** 行间距 */
static const CGFloat  stRowSpacing = 10;
/** 边缘间距 */
static const UIEdgeInsets  stEdgeInsets = {10,10,10,10};

@interface STFollowLayout ()
#pragma mark - 属性
/** atttibutesArray */
@property (nonatomic,strong) NSMutableArray *atttibutesArray;
/** 每一列的总高度数组 */
@property (nonatomic,strong) NSMutableArray *columnHeightArray;
/** 最大高度 */
@property (nonatomic,assign) CGFloat maxHeight;


/** 列数 */
@property (nonatomic,assign) NSUInteger stColumnCount;
/** 列间距 */
@property (nonatomic,assign) CGFloat stColumSpacing;
/** 行间距 */
@property (nonatomic,assign) CGFloat stRowSpacing;
/** 边缘间距 */
@property (nonatomic,assign) UIEdgeInsets stEdgeInsets;
@end
@implementation STFollowLayout
#pragma mark - GET
// 列数
- (NSUInteger)stColumnCount{
    if ([self.delegate respondsToSelector:@selector(stLayoutColumnCountStLayout:)]) {
        
        return [self.delegate stLayoutColumnCountStLayout:self];
    }else{
        
        return stColumnCount;
    }
}

// 列间距
- (CGFloat)stColumSpacing{
    if ([self.delegate respondsToSelector:@selector(stLayoutcolumnSpacingStLayout:)]) {
        return [self.delegate stLayoutcolumnSpacingStLayout:self];
    }else{
        
        return stColumSpacing;
    }
}

// 行间距
- (CGFloat)stRowSpacing{
    
    if ([self.delegate respondsToSelector:@selector(stLayoutRowSpacingStLayout:)]) {
        
        return [self.delegate stLayoutRowSpacingStLayout:self];
    }else{
        
        return stRowSpacing;
    }
}

// 边缘间距
- (UIEdgeInsets)stEdgeInsets{
    
    if ([self.delegate respondsToSelector:@selector(stLayoutEdgeInsetsStLayout:)]) {
        return [self.delegate stLayoutEdgeInsetsStLayout:self];
    }else{
        
        return stEdgeInsets;
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)atttibutesArray{
    if (!_atttibutesArray) {
        _atttibutesArray = [NSMutableArray array];
    }
    return _atttibutesArray;
}
- (NSMutableArray *)columnHeightArray{
    if (!_columnHeightArray) {
        _columnHeightArray = [NSMutableArray array];
    }
    return _columnHeightArray;
}
#pragma mark - 准备工作
- (void)prepareLayout{
    
    [super prepareLayout];
    
    self.maxHeight = 0;
    
    // 0 清除数据
    [self.atttibutesArray removeAllObjects];
    [self.columnHeightArray removeAllObjects];
    
    
    for (int i = 0; i < self.stColumnCount; i ++) {
        [self.columnHeightArray addObject:@(self.stEdgeInsets.top)];
    }
    
    // 1 获取总共有多少item(一般情况下是一部分)
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (int index = 0; index < count; index ++) {
        // 2 获取对象的indexPath
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        // 3 去除对应indexPath的LayoutAttributes对象
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        // 5 添加到数组
        [self.atttibutesArray addObject:attributes];
    }
    
    
}

// return an array layout attributes instances for all the views in the given rect
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.atttibutesArray;
    
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // 最短的那一列
    __block NSUInteger desColumn = 0;
    // 最高的那一列高度
    //    __block CGFloat maxcolumnHeight = 0;
    // 最短的列总高
    __block CGFloat mincolumnHeight = MAXFLOAT;
    // 遍历找出最"短"的那一列
    [self.columnHeightArray enumerateObjectsUsingBlock:^(NSNumber  * columnHeightObj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (mincolumnHeight > [columnHeightObj doubleValue]) {
            mincolumnHeight = [columnHeightObj doubleValue];
            desColumn = idx;
        }
    }];
    // 4 设置尺寸
    // 4.1 计算尺寸
    CGFloat width = (WINDOW_WIDTH - self.stEdgeInsets.left - self.stEdgeInsets.right - (self.stColumnCount - 1) * self.stColumSpacing) / self.stColumnCount;
    CGFloat X = self.stEdgeInsets.left + desColumn * (width + self.stColumSpacing);
    CGFloat height = [self.delegate stLayout:self heightForRowAtIndexPath:indexPath itemWidth:width];
    CGFloat Y = (mincolumnHeight == self.stEdgeInsets.top) ? mincolumnHeight : (mincolumnHeight + self.stRowSpacing);
    attributes.frame = CGRectMake(X, Y, width, height);
    // 存储数据
    self.columnHeightArray[desColumn] = @(CGRectGetMaxY(attributes.frame));
    return attributes;
}


// Subclasses must override this method and use it to return the width and height of the collection view’s content. These values represent the width and height of all the content, not just the content that is currently visible. The collection view uses this information to configure its own content size to facilitate scrolling
- (CGSize)collectionViewContentSize{
    // 最好重新计算一边高度(不能保证在添加一个item后,这个item的最大Y值就是最大的!!!)
    __block CGFloat contentHeight = 0;
    [self.columnHeightArray enumerateObjectsUsingBlock:^(NSNumber  * columnHeightObj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (contentHeight < [columnHeightObj doubleValue]) {
            contentHeight = [columnHeightObj doubleValue];
        }
    }];
    
    return CGSizeMake(0, contentHeight + self.stEdgeInsets.bottom);
}

@end
