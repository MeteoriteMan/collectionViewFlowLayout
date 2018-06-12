//
//  collectionViewFlowLayout.m
//  collectionViewTest
//
//  Created by 张晨晖 on 2017/10/26.
//  Copyright © 2017年 张晨晖. All rights reserved.
//

#import "ZCHCollectionViewFlowLayout.h"

@interface ZCHCollectionViewFlowLayout ()

@property (nonatomic ,strong) NSMutableArray <UICollectionViewLayoutAttributes *> *ZCHItemAttributesArray;

// ReusableView组头
@property (nonatomic ,strong) NSMutableArray <UICollectionViewLayoutAttributes *> *ZCHReusableHeaderViewAttributesArray;

// ReusableView组尾
@property (nonatomic ,strong) NSMutableArray <UICollectionViewLayoutAttributes *> *ZCHReusableFooterViewAttributesArray;

// Cell相关的计算属性
@property (nonatomic ,assign) CGFloat itemLastX;

@property (nonatomic ,assign) CGFloat itemLastY;

@property (nonatomic ,assign) CGFloat itemLastWidth;

@property (nonatomic ,assign) CGFloat itemLastHeight;

@property (nonatomic ,assign) NSInteger currentSection;

@end

@implementation ZCHCollectionViewFlowLayout

- (void)prepareLayout {//准备布局
    [super prepareLayout];
    self.itemSize = CGSizeMake(10, 10);
    self.estimatedItemSize = CGSizeMake(10, 10);

    //初始化
    _ZCHItemAttributesArray = [NSMutableArray array];
    _ZCHReusableHeaderViewAttributesArray = [NSMutableArray array];
    _ZCHReusableFooterViewAttributesArray = [NSMutableArray array];
//    [_ZCHAttributesArray removeAllObjects];
    _itemLastX = CGFLOAT_MIN;
    _itemLastY = CGFLOAT_MIN;
    _itemLastWidth = CGFLOAT_MIN;
    _itemLastHeight = CGFLOAT_MIN;
    
    _currentSection = -1;

    //拿到cell的个数
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
        NSInteger rows = [self.collectionView numberOfItemsInSection:0];
        for (int i = 0; i < rows; i++) {//拿到每个cell的属性
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:section];
            //获取对应indexPath的cell对应的布局的属性
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            //把属性添加到数组中保存
            [_ZCHItemAttributesArray addObject:attributes];
        }
    }
    //布局ReusableView
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        UICollectionViewLayoutAttributes *reusableViewHeaderAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        if (reusableViewHeaderAttributes != nil) {
            [_ZCHReusableHeaderViewAttributesArray addObject:reusableViewHeaderAttributes];
        }
        UICollectionViewLayoutAttributes *reusableViewFooterAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
        if (reusableViewFooterAttributes != nil) {
            [_ZCHReusableFooterViewAttributesArray addObject:reusableViewFooterAttributes];
        }
    }
}

//返回所有cell的布局属性.以及整体cell的排布
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    [super layoutAttributesForElementsInRect:rect];
//    self.ZCHItemAttributesArray ,self.ZCHReusableHeaderViewAttributesArray ,self.ZCHReusableFooterViewAttributesArray
    NSMutableArray *arrayM = [NSMutableArray array];
    if (self.ZCHReusableHeaderViewAttributesArray.count != 0) {
        [arrayM addObjectsFromArray:self.ZCHReusableHeaderViewAttributesArray];
    }
    if (self.ZCHReusableFooterViewAttributesArray.count != 0) {
        [arrayM addObjectsFromArray:self.ZCHReusableFooterViewAttributesArray];
    }
    if (self.ZCHItemAttributesArray.count != 0) {
        [arrayM addObjectsFromArray:self.ZCHItemAttributesArray];
    }

    return arrayM.copy;
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

//    CGFloat headerX = 0.0;
//    CGFloat footerX = 0.0;
//    CGFloat headerY = 0.0;
//    CGFloat footerY = 0.0;
    CGFloat ReusableViewHeight = 0.0;
    CGFloat ReusableViewWidth = 0.0;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {//横向排布
//        headerX = _sectionIntervalTop;
//        footerX = _sectionIntervalBottom;
        ReusableViewHeight = self.headerReferenceSize.height;
    } else {
//        headerY = _sectionIntervalTop;
//        footerY = _sectionIntervalBottom;
        ReusableViewWidth = self.headerReferenceSize.width;
    }
    
    //处理是否添加组头高度
    if (_currentSection == indexPath.section) {
        ReusableViewWidth = 0.0;
        ReusableViewHeight = 0.0;
    } else if (_currentSection != indexPath.section) {
        _currentSection = indexPath.section;
        self.itemLastY = self.itemLastY + self.sectionInset.top + ReusableViewHeight;
        if (indexPath.section != 0) {
            self.itemLastY = self.itemLastY + self.sectionInset.bottom + self.minimumLineSpacing + height;
        } else {//section == 0
            self.itemLastY += _sectionIntervalTop;
        }
    }

    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {//横向排布
        //获取x,y的大小,y的位置需要判断X是否超出屏幕
        x = indexPath.row == 0 ? self.sectionInset.left + _sectionIntervalLeft : self.itemLastX + self.minimumInteritemSpacing + self.sectionInset.right;
        if (x + width > self.collectionView.bounds.size.width - self.sectionInset.right - _sectionIntervalRight) {//如果x+width超出屏幕范围,则y要下移
            y = self.itemLastY + height + self.sectionInset.top + self.sectionInset.bottom + self.minimumLineSpacing + ReusableViewHeight;
            x = self.sectionInset.left + _sectionIntervalLeft;
        } else {
            //第一行
            y = _sectionIntervalTop + ReusableViewHeight;
            if (self.itemLastY >= height) {//如果不是第一行
                y = self.itemLastY;
            }
        }
        self.itemLastX = x + width;
        self.itemLastY = y;
    }
//    else {
//        //获取x,y的大小,y的位置需要判断X是否超出屏幕
//        y = indexPath.row == 0 ? self.sectionInset.top + headerY : self.lastY + self.minimumInteritemSpacing + self.sectionInset.top;
//        if (y + height > self.collectionView.bounds.size.height + self.sectionInset.bottom) {//如果y+width超出屏幕范围,则y要下移
//            x = self.lastX + width + self.sectionInset.left + self.sectionInset.right + self.minimumLineSpacing;
//            //            self.lastY + height + self.minimumLineSpacing + self.sectionInset.top;
//            y = self.sectionInset.top + headerY;
//        } else {
//            x = self.sectionInset.left;
//            if (self.lastX > width) {
//                x = self.lastX;
//            }
//        }
//        self.lastX = x;
//        self.lastY = y + height;
//    }

    //设置cell的新frame
    newAttributes.frame = CGRectMake(x, y, width, height);

    //width和height是公共的
    self.itemLastWidth = width;
    self.itemLastHeight = height;
    
    if (indexPath.row == [self.collectionView numberOfItemsInSection:indexPath.section] - 1) {//如果是最后一个Row.改变lastY
        self.itemLastY = self.itemLastY + _sectionIntervalBottom + self.footerReferenceSize.height;
    }

    return newAttributes;
}

//返回计算出的header的和footer的高度
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    //旧的布局属性
    UICollectionViewLayoutAttributes *oldAttributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    //    NSLog(@"%@",@(oldAttributes.frame));
    //创建布局属性
    UICollectionViewLayoutAttributes *newAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
//    return oldAttributes;
    //准备获取ReusableView的fram;
    CGFloat width;
    CGFloat height;
    CGFloat x = 0.0;
    CGFloat y = 0.0;

    //获取宽度,高度为old的高度
    width = oldAttributes.frame.size.width;
    height = oldAttributes.frame.size.height;
    
//    //组
//    NSInteger section = indexPath.section;
//    NSInteger row = [self.collectionView numberOfItemsInSection:section] - 1;
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            y = 0.0;
        } else {
            for (UICollectionViewLayoutAttributes *attributes in self.ZCHItemAttributesArray) {
                if (attributes.indexPath.row == [self.collectionView numberOfItemsInSection:indexPath.section - 1] - 1 && attributes.indexPath.section == indexPath.section - 1) {//上面一组的最后一个
                    y = attributes.frame.origin.y + attributes.frame.size.height + self.sectionInset.bottom;
                    NSLog(@"%lf",y);
                    if (indexPath.section != 0) {
                        y = y + self.footerReferenceSize.height + _sectionIntervalBottom;
                    }
                }
                
            }
        }
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            width = self.collectionView.bounds.size.width;
            height = self.headerReferenceSize.height;
        } else {
            
        }
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        if (indexPath.section == 0) {
            y = 0.0;
        } else {
            for (UICollectionViewLayoutAttributes *attributes in self.ZCHItemAttributesArray) {
                if (attributes.indexPath.row == [self.collectionView numberOfItemsInSection:indexPath.section - 1] - 1 && attributes.indexPath.section == indexPath.section) {//本组的最后一个
                    y = attributes.frame.origin.y + attributes.frame.size.height + self.sectionInset.bottom + _sectionIntervalBottom;
                }
            }
        }
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            width = self.collectionView.bounds.size.width;
            height = self.footerReferenceSize.height;
        } else {

        }
    }
    newAttributes.frame = CGRectMake(x, y, width, height);
    return newAttributes;
}

- (CGSize)collectionViewContentSize {
//    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {//垂直滚动
//        return CGSizeMake(self.collectionView.bounds.size.width, self.ZCHAttributesArray.lastObject.frame.origin.y + self.ZCHAttributesArray.lastObject.frame.size.height + self.headerReferenceSize.height + self.footerReferenceSize.height + self.sectionInset.top + self.sectionInset.bottom);
//    }
//    else {//水平布局
//        return CGSizeMake(self.collectionView.bounds.size.width, self.ZCHItemAttributesArray.lastObject.frame.origin.y + self.ZCHItemAttributesArray.lastObject.frame.size.height + _sectionIntervalBottom + self.footerReferenceSize.height + self.footerReferenceSize.height + self.sectionInset.top + self.sectionInset.bottom);
    return CGSizeMake(self.collectionView.bounds.size.width, self.ZCHReusableFooterViewAttributesArray.lastObject.frame.origin.y + self.ZCHReusableFooterViewAttributesArray.lastObject.frame.size.height);
//    }
}

@end
