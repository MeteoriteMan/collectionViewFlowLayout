//
//  ViewController.m
//  CHCollectionViewLayoutTest
//
//  Created by 张晨晖 on 2018/10/8.
//  Copyright © 2018 张晨晖. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "ZCHCollectionViewFlowLayout.h"
#import "CollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource ,UICollectionViewDelegate>

@property (nonatomic ,strong) UICollectionView *collectionView;

@property (nonatomic ,strong) ZCHCollectionViewFlowLayout *layout;

@property (nonatomic ,strong) NSArray <NSString *> *titleArray;

@end

@implementation ViewController

static NSString *CollectionViewCellID = @"CollectionViewCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.layout = [[ZCHCollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.collectionView.prefetchingEnabled = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];

    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellID];


    UIButton *buttonAdd = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.view addSubview:buttonAdd];
    [buttonAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    [buttonAdd addTarget:self action:@selector(buttonAddClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellID forIndexPath:indexPath];
    cell.titleStr = self.titleArray[indexPath.row];
    return cell;
}

- (void)buttonAddClick:(UIButton *)sender {
    int num = arc4random_uniform(100);
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i = 0; i < num; i++) {
        NSMutableString *stringM = [NSMutableString string];
        for (int j = 0; j < arc4random_uniform(30) + 1; j++) {
            [stringM appendString:[NSString stringWithFormat:@"%ld",i]];
        }
        [arrayM addObject:stringM.copy];
    }
    self.titleArray = arrayM.copy;
//    [self.layout invalidateLayout];
    [self.collectionView reloadData];
//    [self.collectionView layoutIfNeeded];
}

@end
