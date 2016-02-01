//
//  DEFINE.h
//
//  defines for iOS project
/*!
 APPDELEGATE
 DebugLog
 kHeight
 kWidth
 WINDOW
 */




#ifndef DEFINE_h
#define DEFINE_h

#import "AppDelegate.h"

//*************调试打印*************//
#define ISDEBUG 1
/*调试时才打印*/
#define DebugLog(s, ...) if(ISDEBUG) {\
NSLog(@"*************DebugLog*************");\
NSLog(@"path:%s", __FILE__);\
NSLog(@"lines:%d, method:%s", __LINE__, __FUNCTION__);\
NSLog(s, ##__VA_ARGS__);\
NSLog(@"***********EndOfDebugLog**********");\
}

//*************屏幕宽高*************//
/*屏幕宽度*/
#define kWidth [[UIScreen mainScreen] bounds].size.width
/*屏幕高度*/
#define kHeight [[UIScreen mainScreen] bounds].size.height

//*************AppDelegate单例*************//
/*AppDelegate单例*/
#define APPDELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

//*************唯一Window*************//
/*唯一Window*/
#define WINDOW (((AppDelegate *)[[UIApplication sharedApplication] delegate]).window)




#endif /* DEFINE_h */
