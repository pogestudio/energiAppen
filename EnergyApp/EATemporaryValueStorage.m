//
//  EATemporaryValueStorage.m
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EATemporaryValueStorage.h"

static NSMutableDictionary *_storage;

@implementation EATemporaryValueStorage

+(void)addValue:(NSString*)value forVariableTitle:(NSString*)title
{
    if (_storage == nil) {
        _storage = [[NSMutableDictionary alloc] init];
    }
    
    [_storage setObject:value forKey:title];
}

+(NSString*)valueForTitle:(NSString*)title
{
    NSString *valueToReturn;
    
    valueToReturn = [_storage objectForKey:title];
    return valueToReturn;
    
}

+(void)clearStorage
{
    _storage = nil;
}


@end
