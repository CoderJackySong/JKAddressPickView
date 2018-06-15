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

static NSString *const CellID = @"CellID";
typedef void (^CompletionBlock)(NSString *addressString);


@interface Place:NSObject

@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *name;

@end

@implementation Place

@end


@interface JKAddressPickView()<UITableViewDataSource,UITableViewDelegate>{
    
    UIButton *selectedBtn;
    NSInteger cellSelectedIndex;
}

@property(nonatomic,strong)UIView *addressView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIScrollView *titleScrollView;
@property(nonatomic,strong)UIButton *cover;
@property(nonatomic,strong)NSArray *listArray;
@property(nonatomic,strong)NSDictionary *localDataDic;
@property(nonatomic,strong)UIView *movingline;
@property(nonatomic,strong)NSMutableArray *titlePlaceArray;
@property(nonatomic,assign)CGFloat contentHeight;
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

- (instancetype)initWithContentHeight:(CGFloat)height completion:(void(^)(NSString *addressString))completion{
    if (self == [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithHexString:@"#333333" alpha:0.4];
        _contentHeight = height;
        cellSelectedIndex = -1;
        _completionBlock = completion;
        [self setupCover];
        [self setupContentSubViews];
    }
    return self;
}

- (void)setupCover{
    _cover = [UIButton buttonWithType:UIButtonTypeCustom];
    _cover.backgroundColor = [UIColor clearColor];
    _cover.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_cover addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventAllTouchEvents];
    [self addSubview:_cover];
}

- (void)setupContentSubViews{
    _addressView = [[UIView alloc] init];
    [self addSubview:_addressView];
    _addressView.frame = CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH, _contentHeight);
    _addressView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    [_addressView addSubview:titleLabel];
    titleLabel.text = @"配送至";
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    titleLabel.centerX = SCREEN_WIDTH * 0.5;
    titleLabel.y = 15;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addressView addSubview:cancelBtn];
    cancelBtn.frame = CGRectMake(SCREEN_WIDTH - 35, 15, 20, 20);
    [cancelBtn addTarget:self action:@selector(tapBtnAndcancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self setupScrollView];
    [self addTitleButtonWithIndex:0 selectedPlace:nil];
    [self setupTableView];
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
    line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    _movingline = [[UIView alloc] init];
    [line addSubview:_movingline];
    _movingline.backgroundColor = [UIColor colorWithHexString:@"#f56626"] ;
    _movingline.height = 1.0;
    _movingline.centerY =  line.height * 0.5;
}

- (void)setupTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, _contentHeight - 75) style:UITableViewStylePlain];
    [_addressView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKAddressTableViewCell class]) bundle:nil] forCellReuseIdentifier:CellID];
}

//添加titleButton
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
    UIFont *titleFont = [UIFont boldSystemFontOfSize:14];
    CGFloat  currentX = 30;
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
            NSMutableString * mStr = [[NSMutableString alloc] init];
            for (Place *place in self.titlePlaceArray) {
                [mStr appendString:place.name];
            }
            self.completionBlock(mStr);
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
        self.movingline.x = button.x;
        self.movingline.width = button.width;
    } completion:^(BOOL finished) {
        CGFloat MaxX = CGRectGetMaxX(self.movingline.frame) + 10;
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
                NSDictionary *cityDic = provinceDic[place.ID];
                self.listArray = cityDic[@"cities"];
                [self refreshData];
            }
                break;
            case 2:{
                Place *place = self.titlePlaceArray[index - 1];
                NSDictionary *provinceDic = self.localDataDic[@"cityDict"];
                NSDictionary *cityDic = provinceDic[place.ID];
                self.listArray = cityDic[@"districts"];
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
        self.addressView.y = SCREEN_HEIGHT - self.contentHeight;
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
    JKAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    cell.name = self.listArray[indexPath.row][1];
    cell.cellSelected = NO;
    NSInteger index = selectedBtn.tag - ExtraTag;
    if (self.titlePlaceArray.count > index) {
        Place *place = self.titlePlaceArray[index];
        if ([place.name isEqualToString:cell.name]) {
            cell.cellSelected = YES;
            cellSelectedIndex = indexPath.row;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self selectedCellIndexPath:indexPath]; //先选中再刷新数据
    [self addTitleButtonAndReloadData:indexPath];
    cellSelectedIndex = -1; //刷新后cellSelectedIndex设为-1
}

- (void)selectedCellIndexPath:(NSIndexPath *)indexPath{
    JKAddressTableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cellSelectedIndex != indexPath.row ) {
        JKAddressTableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellSelectedIndex inSection:0]];
        selectedCell.cellSelected = NO;
        currentCell.cellSelected = YES;
        cellSelectedIndex = indexPath.row;
    }
}

- (void)addTitleButtonAndReloadData:(NSIndexPath *)indexPath{
    NSInteger index = selectedBtn.tag - ExtraTag;
    NSInteger nextIndex = index + 1;
    NSString *title = self.listArray[indexPath.row][1];
    NSNumber *districtID = self.listArray[indexPath.row][0];
    Place *place = [[Place alloc] init];
    place.ID = [districtID stringValue];
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
