//
//  Helper.m
//
//  Created by mac on 2019/7/10.
//  Copyright © 2019年 JackMac. All rights reserved.
//
// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define ZhuTiColor RGB(255, 255, 255) //35 107 184 RGB(52,108,178)
#define hui1Color [UIColor colorWithWhite:0.902 alpha:1.000]// 1灰
#define hui5Color [UIColor colorWithWhite:0.502 alpha:1.000]// 5灰

#import "Helper.h"

@implementation Helper


+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

/*  去html标签  */
+(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}



+ (BOOL)stringBool:(NSString *)string subStr:(NSString *)substr {

    if([string rangeOfString:substr].location != NSNotFound)
    {
        return YES;
    }  else  {
        return NO;
    }
}


+ (NSAttributedString*)attributedString:(NSString *)str imageName:(NSString *)imageName imageFram:(CGRect)imageFram isFront:(BOOL)isFront
{
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    [attri addAttribute:NSForegroundColorAttributeName value:RGB(255, 0, 72) range:NSMakeRange(0,str.length)];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:imageName];
    
    if (imageFram.size.width > 0)
    {
       attch.bounds = imageFram;
    }else{
        attch.bounds = CGRectMake(0, -1, 12, 12);
    }
    
    //创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    //将图片放在最后一位
    if (isFront)
    {
        //将图片放在第一位
        [attri insertAttributedString:string atIndex:0];
    }
    else
    {
        [attri appendAttributedString:string];
    }
    //用label的attributedText属性来使用富文本
    return attri;
}

+ (NSAttributedString*)grayAttributedString:(NSString *)str imageName:(NSString *)imageName imageFram:(CGRect)imageFram isFront:(BOOL)isFront
{
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    [attri addAttribute:NSForegroundColorAttributeName value:RGB(153, 153, 153) range:NSMakeRange(0,str.length)];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:imageName];
    
    if (imageFram.size.width > 0)
    {
        attch.bounds = imageFram;
    }else{
        attch.bounds = CGRectMake(0, -1, 12, 12);
    }
    
    //创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    //将图片放在最后一位
    if (isFront)
    {
        //将图片放在第一位
        [attri insertAttributedString:string atIndex:0];
    }
    else
    {
        [attri appendAttributedString:string];
    }
    
    NSUInteger length = [str length];
    
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, length)];
    [attri addAttribute:NSBaselineOffsetAttributeName value:@0 range:NSMakeRange(0, length)];
    
    //用label的attributedText属性来使用富文本
    return attri;
}

// 文库name富文本
+ (NSAttributedString*)wenku_attributedString:(NSString *)str imageName:(NSString *)imageName imageFram:(CGRect)imageFram isFront:(BOOL)isFront
{
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    [attri addAttribute:NSForegroundColorAttributeName value:RGB(51, 51, 51) range:NSMakeRange(0,str.length)];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,str.length)];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:imageName];
    
    if (imageFram.size.width > 0){
        attch.bounds = imageFram;
    }else{
        attch.bounds = CGRectMake(0, -1, 12, 12);
    }
    //创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    //将图片放在最后一位
    if (isFront){
        //将图片放在第一位
        [attri insertAttributedString:string atIndex:0];
    }else{
        [attri appendAttributedString:string];
    }
    //用label的attributedText属性来使用富文本
    return attri;
}

+ (NSAttributedString*)wenku_attributedString:(NSString *)str imageFirstName:(NSString *)imageFirstName imageFirstFram:(CGRect)imageFirstFram imageSecondName:(NSString *)imageSecondName imageSecondFram:(CGRect)imageSecondFram isFront:(BOOL)isFront
{
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    [attri addAttribute:NSForegroundColorAttributeName value:RGB(51, 51, 51) range:NSMakeRange(0,str.length)];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,str.length)];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *firstAttch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    firstAttch.image = [UIImage imageNamed:imageFirstName];
    
    if (imageFirstFram.size.width > 0)
    {
        firstAttch.bounds = imageFirstFram;
    }else{
        firstAttch.bounds = CGRectMake(0, -1, 12, 12);
    }
    
    NSTextAttachment *secondAttch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    secondAttch.image = [UIImage imageNamed:imageSecondName];
    
    if (imageSecondFram.size.width > 0)
    {
        secondAttch.bounds = imageSecondFram;
    }else{
        secondAttch.bounds = CGRectMake(0, -1, 12, 12);
    }
    //创建带有图片的富文本
    NSMutableAttributedString *firstString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:firstAttch]];
    NSMutableAttributedString *secondString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:secondAttch]];
    
    [firstString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    //将图片放在最后一位
    if (isFront)
    {
        //将图片放在第一位
        [attri insertAttributedString:firstString atIndex:0];
        [attri insertAttributedString:secondString atIndex:2];
    }
    else
    {
        [attri appendAttributedString:firstString];
        [attri appendAttributedString:secondString];
    }
    //用label的attributedText属性来使用富文本
    return attri;
}

+ (NSAttributedString*)attributedString:(NSString *)str imageName:(NSString *)imageName secondStr:(NSString *)secondStr secondStrColor:(UIColor *)secondStrColor imageFram:(CGRect)imageFram {
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    
    
    [attri addAttribute:NSForegroundColorAttributeName value:hui5Color range:NSMakeRange(0,str.length)];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:imageName];
    
    if (imageFram.size.width > 0) {
        attch.bounds = imageFram;
    }else{
        attch.bounds = CGRectMake(0, -1, 12, 12);
    }
    
    //创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    
    //将图片放在最后一位
    [attri appendAttributedString:string];
    //将图片放在第一位
//    [attri insertAttributedString:string atIndex:0];
    //用label的attributedText属性来使用富文本

    NSMutableAttributedString *attrSe = [[NSMutableAttributedString alloc] initWithString:secondStr];
    [attrSe addAttribute:NSForegroundColorAttributeName value:secondStrColor range:NSMakeRange(0,secondStr.length)];
    
    // 第二个文本 放在最后一位
    [attri  appendAttributedString:attrSe];
    return attri;
    
}


+(NSString*) removeLastOneChar:(NSString*)origin
{
    NSString* cutted;
    if([origin length] > 0){
        cutted = [origin substringToIndex:([origin length]-1)];// 去掉最后一个","
    }else{
        cutted = origin;
    }
    return cutted;
}


//获取Window当前显示的ViewController
+ (UIViewController*)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}



//编码图片
+ (NSString *)htmlForJPGImage:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    NSString *imageSource = [NSString stringWithFormat:@"data:image/jpg;base64,%@",[imageData base64EncodedStringWithOptions:0]];
    NSString *stringImage =  [NSString stringWithFormat:@"<img src = \"%@\" />", imageSource];
    
    //构造内容
    NSString *contentImg = [NSString stringWithFormat:@"%@", stringImage];
    NSString *content =[NSString stringWithFormat:
                        @"<html>"
                        "<style type=\"text/css\">"
                        "<!--"
                        "body{font-size:40pt;line-height:60pt;}"
                        "-->"
                        "</style>"
                        "<body>"
                        "%@"
                        "</body>"
                        "</html>"
                        , contentImg];
    return content;
    
}


+ (void)collectionViewRegistCellFrom:(UICollectionView *)collectionView  ident:(NSString *)ident isNib:(BOOL)isNib
{
    if (isNib)
    {
        [collectionView registerNib:[UINib nibWithNibName:ident bundle:nil] forCellWithReuseIdentifier:ident];
    }
    else
    {
        [collectionView registerClass: NSClassFromString(ident) forCellWithReuseIdentifier:ident];
    }
}


/**
 view
 size
 后面的4个角 BOOL 1 是设置该角为圆角 0 不改变
 */
+ (void)drawRoundView:(UIView *)view size:(CGSize)size left:(BOOL)left right:(BOOL)right bottomLeft:(BOOL)bottomLeft bottomRight:(BOOL)bottomRight {
    
    UIRectCorner Left = 0;
    
    UIRectCorner Right = 0;
    
    UIRectCorner BottomLeft = 0;
    
    UIRectCorner BottomRight = 0;
    
    if (left) {
        
        Left = UIRectCornerTopLeft;
        
    }
    
    if (right) {
        
        Right = UIRectCornerTopRight;;
        
    }
    
    if (bottomLeft) {
        
        BottomLeft = UIRectCornerBottomLeft;
        
    }
    
    if (bottomRight) {
        
        BottomRight = UIRectCornerBottomRight;
        
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:Left|Right|BottomLeft|BottomRight cornerRadii:size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.frame = view.bounds;
    
    maskLayer.path = maskPath.CGPath;
    
    view.layer.mask = maskLayer;
    
}


+ (void) httpByUrl:(NSString *)url
              send:(NSString *)send
           success:(void (^)(id responseObject))success
           failure:(void(^)(NSError *error))failure
{
    // 1、创建URL
    NSURL *urls = [NSURL URLWithString:url];
    // 2、创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urls];
    
    if (send.length > 0)
    {
        [request setHTTPMethod:@"POST"];
        //  3、设置body
        NSData *bodyData = [send dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:bodyData];
        
    }
    else
    {
        [request setHTTPMethod:@"GET"];
    }
    
    // 4、创建会话
    NSURLSession *session = [NSURLSession sharedSession];
    // 5、创建数据请求任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data,NSURLResponse * _Nullable response,NSError * _Nullable error) {
        
        if (error)
        {
            failure(error);
            NSLog(@"=错误==%@",error);
        }
        else
        {
            NSString * newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSError *err;
            NSData *jsonData = [newStr dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            success(dic);
        }
        
    }];
    // 6、启动任务
    [task resume];
    
}


+(NSString *)timeFromStr:(NSString *)str{
    
    
    NSTimeInterval interval;
    
    if (str.length == 13)
    {
        interval=[str doubleValue] / 1000.0;
    }
    else if (str.length == 10)

    {
       interval = [str doubleValue];
    }
    else
    {
        return @"";
    }

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [objDateformat stringFromDate: date];
    return dateString;
}

+(NSAttributedString*)attributedJiaGe:(NSString *)str cgfl:(CGFloat)cgf1  cgf2:(CGFloat)cgf2 color:(UIColor *)color isInteger:(BOOL)integer
{

    CGFloat strF = [str floatValue];
    if (integer)
    {
        str = [NSString stringWithFormat:@"￥%.0f",strF / 100.00];
    }
    else
    {
        str = [NSString stringWithFormat:@"￥%.2f",strF / 100.00];
    }
    NSMutableAttributedString *atring = [[NSMutableAttributedString alloc]initWithString:str];
    [atring addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,str.length)];
    [atring addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:cgf1] range:NSMakeRange(0, 1)];
    [atring addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:cgf2] range:NSMakeRange(1, str.length-1)];
    return atring;
}

+(NSAttributedString*)grayAttributedJiaGe:(NSString *)str cgfl:(CGFloat)cgf1  cgf2:(CGFloat)cgf2 color:(UIColor *)color isInteger:(BOOL)integer
{
    
    CGFloat strF = [str floatValue];
    if (integer)
    {
        str = [NSString stringWithFormat:@"￥%.0f",strF / 100.00];
    }
    else
    {
        str = [NSString stringWithFormat:@"￥%.2f",strF / 100.00];
    }
    NSMutableAttributedString *atring = [[NSMutableAttributedString alloc]initWithString:str];
    [atring addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,str.length)];
    [atring addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:cgf1] range:NSMakeRange(0, 1)];
    [atring addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:cgf2] range:NSMakeRange(1, str.length-1)];
    NSUInteger length = [str length];
    
    [atring addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [atring addAttribute:NSStrikethroughColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, length)];
    [atring addAttribute:NSBaselineOffsetAttributeName value:@0 range:NSMakeRange(0, length)];
    
    
    return atring;
}

+(NSAttributedString *)text:(NSString *)textStr value:(NSString *)valueStr color:(UIColor *)color font:(CGFloat)font
{
   NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:textStr];
    NSRange range1 = [[str string] rangeOfString:valueStr];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range1];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range1];
    return str;
}

+ (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr ) {
        return YES;
    }
    if([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if(!aStr.length) {
        return YES;
    }
    if(aStr == nil) {
        return YES;
    }
    if(aStr == NULL) {
        return YES;
    }
    if ([aStr isEqualToString:@"NULL"]) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
        
    }
    return NO;
}
+ (BOOL)isBlankArr:(NSArray *)arr{
    if (!arr) {
        return YES;
    }
    if (![arr isKindOfClass:[NSArray class]]) {
        return YES;
    }
    if ([arr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!arr.count) {
        return YES;
    }
    if (arr == nil || arr == NULL) {
        return YES;
    }
    return NO;
}

+ (BOOL)isBlankDictionary:(NSDictionary *)dic{
    if (!dic) {
        return YES;
    }
    if ([dic isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    if (!dic.count) {
        return YES;
    }
    if (dic == nil) {
        return YES;
    }
    if (dic == NULL) {
        return YES;
    }
    return NO;
   
}
// 图片压缩处理
+ (NSData *)compressImage:(NSData *)imageData maxKB:(NSUInteger)maxKB{

    if (imageData && imageData.length <= 1024 * maxKB) {
        NSLog(@"无须压缩大小 = %lu KB", imageData.length / 1024);
        return imageData;
    }
    
    CGFloat compression = 1;
    CGFloat max = 1;
    CGFloat min = 0;
    
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        imageData = UIImageJPEGRepresentation([UIImage imageWithData:imageData], compression);

        if (imageData.length < 1024 * maxKB * 0.9) {
            min = compression;
        } else if (imageData.length > 1024 * maxKB) {
            max = compression;
        } else {
            break;
        }
    }
    
    if (imageData.length < 1024 * maxKB){
        NSLog(@"质量压缩后大小 = %ld KB", imageData.length / 1024);
        return imageData;
    }
    
    UIImage *resultImage = [UIImage imageWithData:imageData];
    NSUInteger lastDataLength = 0;
    while (imageData.length > 1024 * maxKB && imageData.length != lastDataLength) {
        lastDataLength = imageData.length;
        CGFloat ratio = (CGFloat)1024 * maxKB / imageData.length;
//        NSLog(@"尺寸压缩比例 = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        imageData = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    NSLog(@"质量尺寸压缩后大小 = %ld KB", imageData.length / 1024);
    return imageData;
}

+ (void)configStatusBarBackgroundColor:(UIColor *)color {
    if(@available(iOS 13.0, *)) {
        CGRect statusBarFrame = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame;
        UIView *statusBar = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
        statusBar.tag = 1300;
        for (UIView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
            if (subView.tag == 1300) {
                subView.backgroundColor = color;
                return;
            }
            if (CGRectEqualToRect(subView.frame, statusBarFrame)) {
                subView.backgroundColor = color;
                return;
            }
        }
    }
    else{
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor= color;
        }
    }
}
@end
