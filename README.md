# JKAddressPickView

### 1.UI效果如下图:
![效果图1](https://upload-images.jianshu.io/upload_images/3107189-eb4e6efd071a8737.gif?imageMogr2/auto-orient/strip)

### 2.只要把下图红色标注的文件夹拖进自己的项目即可使用:
![效果图2](https://upload-images.jianshu.io/upload_images/3107189-b9789103a52b0044.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
### 3.代码使用:
```
     __weak typeof(self)weakSelf = self;
    JKAddressPickView *addressPickView = [[JKAddressPickView alloc] initAddressPickViewWithCompletion:^(Place *province,Place *city,Place *district) {
        weakSelf.textField.text = [NSString stringWithFormat:@"%@%@%@",province.name,city.name,district.name];
    }];
    [addressPickView show];

```
