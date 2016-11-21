//
//  ViewController.m
//  STFollowLayout
//
//  Created by xiudou on 2016/11/21.
//  Copyright © 2016年 xiudo. All rights reserved.
//

#import "ViewController.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "TestModel.h"
#import "STFollowLayout.h"
#import "TestCell.h"

static  NSString *cellIdentifier = @"cellIdentifier";

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,STFollowLayoutDelegate>
@property (nonatomic,strong) NSMutableArray *modelArray;
/** <#name#> */
@property (nonatomic,weak) UICollectionView *collectionView ;
@end

@implementation ViewController
- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//        NSArray *arr = [TestModel mj_objectArrayWithFilename:@"1.plist"];
//        [self.modelArray addObjectsFromArray:arr];
    
    
    STFollowLayout *layout = [[STFollowLayout alloc] init];
    layout.delegate = self;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"TestCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    
    [collectionView registerNib:[UINib nibWithNibName:@"BeautifulGirlCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collectionView];
    [collectionView reloadData];
    self.collectionView = collectionView;

    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];

    collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    [collectionView.mj_header beginRefreshing];
}

- (void)refreshAction{
    [self.modelArray removeAllObjects];
    NSArray *arr = [TestModel mj_objectArrayWithFilename:@"1.plist"];
    [self.modelArray addObjectsFromArray:arr];
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.collectionView.mj_header endRefreshing];
        
    });
}

- (void)loadMore{
    NSArray *arr = [TestModel mj_objectArrayWithFilename:@"1.plist"];
    [self.modelArray addObjectsFromArray:arr];
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.collectionView.mj_footer endRefreshing];
        
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.modelArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    TestModel *model = self.modelArray[indexPath.item];
    cell.model = model;
    return cell;
}

- (CGFloat)stLayout:(STFollowLayout *)stLayout heightForRowAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    TestModel *model = self.modelArray[indexPath.item];
    return model.h * itemWidth / model.w;
}
@end
