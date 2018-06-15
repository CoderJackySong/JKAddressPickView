# JKAddressPickView
#### 最近项目中有个类似京东所在地区选择器的功能，然后自己就写了一个类似的功能。
 
### 1.UI效果如下图:
![效果图](https://upload-images.jianshu.io/upload_images/3107189-7dd1f618c7c19b57.gif?imageMogr2/auto-orient/strip)

### 2.只要把下图红色标注的文件夹拖进自己的项目即可使用:
![效果图](https://upload-images.jianshu.io/upload_images/3107189-f32d02001506b552.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
### 3.代码使用:
```
__weak typeof(self) weakSelf = self;
    JKAddressPickView *addressPickView = [[JKAddressPickView alloc] initWithContentHeight:468.0 completion:^(NSString *addressString) {
        weakSelf.textField.text = addressString;
    }];
    [addressPickView show];

```
