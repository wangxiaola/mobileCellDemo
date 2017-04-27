//
//  ViewController.m
//  mobileCellDemo
//
//  Created by 王小腊 on 2017/4/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//

/***  当前屏幕宽度 */
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
/***  当前屏幕高度 */
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "ZKCollectionViewCell.h"
#import "ZKTool.h"

static NSString *const ZKCollectionViewCellID = @"ZKCollectionViewCellID";
NSString *const cellOrder_key = @"cellOrder_key";

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *dataArray;//数据
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) ZKCollectionViewCell *pressCell;

@end

@implementation ViewController
#pragma mark ----懒加载区域---
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 10;
        _flowLayout.minimumInteritemSpacing = 10;
        CGFloat width = (SCREEN_WIDTH - 40.1)/3;
        _flowLayout.itemSize = CGSizeMake(width, width );

        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_flowLayout];
        _collectionView.contentInset = UIEdgeInsetsMake(20.0f,10.0f,10.0f,10.0f);
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithRed:0.8568 green:0.8568 blue:0.8568 alpha:1.0];
        _collectionView.delegate = self;
        [_collectionView registerClass:[ZKCollectionViewCell class] forCellWithReuseIdentifier:ZKCollectionViewCellID];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark ----viewDidLoad---
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUp];
    [self setDada];
}

#pragma mark  -- 视图 && 数据准备 --
- (void)setUp
{
    [self.view addSubview:self.collectionView];
    
#ifdef __IPHONE_9_0
    
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
    [self.collectionView addGestureRecognizer:_longPress];

#endif
}
- (void)setDada
{
    [self.dataArray removeAllObjects];
    NSArray *data = [ZKTool getUserDataForKey:@"cellOrder_key"];
    if (data.count == 0)
    {
        [self.dataArray addObjectsFromArray:@[@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29"]];
    }
    else
    {
        [self.dataArray addObjectsFromArray:data];
    }
    [self.collectionView reloadData];
    
}

#pragma mark UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZKCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZKCollectionViewCellID forIndexPath:indexPath];
    
    if (self.dataArray.count >0)
    {
        [cell setBackImageName:[self.dataArray objectAtIndex:indexPath.row]];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    /***2中排序方式，第一种只是交换2个cell位置，第二种是将前面的cell都往后移动一格，再将cell插入指定位置***/
   // first
//    [self.dataArray exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
    
    // second
    id objc = [self.dataArray objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [self.dataArray removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [self.dataArray insertObject:objc atIndex:destinationIndexPath.item];
 
    /**保存数据顺序**/
    [ZKTool cacheUserValue:self.dataArray.copy key:cellOrder_key];
    [self.collectionView reloadData];
}
#pragma mark ---- UILongPressGestureRecognizer ---
- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress
{
    switch (self.longPress.state) {
        case UIGestureRecognizerStateBegan: {
            {
                NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:self.collectionView]];
               //判断手势落点位置是否在路径上
                if (selectIndexPath == nil) { break; }
                
                // 找到当前的cell
                self.pressCell = (ZKCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:selectIndexPath];
                [self starLongPress:self.pressCell];
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:_longPress.view]];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self.collectionView endInteractiveMovement];
            [self endAnimation];
            break;
        }
        default: [self.collectionView cancelInteractiveMovement];
            [self endAnimation];
            break;
    }
}
#pragma mark  ---- 抖动动画 ----
//开始抖动
- (void)starLongPress:(ZKCollectionViewCell *)cell{
    
    CABasicAnimation *animation = (CABasicAnimation *)[cell.layer animationForKey:@"rotation"];
    
    if (animation == nil)
    {
        [self shakeImage:cell];
    }
    else
    {
        [self resume:cell];
    }
}

- (void)shakeImage:(ZKCollectionViewCell *)cell {
    
    //创建动画对象,绕Z轴旋转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置属性，周期时长
    [animation setDuration:0.1];
    //抖动角度
    animation.fromValue = @(-M_1_PI/2);
    animation.toValue = @(M_1_PI/2);
    //重复次数，无限大
    animation.repeatCount = HUGE_VAL;
    //恢复原样
    animation.autoreverses = YES;
    //锚点设置为图片中心，绕中心抖动
    cell.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [cell.layer addAnimation:animation forKey:@"rotation"];
    
}
- (void)resume:(ZKCollectionViewCell *)cell {
    cell.layer.speed = 1.0;
}
// 结束动画
- (void)endAnimation
{
    if (self.pressCell)
    {
        [self.pressCell.layer removeAllAnimations];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
