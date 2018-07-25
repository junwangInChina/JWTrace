//
//  JWTrace.m
//  JWTraceDemo
//
//  Created by wangjun on 15/12/7.
//  Copyright © 2015年 wangjun. All rights reserved.
//

#import "JWTrace.h"

#import <UIKit/UIKit.h>

#include <execinfo.h>

@class JWTraceWindow;
@class JWConsoleController;

static NSString *logDirectoryName = @"AppOutput";
static NSString *logFileName = @"runLog.txt";
static JWTrace *sharedTrace = nil;

#pragma mark - JWConsoleController -------------------------------------------------------------------------------

@interface JWConsoleController : UIViewController
{
    UITextView *_consoleTextView;
}

@property (nonatomic, assign) BOOL scrollEnable;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSMutableString *logText;

- (void)showLog;

- (void)hideLog;

@end

@implementation JWConsoleController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.logText = [[NSMutableString alloc] init];
    
    [self configUI];
}

- (void)configUI
{
    _consoleTextView = [[UITextView alloc] initWithFrame:self.view.bounds];
    _consoleTextView.backgroundColor = [UIColor blackColor];
    _consoleTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _consoleTextView.font = [UIFont boldSystemFontOfSize:13];
    _consoleTextView.text = @"查看\r\n日志";
    _consoleTextView.textAlignment = NSTextAlignmentCenter;
    _consoleTextView.textColor = [UIColor whiteColor];
    _consoleTextView.editable = _consoleTextView.scrollEnabled =_consoleTextView.selectable = NO;
    _consoleTextView.alwaysBounceVertical = YES;
#ifdef __IPHONE_11_0
    if([_consoleTextView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
        _consoleTextView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#pragma clang diagnostic pop
        
    }
#endif
    [self.view addSubview:_consoleTextView];
    
    UIButton *_clearButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 70,
                                                                       CGRectGetMaxY(self.view.bounds) - 40,
                                                                       60,
                                                                       30)];
    [_clearButton addTarget:self
                     action:@selector(clearText)
           forControlEvents:UIControlEventTouchUpInside];
    [_clearButton setTitle:@"clear"
                  forState:UIControlStateNormal];
    _clearButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:13];
    [_clearButton setTitleColor:[UIColor colorWithRed:0/255.0 green:212/255.0 blue:59/255.0 alpha:1] forState:UIControlStateNormal];
    _clearButton.layer.borderWidth = (1.0 / [UIScreen mainScreen].scale);
    _clearButton.layer.borderColor = [UIColor colorWithRed:0/255.0 green:212/255.0 blue:59/255.0 alpha:1].CGColor;
    [self.view addSubview:_clearButton];
    
    UIButton *_copyButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 70*2,
                                                                       CGRectGetMaxY(self.view.bounds) - 40,
                                                                       60,
                                                                       30)];
    [_copyButton addTarget:self
                     action:@selector(copyText)
           forControlEvents:UIControlEventTouchUpInside];
    [_copyButton setTitle:@"copy"
                  forState:UIControlStateNormal];
    _copyButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:13];
    [_copyButton setTitleColor:[UIColor colorWithRed:0/255.0 green:212/255.0 blue:59/255.0 alpha:1] forState:UIControlStateNormal];
    _copyButton.layer.borderWidth = (1.0 / [UIScreen mainScreen].scale);
    _copyButton.layer.borderColor = [UIColor colorWithRed:0/255.0 green:212/255.0 blue:59/255.0 alpha:1].CGColor;
    [self.view addSubview:_copyButton];
}

- (void)setScrollEnable:(BOOL)scrollEnable
{
    _consoleTextView.scrollEnabled = scrollEnable;
    _consoleTextView.textAlignment = scrollEnable ? NSTextAlignmentLeft : NSTextAlignmentCenter;
}

- (void)setText:(NSString *)text
{
    [self.logText appendString:text];
}

- (void)showLog
{
    if(_consoleTextView)
    {
        _consoleTextView.text = self.logText;
        [_consoleTextView scrollRectToVisible:CGRectMake(0,
                                                         _consoleTextView.contentSize.height-15,
                                                         _consoleTextView.contentSize.width,
                                                         10)
                                     animated:YES];
    }

}

- (void)hideLog
{
    if(_consoleTextView)
    {
        _consoleTextView.text = @"查看\r\n日志";
        [_consoleTextView scrollRectToVisible:CGRectMake(0,
                                                         _consoleTextView.contentSize.height-15,
                                                         _consoleTextView.contentSize.width,
                                                         10)
                                     animated:YES];
    }
}

- (void)clearText
{
    self.logText = [NSMutableString string];
    _consoleTextView.text = @"";
}

- (void)copyText
{
    UIPasteboard *tempParste = [UIPasteboard generalPasteboard];
    tempParste.string = self.logText;
}

@end

#pragma mark - JWTraceWindow -----------------------------------------------------------------------------------

@interface JWTraceWindow : UIWindow

@property (nonatomic, assign) CGPoint axisXY;
@property (nonatomic, strong) JWConsoleController *consoleController;

+ (instancetype)consoleWindow;

- (void)maxmize;

- (void)minimize;

@end

@implementation JWTraceWindow

+ (instancetype)consoleWindow
{
    JWTraceWindow *window = [[self alloc] init];
    window.windowLevel = UIWindowLevelStatusBar + 100;
    window.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 120, 50, 50);
    window.layer.cornerRadius = 25;
    window.layer.masksToBounds = YES;
    return window;
}

- (JWConsoleController *)consoleController
{
    return (JWConsoleController *)self.rootViewController;
}

- (void)maxmize
{
    self.frame = [UIScreen mainScreen].bounds;
    self.layer.cornerRadius = 0;
    self.layer.masksToBounds = NO;
    self.consoleController.scrollEnable = YES;
}

- (void)minimize
{
    self.frame = CGRectMake(_axisXY.x, _axisXY.y, 50, 50);
    self.layer.cornerRadius = 25;
    self.layer.masksToBounds = YES;
    self.consoleController.scrollEnable = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.rootViewController.view.frame = self.bounds;
}

@end



#pragma mark - JWTrace -----------------------------------------------------------------------------------------

@interface JWTrace()

@property (nonatomic, assign) BOOL isShowWindow;
@property (nonatomic, strong) JWTraceWindow *traceWindow;
@property (nonatomic, strong) UIPanGestureRecognizer *moveGesture;

/**
 *  通过设定的打印级别与此次打印级别，判断打印权限
 *
 *  @param level 此次打印的基本
 *
 *  @return 返回此次能否打印
 */
bool outputPower(OutputLevel level);

/**
 *  打印基本描述
 *
 *  @param level 需要描述的打印级别
 *
 *  @return 返回具体打印基本对应的打印基本描述
 */
NSString* outputLevelDesctibetion(OutputLevel level);

/**
 *  获取当前时间
 *
 *  @return 返回当前时间
 */
const char *getNowDate();

/**
 *  输出到文件
 *
 *  @param string 需要输出的内容
 */
void outputToFile(NSString *string);

/**
 *  获取当前输出日志信息的文件路径
 *
 *  @return 返回文件路径
 */
NSString *outputFilePath();

/**
 *  判断当前写入日志的文件是否已经准备好
 *
 *  @return 返回是否准备好
 */
bool outputFileAlready();

/**
 *  创建文件，存在则不创建
 *
 *  @return 返回是否创建成功
 */
bool createOutputFile();

/**
 *  创建文件目录
 *
 *  @return 返回是否创建成功
 */
bool createOutputDirectory();

/**
 *  开启监控，用户捕获crash
 */
void startObservaction();

/**
 *  设置捕获类型
 */
void setupUncaughtSignals();

/**
 *  捕获异常
 *
 *  @param exception 异常描述
 */
void handleUncaughtException(NSException *exception);

/**
 *  异常
 *
 *  @param sig
 *  @param info
 *  @param context
 */
void handleUncaughtSignal(int sig, siginfo_t *info, void *context);

/**
 *  生成crash文件
 *
 *  @param crash crash信息
 */
void outputCrashFile(NSMutableString *crash);

@end

@implementation JWTrace

+ (JWTrace *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTrace = [[JWTrace alloc] init];
    });
    return sharedTrace;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 默认日志打印到控制台，并且不写入到文件，不输出到屏幕，日志级别为Debug
        self.outputConsole = YES;
        self.outputFile = NO;
        self.outputLevel = OutputLevelDebug;
        
        // 默认未展开屏幕
        self.isShowWindow = NO;
        
        // Debug包，默认开启日志打印功能
#ifdef DEBUG
        self.outputWindow = YES;
#else
        self.outputWindow = NO;
#endif
    }
    return self;
}

- (JWTraceWindow *)traceWindow
{
    if(!_traceWindow)
    {
        self.traceWindow = [JWTraceWindow consoleWindow];
        _traceWindow.rootViewController = [JWConsoleController new];
        _traceWindow.axisXY = _traceWindow.frame.origin;

        UISwipeGestureRecognizer *swipeGest = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLogView:)];
        UITapGestureRecognizer *tappGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapTextView:)];
        tappGest.numberOfTapsRequired = 2;
        
        [_traceWindow.rootViewController.view addGestureRecognizer:swipeGest];
        [_traceWindow.rootViewController.view addGestureRecognizer:tappGest];
        [_traceWindow.rootViewController.view addGestureRecognizer:self.moveGesture];
    }
    return _traceWindow;
}

- (UIPanGestureRecognizer *)moveGesture
{
    if (!_moveGesture)
    {
        self.moveGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(move:)];
    }
    return _moveGesture;
}

#pragma mark - Setter
- (void)setOutputWindow:(BOOL)outputWindow
{
    _outputWindow = outputWindow;
    self.traceWindow.hidden = !outputWindow;
}


#pragma mark - Console Log
void outputLog(OutputLevel level,
               const char *function,
               NSInteger line,
               NSString *format, ...)
{
    va_list logList;
    va_start(logList, format);
    format = [format stringByAppendingString:@"\n"];
    NSString *inputString = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@",format] arguments:logList];
    va_end(logList);
    
    NSString *outputMessage = [NSString stringWithFormat:@"%s [%s] %s m:%ld %@",[outputLevelDesctibetion(level) UTF8String],getNowDate(),function,(long)line,inputString];
    
    if ([[JWTrace shareInstance] outputConsole] &&
        (outputPower(level)))
    {
        // 打印到控制台
        fprintf(stderr, "%s",[outputMessage UTF8String]);
    }
     // 写入文件时，不需要判断设置的等级，全部写入
     if ([[JWTrace shareInstance] outputFile])
     {
         // 输出到文件
         outputToFile(outputMessage);
     }
    
    // 判断是否需要输出到屏幕
    if ([[JWTrace shareInstance] outputWindow] && (outputPower(level)))
    {
        // 输出到屏幕
        outputToWindow(outputMessage);
    }
#if !__has_feature(objc_arc)
    [inputString release];
#endif
}

bool outputPower(OutputLevel level)
{
    switch ([[JWTrace shareInstance] outputLevel])
    {
        case OutputLevelALL:
            return YES;
            break;
        case OutputLevelCritical:
        case OutputLevelError:
        case OutputLevelWarn:
        case OutputLevelInfo:
        case OutputLevelDebug:
            return ([[JWTrace shareInstance] outputLevel] == level);
            break;
        default:
            return NO;
            break;
    }
}

NSString* outputLevelDesctibetion(OutputLevel level)
{
    switch (level) {
        case OutputLevelCritical:
            return @"CRITICAL";
            break;
        case OutputLevelError:
            return @"ERROR";
            break;
        case OutputLevelWarn:
            return @"WARN";
            break;
        case OutputLevelInfo:
            return @"INFO";
            break;
        case OutputLevelDebug:
            return @"DEBUG";
            break;
        case OutputLevelALL:
            return @"ALL";
            break;
        default:
            return @"DEBUG";
            break;
    }
}

const char *getNowDate()
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSString *timeStamp = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
    
    return [timeStamp UTF8String];
}

#pragma mark - Window Log
void outputToWindow(NSString *str)
{
    [[[[JWTrace shareInstance] traceWindow] consoleController] setText:str];
}

#pragma mark - File Log
void outputToFile(NSString *str)
{
    if (str.length <= 0) return;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *tempFilePath = [cachePath stringByAppendingPathComponent:logFileName];
        
        NSFileManager *tempFileManager = [NSFileManager defaultManager];
        
        // 文件不存在，直接写入，创建初始文件
        if (![tempFileManager fileExistsAtPath:tempFilePath])
        {
            [@"日志开始\r\n" writeToFile:tempFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
        
        NSFileHandle *tempFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:tempFilePath];
        // 将节点跳转到文件末尾
        [tempFileHandle seekToEndOfFile];
        // 写入
        NSData *tempData = [str dataUsingEncoding:NSUTF8StringEncoding];
        [tempFileHandle writeData:tempData];
        // 关闭文件
        [tempFileHandle closeFile];

    });
}

#pragma mark - Crash Log
- (void)setCatchUncatchedException:(BOOL)catchUncatchedException
{
    if (catchUncatchedException)
    {
        startObservation();
    }
}

void startObservation()
{
    NSSetUncaughtExceptionHandler(&handleUncaughtException);
    setupUncaughtSignals();
}

void setupUncaughtSignals()
{
    struct sigaction signalAction;
    signalAction.sa_sigaction = handleUncaughtSignal;
    signalAction.sa_flags = SA_SIGINFO;
    
    sigemptyset(&signalAction.sa_mask);
    sigaction(SIGQUIT, &signalAction, NULL);
    sigaction(SIGILL, &signalAction, NULL);
    sigaction(SIGTRAP, &signalAction, NULL);
    sigaction(SIGABRT, &signalAction, NULL);
    sigaction(SIGEMT, &signalAction, NULL);
    sigaction(SIGFPE, &signalAction, NULL);
    sigaction(SIGBUS, &signalAction, NULL);
    sigaction(SIGSEGV, &signalAction, NULL);
    sigaction(SIGSYS, &signalAction, NULL);
    sigaction(SIGPIPE, &signalAction, NULL);
    sigaction(SIGALRM, &signalAction, NULL);
    sigaction(SIGXCPU, &signalAction, NULL);
    sigaction(SIGXFSZ, &signalAction, NULL);
}

void handleUncaughtException(NSException *exception)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *callStack = [exception callStackReturnAddresses];
        int i,len = [callStack count];
        void **frames = malloc(sizeof(void *)* len);
        
        for (i = 0; i < len; ++i) {
            frames[i] = (void *)[[callStack objectAtIndex:i] unsignedIntegerValue];
        }
        
        char **symbols = backtrace_symbols(frames,len);
        
        /* Now format into a message for sending to the user */
        
        NSMutableString *buffer = [[NSMutableString alloc] initWithCapacity:4096];
        
        NSBundle *bundle = [NSBundle mainBundle];
        [buffer appendFormat:@"%@ version %@ build %@\n\n",
         [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"],
         [bundle objectForInfoDictionaryKey:@"CFBundleVersion"],
         [bundle objectForInfoDictionaryKey:@"CIMBuildNumber"]];
        [buffer appendString:@"Uncaught Exception\n"];
        [buffer appendFormat:@"Exception Name: %@\n",[exception name]];
        [buffer appendFormat:@"Exception Reason: %@\n",[exception reason]];
        [buffer appendString:@"Stack trace:\n\n"];
        for (i = 0; i < len; ++i) {
            [buffer appendFormat:@"%4d - %s\n",i,symbols[i]];
        }
        
        outputCrashFile(buffer);
        
        free(frames);
        exit(0);
    });
}

void handleUncaughtSignal(int sig, siginfo_t *info, void *context)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        void *frames[128];
        int i,len = backtrace(frames, 128);
        char **symbols = backtrace_symbols(frames,len);
        
        /* Now format into a message for sending to the user */
        
        NSMutableString *buffer = [[NSMutableString alloc] initWithCapacity:4096];
        
        NSBundle *bundle = [NSBundle mainBundle];
        [buffer appendFormat:@"%@ version %@ build %@\n\n",
         [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"],
         [bundle objectForInfoDictionaryKey:@"CFBundleVersion"],
         [bundle objectForInfoDictionaryKey:@"CIMBuildNumber"]];
        [buffer appendString:@"Uncaught Signal\n"];
        [buffer appendFormat:@"si_signo    %d\n",info->si_signo];
        [buffer appendFormat:@"si_code     %d\n",info->si_code];
        [buffer appendFormat:@"si_value    %d\n",info->si_value];
        [buffer appendFormat:@"si_errno    %d\n",info->si_errno];
        [buffer appendFormat:@"si_addr     0x%08lX\n",info->si_addr];
        [buffer appendFormat:@"si_status   %d\n",info->si_status];
        [buffer appendString:@"Stack trace:\n\n"];
        for (i = 0; i < len; ++i) {
            [buffer appendFormat:@"%4d - %s\n",i,symbols[i]];
        }
        
        outputCrashFile(buffer);
        
        exit(0);
    });
}

/**
 *  生成crash文件
 *
 *  @param crash crash信息
 */
void outputCrashFile(NSMutableString *crash)
{
    //if (!createOutputDirectory()) return;
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSString *crashName = [NSString stringWithFormat:@"%s.crash",getNowDate()];
    NSString *crashFilePath = [[documentPath stringByAppendingPathComponent:logDirectoryName] stringByAppendingPathComponent:crashName];
    NSData *crashData = [crash dataUsingEncoding:NSUTF8StringEncoding];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:crashFilePath])
    {
        [crashData writeToFile:crashFilePath atomically:YES];
    }
}

#pragma mark- gesture function
- (void)swipeLogView:(UISwipeGestureRecognizer *)swipeGesture
{
    __weak __typeof(&*self)weakSelf = self;
    if (_isShowWindow)
    {
        //如果是显示情况并且往右边滑动就隐藏
        if (swipeGesture.direction == UISwipeGestureRecognizerDirectionRight)
        {
            [UIView animateWithDuration:0.5 animations:^{
                [weakSelf.traceWindow minimize];
            }
            completion:^(BOOL finished) {
                weakSelf.isShowWindow = NO;
                [weakSelf.traceWindow.consoleController hideLog];
            }];
        }
    }
}

- (void)doubleTapTextView:(UITapGestureRecognizer *)tapGesture
{
    __weak __typeof(&*self)weakSelf = self;
    if (!_isShowWindow)
    {
        //变成全屏
        [UIView animateWithDuration:0.2 animations:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.traceWindow.consoleController showLog];
            });
            [weakSelf.traceWindow maxmize];
        }
        completion:^(BOOL finished)
        {
            weakSelf.isShowWindow = YES;
            [weakSelf.traceWindow.consoleController.view removeGestureRecognizer:self.moveGesture];
        }];
    }
    else
    {
        //退出全屏
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf.traceWindow minimize];
        }
        completion:^(BOOL finished)
        {
            weakSelf.isShowWindow = NO;
            [weakSelf.traceWindow.rootViewController.view addGestureRecognizer:self.moveGesture];
            [weakSelf.traceWindow.consoleController hideLog];
        }];
    }
}

- (void)move:(UIPanGestureRecognizer *)gesture
{
    // 全屏状态，不让移动
    if (self.isShowWindow) return;
    
    CGPoint transalte = [gesture translationInView:[UIApplication sharedApplication].keyWindow];
    CGRect rect = self.traceWindow.frame;
    rect.origin.y += transalte.y;
    rect.origin.x += transalte.x;
    
    switch (gesture.state)
    {
        case UIGestureRecognizerStateEnded:
        {
            if(rect.origin.y < 0)
            {
                rect.origin.y = 0;
            }
            CGFloat maxY = [UIScreen mainScreen].bounds.size.height - rect.size.height;
            if(rect.origin.y > maxY)
            {
                rect.origin.y = maxY;
            }
            if (rect.origin.x < 0)
            {
                rect.origin.x = 0;
            }
            CGFloat maxX = [UIScreen mainScreen].bounds.size.width - rect.size.width;
            if(rect.origin.x > maxX)
            {
                rect.origin.x = maxX;
            }
            if (rect.origin.x > ([UIScreen mainScreen].bounds.size.width / 2.0))
            {
                rect.origin.x = maxX;
            }
            else
            {
                rect.origin.x = 0;
            }
            __weak __typeof(&*self)weakSelf = self;
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.traceWindow.frame = rect;
                weakSelf.traceWindow.axisXY = rect.origin;
            }];
        }
            break;
            
        default:
            break;
    }
    self.traceWindow.frame = rect;
    self.traceWindow.axisXY = rect.origin;
    [gesture setTranslation:CGPointZero
                     inView:[UIApplication sharedApplication].keyWindow];
}

@end


