# CustonScalIVDemo
CustonScalIVDemo

自定义点击放大展示imageView。如，cell上的imageView点击从当前位置放大到全屏显示，再次点击，返回原来位置。

使用时，只需导入并创建即可。

如：
```
cell.iamge = [[CustonScaleImageView alloc] initWithFrame:CGRectMake(15, (_cellHeight - 60)/2, 60, 60) withImg:[UIImage imageNamed:@""]];
```

![展示图片](https://github.com/diankuanghuolong/CustonScalIVDemo/blob/master/CustonScalIVDemo/ShowImages/CustonScallIV.gif)
