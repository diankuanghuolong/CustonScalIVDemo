//
//  CustonScaleImageView.h
//  Hai
//
//  Created by Ios_Developer on 2018/4/20.
//  Copyright © 2018年 com.Hai. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 自定义点击放大展示imageView。如，cell上的imageView点击从当前位置放大到全屏显示，再次点击，返回原来位置。
 使用时，只需导入并创建即可。
 如：
  cell.iamge = [[CustonScaleImageView alloc] initWithFrame:CGRectMake(15, (_cellHeight - 60)/2, 60, 60) withImg:[UIImage imageNamed:@""]];
 
 */
@interface CustonScaleImageView : UIImageView

-(instancetype)initWithFrame:(CGRect)frame withImg:(UIImage *)image;
@end
