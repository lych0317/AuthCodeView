#import "AuthCodeView.h"

#define CountForLine 6
#define SizeForTextFont 20.0

@implementation AuthCodeView

@synthesize dataSource = _dataSource;

- (id)initWithType:(AuthCodeViewType)p_type {
    self = [super init];
    if (self) {
        _type = p_type;
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
    }
    return self;
}
////
/**
 * 亲写dataSource的setter方法，同时根据实现方式设置背景颜色或者图片View
 **/
- (void)setDataSource:(id<AuthCodeViewDataSource>)dataSource {
    _dataSource = dataSource;
    if ([_dataSource respondsToSelector:@selector(authCodeView:withType:)]) {
        if (_type == AuthCodeViewTypeText) {
            [self setBackgroundColor:[UIColor orangeColor]];
        } else {
            _imgView = [[UIImageView alloc] init];
            [_imgView setFrame:self.bounds];
            [_imgView setBackgroundColor:[UIColor grayColor]];
            [self addSubview:_imgView];
            [_imgView release];
            _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            _activityView.center = _imgView.center;
            [_imgView addSubview:_activityView];
            [_activityView release];
            [self _configureImageView:[_dataSource authCodeView:self withType:AuthCodeViewTypeURL]];
        }
    }
}

/**
 * 亲写drawRect:方法，绘制文字和干扰线
 **/
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if ([_dataSource respondsToSelector:@selector(authCodeView:withType:)]) {
            // 背景色
        float red = arc4random() % 100 / 100.0;
        float green = arc4random() % 100 / 100.0;
        float blue = arc4random() % 100 / 100.0;
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        [self setBackgroundColor:color];
            // 文字
        NSString *text = [_dataSource authCodeView:self withType:AuthCodeViewTypeText];
        CGSize cSize = [@"S" sizeWithFont:[UIFont systemFontOfSize:SizeForTextFont]];
        int width = rect.size.width / text.length - cSize.width;
        int height = rect.size.height - cSize.height;
        CGPoint point;
        float pX, pY;
        for (int i = 0, count = text.length; i < count; i++) {
            pX = arc4random() % width + rect.size.width / text.length * i;
            pY = arc4random() % height;
            point = CGPointMake(pX, pY);
            unichar c = [text characterAtIndex:i];
            NSString *textC = [NSString stringWithFormat:@"%C", c];
            [textC drawAtPoint:point withFont:[UIFont systemFontOfSize:SizeForTextFont]];
        }
            // 干扰线
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.0);
        for(int cout = 0; cout < CountForLine; cout++) {
            red = arc4random() % 100 / 100.0;
            green = arc4random() % 100 / 100.0;
            blue = arc4random() % 100 / 100.0;
            color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
            CGContextSetStrokeColorWithColor(context, [color CGColor]);
            pX = arc4random() % (int)rect.size.width;
            pY = arc4random() % (int)rect.size.height;
            CGContextMoveToPoint(context, pX, pY);
            pX = arc4random() % (int)rect.size.width;
            pY = arc4random() % (int)rect.size.height;
            CGContextAddLineToPoint(context, pX, pY);
            CGContextStrokePath(context);
        }
    }
}

/**
 * 亲写touchesBegan:withEvent:方法，实现点击重新加载验证码
 **/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_type == AuthCodeViewTypeText) {
        [self setNeedsDisplay];
    } else {
        [self _configureImageView:[_dataSource authCodeView:self withType:AuthCodeViewTypeURL]];
    }
}

/**
 * 根据RUL请求图片Data，转化为图片加到View上
 **/
- (void)_configureImageView:(NSString *)p_url {
    [_activityView startAnimating];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^(void) {
        ASIFormDataRequest *formDataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:p_url]];
        [formDataRequest startSynchronous];
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            [_activityView stopAnimating];
            UIImage *img = [[UIImage alloc] initWithData:[formDataRequest responseData]];
            [_imgView setImage:img];
            [img release];
        });
    });
}

@end
