//
//  CustonScaleImageView.m
//  Hai
//
//  Created by Ios_Developer on 2018/4/20.
//  Copyright © 2018年 com.Hai. All rights reserved.
//

#import "CustonScaleImageView.h"

@interface CustonScaleImageView()

@property (nonatomic, weak) UIImageView *imgView;//用于展示你点击后要放大的图片
@property (nonatomic, assign) CGRect lastFrame;//保存你点击图片原来的frame
@end
@implementation CustonScaleImageView

-(instancetype)initWithFrame:(CGRect)frame withImg:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.image = image;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickScale:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark =====  scale  =====
- (void)didClickScale:(UITapGestureRecognizer *)tapIV
{
    //添加遮盖
    UIView *coverView = [[UIView alloc] init];
    coverView.frame = [UIScreen mainScreen].bounds;
    coverView.backgroundColor = [UIColor clearColor];
    [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenCoverView:)]];
    [[UIApplication sharedApplication].keyWindow addSubview:coverView];
    
    //添加图片到遮盖上
    UIImageView *imgView = [UIImageView new];
    imgView.image = self.image;
    imgView.frame = [coverView convertRect:tapIV.view.frame fromView:self];
    self.lastFrame = imgView.frame;
    [coverView addSubview:imgView];
    _imgView = imgView;
    
    //放大
    [UIView animateWithDuration:0.35f animations:^{
        coverView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
        CGRect frame = imgView.frame;
        frame.size.width = coverView.frame.size.width;
        frame.size.height = coverView.frame.size.width * (imgView.image.size.height / imgView.image.size.width);
        frame.origin.x = 0;
        frame.origin.y = (coverView.frame.size.height - frame.size.height) * 0.5;
        imgView.frame = frame;
    }];
}

- (void)hidenCoverView:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.35f animations:^{
        tap.view.backgroundColor = [UIColor clearColor];
        _imgView.frame = self.lastFrame;
        
    }completion:^(BOOL finished) {
        
        [tap.view removeFromSuperview];
        _imgView.image = nil;
    }];
}
@end
