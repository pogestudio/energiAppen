//
//  EAVariable.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EAVariableClass.h"

@class EAValue, EAVariableCondition;

@interface EAVariable : EAVariableClass

@property (nonatomic, retain) NSString * information;
@property (nonatomic, retain) NSString * inputDescription;
@property (nonatomic, retain) NSNumber * lowerBound;
@property (nonatomic, retain) NSString * sectionName;
@property (nonatomic, retain) NSNumber * shouldShow;
@property (nonatomic, retain) NSString * unitForTable;
@property (nonatomic, retain) NSNumber * upperBound;
@property (nonatomic, retain) NSNumber * usesBool;
@property (nonatomic, retain) NSNumber * usesPickerView;
@property (nonatomic, retain) NSNumber * usesTextField;
@property (nonatomic, retain) NSString * whereToFindIt;
@property (nonatomic, retain) EAVariableCondition *conditionToShow;
@property (nonatomic, retain) EAValue *value;
@property (nonatomic, retain) NSSet *valuesForPicker;
@end

@interface EAVariable (CoreDataGeneratedAccessors)

- (void)addValuesForPickerObject:(EAValue *)value;
- (void)removeValuesForPickerObject:(EAValue *)value;
- (void)addValuesForPicker:(NSSet *)values;
- (void)removeValuesForPicker:(NSSet *)values;

@end
