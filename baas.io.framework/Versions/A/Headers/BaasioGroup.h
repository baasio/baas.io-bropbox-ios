//
//  BaasioGroup.h
//  baas.io-ios-sdk
//
//  Created by cetauri on 12. 12. 11..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaasioUser.h"

/**
 A bass.io Framework Group Object.
*/
@interface BaasioGroup : BaasioEntity
/**
 setGroupName
 @param group group name
*/
- (void)setGroupName:(NSString*)group;
/**
 setUserName
 @param user user name
*/
- (void)setUserName:(NSString*)user;

/**
 create
 @param error error
*/
- (BaasioEntity *)save:(NSError **)error;
/**
 create asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
*/
- (BaasioRequest*)saveInBackground:(void (^)(BaasioGroup *group))successBlock
                      failureBlock:(void (^)(NSError *error))failureBlock;

/**
 update
 @param error error
 */
- (BaasioEntity *)update:(NSError **)error;

/**
 update asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)updateInBackground:(void (^)(BaasioGroup *group))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock;

/**
 delete
 @param error error
 */
- (void)delete:(NSError **)error;
/**
 delete asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)deleteInBackground:(void (^)(void))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock;

//XXX : join, withdraw
/**
 add
 @param error error
 */
- (void)add:(NSError **)error;
/**
 add asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)addInBackground:(void (^)(BaasioGroup *group))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock;
/**
 remove
 @param error error
 */
- (void)remove:(NSError **)error;
/**
 remove asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)removeInBackground:(void (^)(void))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock;
@end
