#import "AppViewController.h"

#define CountForText 4

@interface AppViewController ()

@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
        // 加载验证码View
    AuthCodeView *codeViewText = [[AuthCodeView alloc] initWithType:AuthCodeViewTypeText];
    [codeViewText setFrame:CGRectMake(.0, .0, 64.0, 30.0)];
    [codeViewText setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 - 30)];
    codeViewText.dataSource = self;
    [self.view addSubview:codeViewText];
    [codeViewText release];
    
    AuthCodeView *codeViewURL = [[AuthCodeView alloc] initWithType:AuthCodeViewTypeURL];
    [codeViewURL setFrame:CGRectMake(.0, .0, 64.0, 30.0)];
    [codeViewURL setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 + 30)];
    codeViewURL.dataSource = self;
    [self.view addSubview:codeViewURL];
    [codeViewURL release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 * 实现代理方法，根据实现方式返回文本或者URL
 **/
- (NSString *)authCodeView:(AuthCodeView *)p_view withType:(AuthCodeViewType)p_type {
    if (p_type == AuthCodeViewTypeText) {
        char data[CountForText];
        for (int x = 0; x < CountForText; data[x++] = (char)('A' + (arc4random_uniform(26))));
        return [[NSString alloc] initWithBytes:data length:CountForText encoding:NSUTF8StringEncoding];
    } else {
        return @"http://114.80.86.70:27001/ebppManage/example/codeImages.jsp";
    }
}

@end
