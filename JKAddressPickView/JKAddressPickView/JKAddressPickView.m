//
//  JKAddressPickView.m
//  YjyxTeacher
//
//  Created by JackySong on 2018/6/11.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import "JKAddressPickView.h"
#import "UIView+Category.h"
#import "UIColor+Hex.h"
#import "JKAddressTableViewCell.h"

#define ExtraTag 1000
#define MaxLevel 3
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

typedef void (^CompletionBlock)(Place *province,Place *city,Place *district);

@implementation Place

@end


@interface JKAddressPickView()<UITableViewDataSource,UITableViewDelegate>{
    CGFloat defaultHeight;
    UIButton *selectedBtn;
}

@property(nonatomic,strong)UIView *addressView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIScrollView *titleScrollView;
@property(nonatomic,strong)UIButton *cover;
@property(nonatomic,strong)NSArray *listArray;
@property(nonatomic,strong)NSDictionary *localDataDic;
@property(nonatomic,strong)UIView *movingline;
@property(nonatomic,strong)NSMutableArray *titlePlaceArray;
@property (nonatomic,copy) CompletionBlock completionBlock;

@end


@implementation JKAddressPickView

#pragma  mark- lazyload
- (NSArray *)listArray{
    if (!_listArray) {
        _listArray = [[NSArray alloc] init];
    }
    return _listArray;
}

- (NSMutableArray *)titlePlaceArray{
    if (!_titlePlaceArray) {
        _titlePlaceArray = [[NSMutableArray alloc] init];
    }
    return _titlePlaceArray;
}

- (NSDictionary *)localDataDic{
    if (!_localDataDic) {
        _localDataDic = [[NSDictionary alloc] init];
    }
    return _localDataDic;
}

- (instancetype)initAddressPickViewWithCompletion:(void(^)(Place *province,Place *district ,Place *city))completion{
    if (self == [super init]) {
        [self initSubViews];
        _completionBlock = completion;
    }
    return self;
}

- (void)initSubViews{
    defaultHeight = 468 * SCREEN_HEIGHT/667.0;
    _cover = [UIButton buttonWithType:UIButtonTypeCustom];
    _cover.backgroundColor = [UIColor clearColor];
    _cover.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_cover addTarget:self action:@selector(tapBtnAndcancelBtnClick) forControlEvents:UIControlEventAllTouchEvents];
    [self addSubview:_cover];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [UIColor colorWithHexString:@"#333333" alpha:0.4];
    _addressView = [[UIView alloc] init];
    [self addSubview:_addressView];
    _addressView.frame = CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH, defaultHeight);
    _addressView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    [_addressView addSubview:titleLabel];
    titleLabel.text = @"配送至";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    titleLabel.centerX = SCREEN_WIDTH * 0.5;
    titleLabel.y = 15;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addressView addSubview:cancelBtn];
    cancelBtn.frame = CGRectMake(SCREEN_WIDTH - 35, 15, 20, 20);
    [cancelBtn addTarget:self action:@selector(tapBtnAndcancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"profile_exchange_close"] forState:UIControlStateNormal];
    [self setupScrollView];
    [self addTitleButtonWithIndex:0 selectedPlace:nil];
    [self setupContentTableView];
}

- (void)setupScrollView{
    _titleScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 35, SCREEN_WIDTH,40)];
    [_addressView addSubview:_titleScrollView];
    _titleScrollView.backgroundColor = [UIColor whiteColor];
    _titleScrollView.showsVerticalScrollIndicator = NO;
    _titleScrollView.showsHorizontalScrollIndicator = NO;
    _titleScrollView.pagingEnabled = YES;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _titleScrollView.height - 1.0, SCREEN_WIDTH, 0.5)];
    [_titleScrollView addSubview:line];
    line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];;
    _movingline = [[UIView alloc] init];
    [line addSubview:_movingline];
    _movingline.backgroundColor = [UIColor colorWithHexString:@"#f56626"] ;
    _movingline.height = 1.0;
    _movingline.centerY =  line.height * 0.5;
}

- (void)setupContentTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, defaultHeight - 75) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_addressView addSubview:_tableView];
}

//添加可以点击的title
- (void)addTitleButtonWithIndex:(NSInteger)index selectedPlace:(Place *)selectedPlace{
    for (UIView *subView in self.titleScrollView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subView;
            NSInteger tag = button.tag - ExtraTag;
            if (tag >= index) {
                [button removeFromSuperview];
                button = nil;
                if (self.titlePlaceArray.count > index) {
                    [self.titlePlaceArray removeObjectAtIndex:index];
                }
            }
        }
    }
    UIFont *titleFont = [UIFont systemFontOfSize:14];
    CGFloat  currentX = 15;
    if (selectedBtn) {
        selectedBtn.selected = NO;
        CGFloat preWidth = [self sizeOfString:selectedPlace.name font:titleFont].width;
        selectedBtn.width = preWidth;
        [selectedBtn setTitle:selectedPlace.name forState:UIControlStateNormal];
        currentX = CGRectGetMaxX(selectedBtn.frame) + 30;
        [self.titlePlaceArray insertObject:selectedPlace atIndex:selectedBtn.tag - ExtraTag];
    }
    if (index >= MaxLevel) {
        [self movinglineAnimationWithSelectedButton:selectedBtn];
        if(self.completionBlock){
            Place *provnice;
            Place *city;
            Place *district;
            if (self.titlePlaceArray.count >= 1) {
                provnice = self.titlePlaceArray[0];
            }
            if (self.titlePlaceArray.count >= 2) {
                city = self.titlePlaceArray[1];
            }
            if (self.titlePlaceArray.count >= 3) {
                district = self.titlePlaceArray[2];
            }
            self.completionBlock(provnice, city,district);
            [self dismiss];
        }
        return;
    }
    
    //新加titleButton
    NSString *currentTitle = @"请选择";
    CGFloat currntWidth = [self sizeOfString:currentTitle font:titleFont].width;
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.tag = ExtraTag + index;
    titleBtn.height = 25;
    titleBtn.width = currntWidth;
    titleBtn.x =  currentX;
    titleBtn.y = 14;
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    titleBtn.titleLabel.font = titleFont;
    [titleBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor colorWithHexString:@"#f56626"] forState:UIControlStateSelected];
    [titleBtn addTarget:self action:@selector(titleClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleScrollView addSubview:titleBtn];
    [titleBtn setTitle:currentTitle forState:UIControlStateNormal];
    titleBtn.selected = YES;
    selectedBtn = titleBtn;
    [self movinglineAnimationWithSelectedButton:titleBtn];
}

- (void)movinglineAnimationWithSelectedButton:(UIButton *)button{
    [UIView animateWithDuration:0.3 animations:^{
        self->_movingline.x = button.x;
        self->_movingline.width = button.width;
    } completion:^(BOOL finished) {
        CGFloat MaxX = CGRectGetMaxX(self->_movingline.frame) + 10;
        CGFloat height = 40;
        if (MaxX > SCREEN_WIDTH) {
            self.titleScrollView.contentSize = CGSizeMake(MaxX, height);
        }else{
            self.titleScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height);
        }
    }];
}

- (void)titleClicked:(UIButton *)button{
    if (selectedBtn != button) {
        selectedBtn.selected = NO;
        button.selected = YES;
        selectedBtn = button;
        [self movinglineAnimationWithSelectedButton:button];
        NSInteger index = button.tag - ExtraTag;
        switch (index) {
            case 0:{
                self.listArray = self.localDataDic[@"provinceList"];
                [self refreshData];
            }
                break;
            case 1:{
                Place *place = self.titlePlaceArray[index - 1];
                NSDictionary *provinceDic = self.localDataDic[@"provinceDict"];
                NSDictionary *cityDic = provinceDic[place.code];
                self.listArray = cityDic[@"cities"];
                [self refreshData];
            }
                break;
            case 2:{
                Place *place = self.titlePlaceArray[index - 1];
                NSDictionary *cityDict = self.localDataDic[@"cityDict"];
                NSDictionary *districtDic = cityDict[place.code];
                self.listArray = districtDic[@"districts"];
                [self refreshData];
            }
                break;
            default:
                break;
        }
    }
}

// 读取本地JSON文件
- (NSDictionary *)readLocalFile{
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.addressView.y = SCREEN_HEIGHT - self->defaultHeight;
        self.localDataDic = [self readLocalFile];
        self.listArray = self.localDataDic[@"provinceList"];
        [self refreshData];
    }];
}

- (void)refreshData{
    [self.tableView reloadData];
    if(self.listArray.count > 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        });
    }
}

- (void)tapBtnAndcancelBtnClick{
    [self dismiss];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.addressView.y = SCREEN_HEIGHT;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - tools
- (CGSize)sizeOfString:(NSString *)text  font:(UIFont *)font{
    CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        size = [text boundingRectWithSize:size
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:tdic
                                  context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
    }
    
    return size;
}


#pragma mark- UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    cell.textLabel.text = self.listArray[indexPath.row][1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = selectedBtn.tag - ExtraTag;
    NSInteger nextIndex = index + 1;
    NSString *title = self.listArray[indexPath.row][1];
    NSNumber *districtID = self.listArray[indexPath.row][0];
    Place *place = [[Place alloc] init];
    place.code = [districtID stringValue];
    place.name =title;
    switch (nextIndex) {
        case 1:{
            [self addTitleButtonWithIndex:nextIndex selectedPlace:place];
            NSDictionary *provinceDic = self.localDataDic[@"provinceDict"];
            NSDictionary *cityDic = provinceDic[[districtID stringValue]];
            self.listArray = cityDic[@"cities"];
            [self refreshData];
        }
            break;
        case 2:{
            [self addTitleButtonWithIndex:nextIndex selectedPlace:place];
            NSDictionary *provinceDic = self.localDataDic[@"cityDict"];
            NSDictionary *cityDic = provinceDic[[districtID stringValue]];
            self.listArray = cityDic[@"districts"];
            [self refreshData];
        }
            break;
        case 3:{
            [self addTitleButtonWithIndex:nextIndex selectedPlace:place];
        }
            break;
        default:
            return;
            break;
    }
}

@end
