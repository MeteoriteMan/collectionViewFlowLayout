//
//  CollectionViewCell.m
//  CHCollectionViewLayoutTest
//
//  Created by 张晨晖 on 2018/10/8.
//  Copyright © 2018 张晨晖. All rights reserved.
//

#import "CollectionViewCell.h"
#import <Masonry.h>

@interface CollectionViewCell ()

@property (nonatomic ,strong) UILabel *labelTitle;

@end

@implementation CollectionViewCell

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.labelTitle.text = titleStr;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.labelTitle = [[UILabel alloc] init];
    [self addSubview:self.labelTitle];
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.offset(0);
//        make.bottom.lessThanOrEqualTo(@0);
//        make.right.lessThanOrEqualTo(@0);
        make.edges.offset(0);
    }];
}

//- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
//    //以下代码是self-Sizing必须的
//    CGSize newSize = layoutAttributes.frame.size;
//    //    newSize.height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
////    newSize.height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize withHorizontalFittingPriority:UILayoutPriorityFittingSizeLevel verticalFittingPriority:UILayoutPriorityFittingSizeLevel].height;
//    newSize = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize withHorizontalFittingPriority:UILayoutPriorityFittingSizeLevel verticalFittingPriority:UILayoutPriorityFittingSizeLevel];
//    layoutAttributes.size = newSize;
//    return layoutAttributes;
//}

@end
