//
//  EATemporaryValueStorage.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
 
 Function of category:
 Offer a cache for fething objects in EASavings
 
 */


#import <Foundation/Foundation.h>

@interface EATemporaryValueStorage : NSObject


+(void)addValue:(NSString*)value forVariableTitle:(NSString*)title;
+(NSString*)valueForTitle:(NSString*)title;
+(void)clearStorage;

@end
