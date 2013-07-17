//
// Created by cetauri on 12. 11. 26..
//
// To change the template use AppCode | Preferences | File Templates.
//

#define PUSH_DEVICE_ID @"PUSH_DEVICE_ID_BAASIO_SDK"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaasioMessage.h"
#import "BaasioRequest.h"

/**
 A baas.io Framework Push Object.
*/
@interface BaasioPush : NSObject

/**
 Push 발송
 @param message Push 환경 설정 객체
 @param error error
 */
- (void)sendPush:(BaasioMessage *)message
           error:(NSError**)error;

/**
 Push 발송 asynchronously
 @param message Push 환경 설정 객체
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)sendPushInBackground:(BaasioMessage *)message
                          successBlock:(void (^)(void))successBlock
                          failureBlock:(void (^)(NSError *error))failureBlock;

/**
<<<<<<< HEAD
 디바이스 삭제
 @param error error
=======
 APNS에 디바이스 등록

 앱 시작나 로그인 후에 디바이스 등록이 필요한 시점에 호출하 된다.
 @param types types
>>>>>>> release/update_SDK_v0.8.1.3
 */
+ (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types;

/**
<<<<<<< HEAD
 디바이스 삭제 asynchronously
=======
 APNS에 디바이스 해제

 앱 로그아웃 시에 호출해주면 된다.
>>>>>>> release/update_SDK_v0.8.1.3
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (void)unregisterForRemoteNotifications:(void (^)(void))successBlock
                            failureBlock:(void (^)(NSError *error))failureBlock;

/**
 디바이스 등록
<<<<<<< HEAD
 @param deviceID device ID
=======

 baas.io에 디바이스 Token 전달 asynchronously
 @param deviceToken deviceToken
 @param tags tags
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)didRegisterForRemoteNotifications:(NSData *)deviceToken
                                               tags:(NSArray *)tags
                                       successBlock:(void (^)(void))successBlock
                                       failureBlock:(void (^)(NSError *error))failureBlock;

/**
 Push tag 수정하기
>>>>>>> release/update_SDK_v0.8.1.3
 @param tags tags
 @param error error
 */
- (void)tagUpdate:(NSArray *)tags
            error:(NSError**)error;

/**
<<<<<<< HEAD
 디바이스 등록 asynchronously
 @param deviceID device ID
=======
 Push tag 수정하기 asynchronously
>>>>>>> release/update_SDK_v0.8.1.3
 @param tags tags
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
<<<<<<< HEAD
- (BaasioRequest*)registerInBackground:(NSString *)deviceID
                                  tags:(NSArray *)tags
                          successBlock:(void (^)(void))successBlock
                          failureBlock:(void (^)(NSError *error))failureBlock;



/**
 Push 켜기
=======
- (BaasioRequest*)tagUpdateInBackground:(NSArray *)tags
                           successBlock:(void (^)(void))successBlock
                           failureBlock:(void (^)(NSError *error))failureBlock;

/**
 Push 켜기
 서버에서 push 발송을 하지 않도록 설정되어 있다면 push를 발송하도록 상태를 변경합니다.
>>>>>>> release/update_SDK_v0.8.1.3
 @param error error
 */
- (void)pushOn:(NSError**)error;

/**
<<<<<<< HEAD
 pushOnInBackground
=======
 Push 켜기 asynchronously

 서버에서 push 발송을 하지 않도록 설정되어 있다면 push를 발송하도록 상태를 변경합니다.
>>>>>>> release/update_SDK_v0.8.1.3
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)pushOnInBackground:(void (^)(void))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock;

/**
 Push 끄기
<<<<<<< HEAD
 @param error error
 */
- (void)pushOff:(NSError**)error;
/**
 pushOffInBackground
=======

 서버에서 push 발송을 하지 않도록 합니다. 설정에서 push on/off 기능이 있다면 이것을 사용하세요.
 @param error error
 */
- (void)pushOff:(NSError**)error;

/**
 Push 끄기 asynchronously

 서버에서 push 발송을 하지 않도록 합니다. 설정에서 push on/off 기능이 있다면 이것을 사용하세요.
>>>>>>> release/update_SDK_v0.8.1.3
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)pushOffInBackground:(void (^)(void))successBlock
                         failureBlock:(void (^)(NSError *error))failureBlock;


<<<<<<< HEAD
=======
@end

@interface BaasioPush(hidden)

-(NSString *)storedPushDeviceID;
-(NSString *)storedPushUserUUID;

-(NSArray *)storedPushDeviceString;
-(void)storedPushDeviceInfo:(NSString *)deviceID;
>>>>>>> release/update_SDK_v0.8.1.3
@end