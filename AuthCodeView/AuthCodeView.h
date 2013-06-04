/**
 * 绘制验证码，支持两种形式
 * 第一、给一个简单的字符串，我自己来画，主要用于客户端验证。eg:(DGCC)
 * 第二、给我一个连接，传给我一张图片，我来显示，用于服务端验证。eg:http://IP/.../.../codeImages.jsp
 **/
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ASIFormDataRequest.h"

typedef enum {
    AuthCodeViewTypeText,           // 字符串方式
    AuthCodeViewTypeURL             // URL方式
}AuthCodeViewType;

@class AuthCodeView;

@protocol AuthCodeViewDataSource <NSObject>

/**
 * 根据对应的方式获取字符串或者URL的代理方法。
 **/
- (NSString *)authCodeView:(AuthCodeView *)p_view withType:(AuthCodeViewType)p_type;

@end

@interface AuthCodeView : UIView {
    UIActivityIndicatorView *_activityView;     // 加载指示器
    UIImageView *_imgView;                      // 显示图片的载体
    AuthCodeViewType _type;                     // 实现方式
}

@property (nonatomic, assign) id<AuthCodeViewDataSource> dataSource;

/**
 * 根据实现方式初始化
 **/
- (id)initWithType:(AuthCodeViewType)p_type;

@end
