//
// Created by cetauri on 12. 11. 26..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BaasioEntity.h"
#import "BaasioRequest.h"

/**
 A bass.io Framework File Object.
*/
@interface BaasioFile : BaasioEntity

@property(strong) NSString *filename;
@property(strong) NSString *contentType;
@property(strong) NSData *data;


- (BaasioRequest*)fileDownloadInBackground:(NSString *)downloadPath
                              successBlock:(void (^)(NSString *))successBlock
                              failureBlock:(void (^)(NSError *))failureBlock
                             progressBlock:(void (^)(float progress))progressBlock;

- (BaasioRequest*)fileUploadInBackground:(void (^)(BaasioFile *file))successBlock
                            failureBlock:(void (^)(NSError *))failureBlock
                           progressBlock:(void (^)(float progress))progressBlock;

- (BaasioRequest*)fileUpdateInBackground:(void (^)(BaasioFile *file))successBlock
                            failureBlock:(void (^)(NSError *))failureBlock
                           progressBlock:(void (^)(float progress))progressBlock;

- (BaasioRequest*)updateInBackground:(void (^)(id entity))successBlock
              failureBlock:(void (^)(NSError *error))failureBlock;


- (BaasioRequest*)getInBackground:(void (^)(BaasioFile *file))successBlock
                     failureBlock:(void (^)(NSError *))failureBlock;

- (BaasioRequest*)deleteInBackground:(void (^)(void))successBlock
              failureBlock:(void (^)(NSError *))failureBlock;

@end