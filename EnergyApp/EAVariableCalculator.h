//
//  EAVariableCalculator.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
 
 Function of class:
 The logic behind getting the values. If there's a variable that is not put into the DB, then we access it here instead.
 
 Also a layer to get some arrays of Values, so we only have to edit them in one location
 
 */

#import <Foundation/Foundation.h>

@class EADatabaseFetcher;

@interface EAVariableCalculator : NSObject

@property (strong, nonatomic) EADatabaseFetcher *dbFetch;
@property (strong, nonatomic) NSArray *citiesArray;
@property (strong, nonatomic) NSArray *windowsArray;


-(NSInteger)degreeHours;
-(CGFloat)currentWindowUValue;
-(NSArray*)heatingSystems;
-(NSDictionary*)heatingSystemsAndCost;
-(CGFloat)heatingCostIncrease;
-(CGFloat)currentAtticUValue;
-(NSArray*)fireplaces;
-(NSDictionary*)fireplacesAndTheirEfficiencies;
-(NSString*)typeOfRadiators;
-(NSArray*)systemsOfRegulationForWaterHeating;
-(NSArray*)systemsOfRegulationForElectricRadiators;
-(NSDictionary*)regulatingSystemsForWaterHeatingAndEfficiencies;
-(NSDictionary*)regulatingSystemsForElectricalRadiators;
-(BOOL)areWaterThermostatsTooOld;
-(CGFloat)windowArea;
-(CGFloat)energyValueForChosenWood;
-(NSArray*)namesOfWoods;
-(CGFloat)costOfHeating;

@end
