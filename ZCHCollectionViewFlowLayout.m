//
//  collectionViewFlowLayout.m
//  collectionViewTest
//
//  Created by 张晨晖 on 2017/10/26.
//  Copyright © 2017年 张晨晖. All rights reserved.
//

#import "ZCHCollectionViewFlowLayout.h"

@interface ZCHCollectionViewFlowLayout ()

@property (nonatomic ,strong) NSMutableArray <UICollectionViewLayoutAttributes *> *ZCHAttributesArray;

@property (nonatomic ,assign) CGFloat lastX;

@property (nonatomic ,assign) CGFloat lastY;

@property (nonatomic ,assign) CGFloat lastWidth;

@property (nonatomic ,assign) CGFloat lastHeight;

@end

@implementation ZCHCollectionViewFlowLayout

- (void)prepareLayout {//准备布局
    [super prepareLayout];
    self.itemSize = CGSizeMake(10, 10);
    self.estimatedItemSize = CGSizeMake(10, 10);

    //初始化
    _ZCHAttributesArray = [NSMutableArray array];
//    [_ZCHAttributesArray removeAllObjects];
    _lastX = 0.0;
    _lastY = 0.0;
    _lastWidth = 0.01;
    _lastHeight = 0.01;

    //拿到cell的个数
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {//拿到每个cell的属性
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //获取对应indexPath的cell对应的布局的属性
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        //把属性添加到数组中保存
        [_ZCHAttributesArray addObject:attributes];
    }

}

//返回所有cell的布局属性.以及整体cell的排布
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    [super layoutAttributesForElementsInRect:rect];
    return self.ZCHAttributesArray;
}

//返回cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //旧的布局属性
    UICollectionViewLayoutAttributes *oldAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
//    NSLog(@"%@",@(oldAttributes.frame));
    //创建布局属性
    UICollectionViewLayoutAttributes *newAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //准备获取cell的fram;
    CGFloat width;
    CGFloat height;
    CGFloat x = 0.0;
    CGFloat y = 0.0;

    //获取宽度,高度为old的高度
    width = oldAttributes.frame.size.width;
    height = oldAttributes.frame.size.height;

    CGFloat headerX = 0.0;
    CGFloat footerX = 0.0;
    CGFloat headerY = 0.0;
    CGFloat footerY = 0.0;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        headerY = self.headerReferenceSize.height;
        footerY = self.footerReferenceSize.height;
    } else {
        headerX = self.headerReferenceSize.width;
        footerX = self.headerReferenceSize.width;
    }

    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        //获取x,y的大小,y的位置需要判断X是否超出屏幕
        x = indexPath.row == 0 ? self.sectionInset.left : self.lastX + self.minimumInteritemSpacing + self.sectionInset.right;
        if (x + width > self.collectionView.bounds.size.width - self.sectionInset.right) {//如果x+width超出屏幕范围,则y要下移
            y = self.lastY + height + self.sectionInset.top + self.sectionInset.bottom + self.minimumLineSpacing;
            x = self.sectionInset.left;
        } else {
            y = headerY;
            if (self.lastY >= height) {//如果不是第一行
                y = self.lastY;
            }
        }
        self.lastX = x + width;
        self.lastY = y;
    } else {
        //获取x,y的大小,y的位置需要判断X是否超出屏幕
        y = indexPath.row == 0 ? self.sectionInset.top : self.lastY + self.minimumInteritemSpacing + self.sectionInset.top;
        if (y + height > self.collectionView.bounds.size.height + self.sectionInset.bottom) {//如果y+width超出屏幕范围,则y要下移
            x = self.lastX + width + self.sectionInset.left + self.sectionInset.right + self.minimumLineSpacing;
            //            self.lastY + height + self.minimumLineSpacing + self.sectionInset.top;
            y = self.sectionInset.top;
        } else {
            x = self.sectionInset.left;
            if (self.lastX > width) {
                x = self.lastX;
            }
        }
        self.lastX = x;
        self.lastY = y + height;
    }

    //设置cell的新frame
    newAttributes.frame = CGRectMake(x, y, width, height);

    //width和height是公共的
    self.lastWidth = width;
    self.lastHeight = height;

    return newAttributes;
}

- (CGSize)collectionViewContentSize {
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {//垂直滚动
        return CGSizeMake(self.collectionView.bounds.size.width, self.ZCHAttributesArray.lastObject.frame.origin.y + self.ZCHAttributesArray.lastObject.frame.size.height + self.headerReferenceSize.height + self.footerReferenceSize.height + self.sectionInset.top + self.sectionInset.bottom);
    } else {//水平滚动
        return CGSizeMake(self.ZCHAttributesArray.lastObject.frame.origin.x + self.ZCHAttributesArray.lastObject.frame.size.width + self.headerReferenceSize.width + self.footerReferenceSize.width + self.sectionInset.left + self.sectionInset.right, self.collectionView.bounds.size.height);
    }
}

@end
