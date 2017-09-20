//
//  UUAlertSheetView.m
//  WzhAlertSheet
//
//  Created by UUPT on 2017/9/15.
//  Copyright © 2017年 UUPT. All rights reserved.
//

#import "WZHAlertSheetView.h"
//字体
#define  UUActionSheetCancelButtonFont  [UIFont systemFontOfSize:15]
#define  UUActionSheetDestructiveButtonFont  [UIFont systemFontOfSize:15]
#define  UUActionSheetOtherButtonFont  [UIFont systemFontOfSize:15]
//大标题字体
#define  UUActionSheetTitleLabelFont  [UIFont systemFontOfSize:19]
//小标题字体
#define  UUActionSheetsubTitleLabelFont  [UIFont systemFontOfSize:14]

//颜色
#define  UUActionSheetButtonBackgroundColor [UIColor colorWithRed:251/255.0 green:251/255.0 blue:253/255.0 alpha:1]
#define  UUActionSheetBackgroundColor [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:0.5]

//大标题颜色
#define  UUActionSheetTitleLabelColor  [UIColor blackColor]
//小标题颜色-
#define  UUActionSheetSubTitleLabelColor  [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]

#define  UUActionSheetCancelButtonColor [UIColor blackColor]
//橘色按钮颜色
#define  UUActionSheetDestructiveButtonColor   [UIColor colorWithRed:255/255.0 green:139/255.0 blue:3/255.0 alpha:1]
//数组按钮颜色
#define  UUActionSheetOtherButtonColor  [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1]
//背景色
#define  UUActionSheetContentViewBackgroundColor [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:0.5]
//按钮点击高亮
#define  UUActionSheetButtonHighlightedColor [UIColor colorWithRed:253/255.0 green:160/255.0 blue:78/255.0 alpha:0.5]

//高度
#define  UUActionSheetCancelButtonHeight 50
#define  UUActionSheetDestructiveButtonHeight 50
#define  UUActionSheetOtherButtonHeight 50
//线的高度
#define  UUActionSheetLineHeight 0.5

//底部取消按钮距离上面按钮距离

#define  UUActionSheetTitleTopMargin 29

#define  UUActionSheetTopMargin 14

#define  UUActionSheetBottomMargin 10

#define  UUActionSheetLeftMargin 20


#define  UUActionSheetAnimationTime 0.25




#define  UUActionSheetScreenWidth [UIScreen mainScreen].bounds.size.width
#define  UUActionSheetScreenHeight [UIScreen mainScreen].bounds.size.height

@interface WZHAlertSheetView ()

@property (nonatomic,weak) UIScrollView *contentView;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subTitle;
@property (nonatomic,copy) NSString *orangeTitle;
@property(nonatomic,strong) NSArray *otherTitles;


@property (nonatomic,copy) UUActionSheetBlock  block;


@end


@implementation WZHAlertSheetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}

/**
 初始化配置
 */
- (void)initConfig{
    self.backgroundColor=UUActionSheetBackgroundColor;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(handleGesture:)];
    [self addGestureRecognizer:tap];
}

/**
 点击阴影

 @param tap 单机手势
 */
-(void)handleGesture:(UITapGestureRecognizer*)tap
{
    if ([tap locationInView:tap.view].y<self.frame.size.height -self.contentView.frame.size.height) {
        [self cancel];
    }
}

/**
 弹出底部AlertSheetView
 
 @param title 标题
 @param subtitle 子标题
 @param orangeTitle 橘色按钮
 @param otherTitles 普通按钮数组
 @param block 点击回调block
 */
+ (void)showWithTitle:(NSString*)title andSubTitle:(NSString *)subtitle  orangeTitle:(NSString*)orangeTitle  otherTitles:(NSArray*)otherTitles block:(UUActionSheetBlock)block
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    WZHAlertSheetView *sheet=[[WZHAlertSheetView alloc]init];
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    sheet.frame=window.bounds;
    sheet.title=title;
    sheet.subTitle = subtitle;
    sheet.orangeTitle=orangeTitle;
    sheet.otherTitles=otherTitles;
    sheet.block=block;
    [sheet show];
    [window addSubview:sheet];
}


/**
 对AlertSheetView进行布局
 */
-(void)show
{
    
    UIScrollView *contentView=[[UIScrollView alloc]init];
    self.contentView=contentView;
    //记录布局y坐标的位置
    CGFloat y=0;
    //点击按钮的对应tag值
    NSInteger tag=0;
    if (self.title || self.subTitle) {
        //标题
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.font = UUActionSheetTitleLabelFont;
        titleLable.textColor =UUActionSheetTitleLabelColor;
        titleLable.numberOfLines = 2;
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.text = self.title;
        
        //计算高度
        CGSize titleSize= [self.title boundingRectWithSize:CGSizeMake(UUActionSheetScreenWidth-2*UUActionSheetLeftMargin, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:titleLable.font}
                                              context:nil]
        .size;
        
        //子标题
        UILabel *subtitleLabel=[[UILabel alloc]init];
        subtitleLabel.font=UUActionSheetsubTitleLabelFont;
        subtitleLabel.textColor=UUActionSheetSubTitleLabelColor;
        subtitleLabel.numberOfLines=0;
        subtitleLabel.textAlignment=NSTextAlignmentCenter;
        subtitleLabel.text=self.subTitle;
        subtitleLabel.tag=tag;
        //计算高度
        CGSize subTitlesize= [self.subTitle boundingRectWithSize:CGSizeMake(UUActionSheetScreenWidth-2*UUActionSheetLeftMargin, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:subtitleLabel.font}
                                              context:nil]
        .size;
        
        //标题跟子标题布局
        titleLable.frame = CGRectMake(UUActionSheetLeftMargin, UUActionSheetTitleTopMargin,UUActionSheetScreenWidth-2*UUActionSheetLeftMargin ,titleSize.height );
        subtitleLabel.frame=CGRectMake(UUActionSheetLeftMargin,UUActionSheetTitleTopMargin+titleSize.height+UUActionSheetTopMargin,UUActionSheetScreenWidth-2*UUActionSheetLeftMargin ,subTitlesize.height );
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=UUActionSheetButtonBackgroundColor;
        view.frame=CGRectMake(0, 0, UUActionSheetScreenWidth,titleSize.height+subTitlesize.height+UUActionSheetTopMargin + 2* UUActionSheetTitleTopMargin);
        view.alpha = 0.8;
        [contentView addSubview:view];
        [view addSubview:titleLable];
        [view addSubview:subtitleLabel];
        y=titleSize.height+subTitlesize.height+UUActionSheetTopMargin+ 2 * UUActionSheetTitleTopMargin + UUActionSheetLineHeight;
        
    }
    
    //数组按钮的布局及初始化配置
    for (int i=0; i<self.otherTitles.count; i++) {
        UIButton *button=[self createButtonWithTitle:self.otherTitles[i] color:UUActionSheetOtherButtonColor font:UUActionSheetOtherButtonFont height:UUActionSheetOtherButtonHeight y:y+(UUActionSheetOtherButtonHeight+UUActionSheetLineHeight)*i];
        [contentView addSubview:button];
        if (i==self.otherTitles.count-1) {
            y=y+(UUActionSheetOtherButtonHeight+UUActionSheetLineHeight)*i+UUActionSheetOtherButtonHeight;
        }
        button.tag=tag;
        tag++;
    }
    
    //创建橘色按钮
    if (self.orangeTitle) {
        UIButton *button=[self createButtonWithTitle:self.orangeTitle color:UUActionSheetDestructiveButtonColor font:UUActionSheetDestructiveButtonFont height:UUActionSheetDestructiveButtonHeight y:y+UUActionSheetLineHeight+UUActionSheetBottomMargin];
        button.tag=tag;
        [contentView addSubview:button];
        y+=(UUActionSheetDestructiveButtonHeight+2*UUActionSheetBottomMargin);
        tag++;
        
    }else{
        y+=UUActionSheetBottomMargin;
    }
    
    //取消
    UIButton *cancel=[self  createButtonWithTitle:@"取消" color:UUActionSheetCancelButtonColor font:UUActionSheetCancelButtonFont height:UUActionSheetCancelButtonHeight y:y];
    cancel.tag=tag;
    [contentView addSubview:cancel];
    
    //设置contentView
    contentView.backgroundColor=UUActionSheetContentViewBackgroundColor;
    
    
    CGFloat maxY= CGRectGetMaxY(contentView.subviews.lastObject.frame);
    //如果超出当前屏幕，设置滚动效果
    if (maxY < UUActionSheetScreenHeight) {
        
        contentView.frame=CGRectMake(0, self.frame.size.height-maxY, UUActionSheetScreenWidth, maxY) ;
        [self addSubview:contentView];
    }else{
    
        contentView.frame = CGRectMake(0, 0, UUActionSheetScreenWidth, UUActionSheetScreenHeight);
        [self addSubview:contentView];
        self.contentView.contentSize = CGSizeMake(UUActionSheetScreenWidth, maxY);
        self.contentView.scrollEnabled = YES;
        self.contentView.scrollsToTop = YES;
    }
    
    
    //动画
    CGRect frame= self.contentView.frame;
    CGRect newframe= frame;
    self.alpha=0.1;
    newframe.origin.y=self.frame.size.height;
    contentView.frame=newframe;
    [UIView animateWithDuration:UUActionSheetAnimationTime animations:^{
        self.contentView.frame=frame;
        self.alpha=1;
        
    }completion:^(BOOL finished) {
        
    }];
    
}



/**
 同意创建按钮方法

 @param title 按钮标题
 @param color 标题颜色
 @param font 标题字体
 @param height 按钮高度
 @param y Y坐标
 @return 返回创建按钮
 */
-(UIButton*)createButtonWithTitle:(NSString*)title  color:(UIColor*)color font:(UIFont*)font height:(CGFloat)height y:(CGFloat)y
{
    
    UIButton *button=[[UIButton alloc]init];
    button.backgroundColor=UUActionSheetButtonBackgroundColor;
    [button setBackgroundImage:[self imageWithColor:UUActionSheetButtonHighlightedColor] forState:UIControlStateHighlighted];
    button.titleLabel.font=font;
    button.titleLabel.textAlignment=NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.frame=CGRectMake(0, y, UUActionSheetScreenWidth, height);
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    button.alpha = 0.8;
    return button;
}


/**
 将颜色转化为按钮高亮背景图

 @param color 高亮颜色
 @return 返回高亮背景图
 */
-(UIImage*)imageWithColor:(UIColor*)color
{
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, CGRectMake(0, 0, 1, 1));
    [color set];
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(void)click:(UIButton*)button
{
    
    if (self.block) {
        self.block((int)button.tag);
    }
    [self cancel];
}
#pragma mark - 取消
-(void)cancel
{
    
    CGRect frame= self.contentView.frame;
    frame.origin.y+=frame.size.height;
    [UIView animateWithDuration:UUActionSheetAnimationTime animations:^{
        self.contentView.frame=frame;
        self.alpha=0.1;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}




@end
