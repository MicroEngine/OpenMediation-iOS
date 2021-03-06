// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMUnityAdapter.h"
#import "OMUnityRouter.h"

@implementation OMUnityAdapter

+ (NSString*)adapterVerison {
    return UnityAdapterVersion;
}

+ (void)setConsent:(BOOL)consent {
    
    Class metaDataClass = NSClassFromString(@"UADSMetaData");
    if (metaDataClass && [metaDataClass instancesRespondToSelector:@selector(setValue:forKey:)] && [metaDataClass instancesRespondToSelector:@selector(commit)]) {
        UADSMetaData *gdprConsentMetaData = [[metaDataClass alloc] init];
        [gdprConsentMetaData set:@"gdpr.consent" value:[NSNumber numberWithBool:consent]];
        [gdprConsentMetaData commit];
    }
}

+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    Class metaDataClass = NSClassFromString(@"UADSMetaData");
    if (metaDataClass && [metaDataClass instancesRespondToSelector:@selector(setValue:forKey:)] && [metaDataClass instancesRespondToSelector:@selector(commit)]) {
        UADSMetaData *privacyConsentMetaData = [[metaDataClass alloc] init];
        [privacyConsentMetaData set:@"privacy.consent" value:[NSNumber numberWithBool:!privacyLimit]];
        [privacyConsentMetaData commit];
    }
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {

    Class unityClass = NSClassFromString(@"UnityAds");
    if (!unityClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.unityadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"Unity SDK not found"}];
        completionHandler(error);
        return;
    }
    
    NSString *key = [configuration objectForKey:@"appKey"];
    if (unityClass && [unityClass respondsToSelector:@selector(initialize:delegate:)] && [key length]>0) {
        [unityClass initialize:key];
        completionHandler(nil);
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.unityadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key."}];
        completionHandler(error);
    }

}

@end
