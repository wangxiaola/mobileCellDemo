//
//  ZKCollectionViewCell.m
//  mobileCellDemo
//
//  Created by 王小腊 on 2017/4/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKCollectionViewCell.h"

@implementation ZKCollectionViewCell
{
    UIImageView *_backImageView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setUp
{
    self.contentView.backgroundColor = [UIColor clearColor];
    _backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_backImageView];

}

- (void)setBackImageName:(NSString *)imageName;
{
    [_backImageView setImage:[UIImage imageNamed:imageName]];
}
@end
