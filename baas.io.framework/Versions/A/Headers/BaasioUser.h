//
// Created by cetauri on 12. 11. 19..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BaasioEntity.h"
#import "BaasioRequest.h"

/**
 A bass.io Framework User Object.
*/
@interface BaasioUser : BaasioEntity
@property(strong) NSString *username;

/**
 user
 */
+ (BaasioUser *)user;

/**
 currentUser
 */
+ (BaasioUser *)currentUser;

/**
 signOut
 */
+ (void)signOut;


/**
 signIn

 @param username username
 @param password password
 @param error error
 */
+ (void)signIn:(NSString *)username
      password:(NSString *)password
         error:(NSError**)error;

/**
 sign asynchronously

 @param username username
 @param password password
 @param failureBlock failureBlock
 @param failureBlock failureBlock
 */
+ (BaasioRequest*)signInBackground:(NSString *)username
                          password:(NSString *)password
                      successBlock:(void (^)(void))successBlock
                      failureBlock:(void (^)(NSError *error))failureBlock;

/**
 signUp

 @param username username
 @param password password
 @param name name
 @param email email
 @param error error
 */
+ (void)signUp:(NSString *)username
      password:(NSString *)password
          name:(NSString *)name
         email:(NSString *)email
         error:(NSError**)error;

/**
 signUp asynchronously

 @param username username
 @param password password
 @param name name
 @param email email
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+ (BaasioRequest*)signUpInBackground:(NSString *)username
                            password:(NSString *)password
                                name:(NSString *)name
                               email:(NSString *)email
                        successBlock:(void (^)(void))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock;

/**
 unsubscribe

 @param error error
 */
- (void)unsubscribe:(NSError**)error;

/**
 unsubscribe asynchronously

 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)unsubscribeInBackground:(void (^)(void))successBlock
                   failureBlock:(void (^)(NSError *error))failureBlock;


/**
 signUp via Facebook

 @param accessToken accessToken
 @param error error
 */
+ (void)signUpViaFacebook:(NSString *)accessToken
                    error:(NSError**)error;

/**
 signUp via Facebook asynchronously

 @param accessToken accessToken
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+ (BaasioRequest*)signUpViaFacebookInBackground:(NSString *)accessToken
                                          error:(void (^)(void))successBlock
                                   failureBlock:(void (^)(NSError *error))failureBlock;

/**
 signIn via Facebook

 @param accessToken accessToken
 @param error error
 */
+ (void)signInViaFacebook:(NSString *)accessToken
                    error:(NSError**)error;

/**
 signIn via Facebook asynchronously

 @param accessToken accessToken
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+ (BaasioRequest*)signInViaFacebookInBackground:(NSString *)accessToken
                                          error:(void (^)(void))successBlock
                                   failureBlock:(void (^)(NSError *error))failureBlock;

@end
