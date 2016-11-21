//
//  TestCell.m
//  STFollowLayout
//
//  Created by xiudou on 2016/11/21.
//  Copyright © 2016年 xiudo. All rights reserved.
//

#import "TestCell.h"
#import "UIImageView+WebCache.h"
@interface TestCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@end
@implementation TestCell

- (void)setModel:(TestModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"arrow"]];
}

- (void)awakeFromNib {
}

@end
