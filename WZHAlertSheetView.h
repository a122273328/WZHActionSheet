//
//  UUAlertSheetView.h
//  WzhAlertSheet
//
//  Created by UUPT on 2017/9/15.
//  Copyright © 2017年 UUPT. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef  void(^UUActionSheetBlock)(int index);

@interface WZHAlertSheetView : UIView


/**
 弹出底部AlertSheetView   如果对应的标题为nil则不显示对应内容

 @param title 标题
 @param subtitle 子标题
 @param orangeTitle 橘色按钮
 @param otherTitles 普通按钮数组
 @param block 点击回调block
 */
+ (void)showWithTitle:(NSString*)title andSubTitle:(NSString *)subtitle  orangeTitle:(NSString*)orangeTitle  otherTitles:(NSArray*)otherTitles block:(UUActionSheetBlock)block;



@end
