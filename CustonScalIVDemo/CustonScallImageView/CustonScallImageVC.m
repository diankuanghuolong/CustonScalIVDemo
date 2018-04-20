//
//  CustonScallImageVC.m
//  CustonScalIVDemo
//
//  Created by Ios_Developer on 2018/4/20.
//  Copyright © 2018年 com.Hai. All rights reserved.
//

#import "CustonScallImageVC.h"
#import "CustonScaleImageView.h"
#import "UIViewExt.h"
#import "CustonScaleImageView.h"

/*
 定义了一些全局属性，包括颜色、屏幕宽高，iOS11的安全距离等
 */

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s & 0xFF))/255.0 alpha:1.0]
#define BG_COlOR UIColorFromHex(0xf2f2f3)       //背景颜色

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define SafeAreaTopHeight (SCREEN_HEIGHT == 812.0 ? 88 : 64)
#define SafeAreaBottomHeight (SCREEN_HEIGHT == 812.0 ? 34 : 0)

//iOS11中，controller.automaticallyAdjustsScrollViewInsets = NO;无效解决方法
#define AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = NO;}

#define ListPlist @"listPlist.plist"

//---------------------------------------我是分割线--------------------------------------

@interface CustonscallCell : UITableViewCell

@property (nonatomic ,strong)CustonScaleImageView *cellIV;
@end

@implementation CustonscallCell

@end



@interface CustonScallImageVC ()<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat _cellHeight;
}
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSArray *dataSource;
@end

@implementation CustonScallImageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BG_COlOR;
    self.title = @"二维码列表视图";
    
    //初始化数据
    _cellHeight = 80;
    
    //创建控件
    [self.view addSubview:self.tableView];
    AdjustsScrollViewInsetNever(self, _tableView);
    
    //请求数据
    [self downLoad];
}

#pragma mark ===== downLoad  =====
-(void)downLoad
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:ListPlist ofType:@""];
    
    NSArray *plistArr = [[NSArray alloc] init];
    plistArr = [NSArray arrayWithContentsOfFile:plistPath];
    _dataSource = plistArr;
    
    [_tableView reloadData];
}
#pragma mark ===== lazyLoad  =====
/*
 空数据视图，我太懒了，不写了。
 */
-(UITableView *)tableView
{
    if (!_tableView)
    {
        CGFloat h = self.tabBarController.tabBar.frame.size.height;
        /*
         self.tabBarController.tabBar.frame.size.height 这样的写法让我很烦躁，懒惰如我，我导入了一个适配的东西(UIViewExt.h)，下边就直接使用了哦。
         */
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaTopHeight - h) style:UITableViewStylePlain];
        _tableView.backgroundColor = BG_COlOR;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available (iOS 11,*)) {
            _tableView.estimatedRowHeight = 0;
        }
    }
    return _tableView;
}
#pragma mark -- table view delegate/datasource method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"custonscall_cell";
    CustonscallCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell)
    {
        cell = [[CustonscallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.cellIV = [[CustonScaleImageView alloc] initWithFrame:CGRectMake(15, (_cellHeight - 60)/2, 60, 60) withImg:[UIImage imageNamed:@""]];
        cell.cellIV.layer.borderWidth = 1;
        cell.cellIV.layer.borderColor = [UIColor greenColor].CGColor;
        cell.cellIV.layer.masksToBounds = YES;
        cell.cellIV.userInteractionEnabled = YES;
        [cell.contentView addSubview:cell.cellIV];
        
        UILabel *codeL = [[UILabel alloc] initWithFrame:CGRectMake(cell.cellIV.right + 5,(_cellHeight - 40)/2, SCREEN_WIDTH - cell.cellIV.right - 20, 40)];
        codeL.tag = 100;
        [cell.contentView addSubview:codeL];
    }
    //fuzhi
    UILabel *codeL = [cell.contentView viewWithTag:100];
    codeL.text = [[NSString alloc] initWithFormat:@"二维码:%@",_dataSource[indexPath.row][@"code"]];
    [self creatQRCode:codeL.text toCellIV:cell.cellIV];
    
    return cell;
}

#pragma mark  ===== tools  =====
-(void)creatQRCode:(NSString *)codeStr toCellIV:(CustonScaleImageView *)cellIV
{
    //生成CIFilter(滤镜)对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //恢复滤镜默认设置
    [filter setDefaults];
    
    //设置数据(通过滤镜对象的KVC)
    //存放的信息
    NSString *numStr = [codeStr substringFromIndex:4];
    NSString *info = numStr;
    //把信息转化为NSData
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    //滤镜对象kvc存值
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    
    //生成二维码
    CIImage *outImage = [filter outputImage];
    
    //imageView.image = [UIImage imageWithCIImage:outImage];//不处理图片模糊,故而调用下面的信息
    cellIV.image = [self createNonInterpolatedUIImageFormCIImage:outImage withSize:300];
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度以及高度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
@end
