//
//  EASavings+calculateSavings.m
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EASavings+calculate.h"
#import "EAVariable+additions.h"
#import "EAFinancial+helper.h"

//for DB
#import "EADatabaseFetcher.h"
//to calculate and get values
#import "EAVariableCalculator.h"

@interface EASavings (Private)

-(EADatabaseFetcher*)dbFetch;
-(EAVariable*)getVariableWithTitle:(NSString *)title;
-(EAVariableCalculator*)varCalc;

@end

@implementation EASavings (calculate)

-(void)calculateFinancials
{
    NSString *title = self.title;
    EAFinancial *thisFinancial = self.financial;
    
    /*
     
     Styr- och reglertekniska
     
     */
    if ([title isEqualToString:@"Nya termostater"]) {
        
        /*
         
         PRECONDITIONS
         
         */
        
        //if we don't have water heating, baaaail
        //if the age of thermostats arent old enough, baaaail
        
        NSString *typeOfRadiators = [self.varCalc typeOfRadiators];
        
        BOOL notUsingThermostats = ![typeOfRadiators isEqualToString:@"vatten"] ? YES : NO;
        BOOL thermostatsNotOldEnough = ![self.varCalc areWaterThermostatsTooOld];
        
        BOOL thermostatsDoesNotExist;
        NSString *currentRegulationSystem = [self.dbFetch getValueOfVariableWithTitle:@"Uppvärmningens styrsystem"];
        if ([currentRegulationSystem rangeOfString:@"termostat"].location == NSNotFound) {
            thermostatsDoesNotExist = YES;
        } else {
            thermostatsDoesNotExist = NO;
        }
        
        if (notUsingThermostats || thermostatsDoesNotExist || thermostatsNotOldEnough) {
            thisFinancial.savings = [NSNumber numberWithInt:0];
            return;
        }
        
        
        /*
         THE SAVINGS
         */
        
        CGFloat heatingEnergy = [[self.dbFetch getValueOfVariableWithTitle:@"Uppvärmning"] floatValue];
        
        CGFloat fractionAGoodThermostatHelps = 0.05;
        
        CGFloat savedEnergy = heatingEnergy * fractionAGoodThermostatHelps;
        CGFloat costOfHeating = [self.varCalc costOfHeating];        
        NSInteger savings = savedEnergy * costOfHeating;
        savings = [self roundValue:savings];

        
        /*
         THE COST
         */
        
        NSInteger numberOfRadiators = [[self.dbFetch getValueOfVariableWithTitle:@"Antal element"] intValue];
        NSInteger costPerRadiator = (250+0.3*750);
        NSInteger totalCost = costPerRadiator * numberOfRadiators;
        
        totalCost = [self roundValue:totalCost];
        NSNumber *payback = [self payBackForHeating:NO withSavings:savings andCost:totalCost];
        
        /*
         
         SAVE
         */
        
        thisFinancial.cost = [NSNumber numberWithInt:totalCost];
        thisFinancial.payback = payback;
        
        thisFinancial.savings = [NSNumber numberWithInt:savings];
        thisFinancial.unitForTable = @"kr/år";
        
    }

    
    if ([title isEqualToString:@"Installera inomhusgivare"]) {
        
        /*
         
         PRECONDITIONS
         
         */
        
        //if we don't have water heating, baaaail
        //if already operade by insidecontroller, baaaaail
        
        NSString *typeOfRadiators = [self.varCalc typeOfRadiators];
        NSString *systemOfRegulation = [self.dbFetch getValueOfVariableWithTitle:@"Uppvärmningens styrsystem"];
        
        BOOL weShouldBail = ![typeOfRadiators isEqualToString:@"vatten"] ? YES : NO;
        BOOL weShouldBail2 = [systemOfRegulation isEqualToString:@"Inomhusgivare"] ? YES : NO;
        
        if (weShouldBail || weShouldBail2) {
            thisFinancial.savings = [NSNumber numberWithInt:0];
            return;
        }
        
        
        /*
         THE SAVINGS
         */
        
        CGFloat heatingEnergy = [[self.dbFetch getValueOfVariableWithTitle:@"Uppvärmning"] floatValue];
        
        NSDictionary *waterHeatingRegulatingEfficiencies = [self.varCalc regulatingSystemsForWaterHeatingAndEfficiencies];
        CGFloat currentXc = [[waterHeatingRegulatingEfficiencies objectForKey:systemOfRegulation] floatValue];
        CGFloat newXc =  [[waterHeatingRegulatingEfficiencies objectForKey:@"Inomhusgivare"] floatValue];
        
        
        NSRange thermostatCheck = [systemOfRegulation rangeOfString:@"termostater"];
        BOOL systemIsUsingThermostat = (thermostatCheck.location == NSNotFound) ? NO : YES;
        
        if (systemIsUsingThermostat) {
            CGFloat fractionAGoodThermostatHelps = 0.05;
            if ([self.varCalc areWaterThermostatsTooOld]) {
                currentXc += fractionAGoodThermostatHelps;
            }
        }
  
        CGFloat savedEnergy = heatingEnergy * (currentXc - newXc);
        CGFloat costOfHeating = [self.varCalc costOfHeating];        
        NSInteger savings = savedEnergy * costOfHeating;
        savings = [self roundValue:savings];

        /*
         THE COST
         */
        
        NSInteger totalCost = 7600;
        totalCost = [self roundValue:totalCost];
        NSNumber *payback = [self payBackForHeating:NO withSavings:savings andCost:totalCost];
        
        /*
         
         SAVE
         */
        
        thisFinancial.cost = [NSNumber numberWithInt:totalCost];
        thisFinancial.payback = payback;
        
        thisFinancial.savings = [NSNumber numberWithInt:savings];
        thisFinancial.unitForTable = @"kr/år";
        
    }
    
    
    if ([title isEqualToString:@"Centralt styrsystem"]) {
        
        /*
         
         PRECONDITIONS
         
         */
        
        //if we don't have electric radiators baaail
        //if it's operated by central system, baaaaail
        
        NSString *heatingSystem = [self.dbFetch getValueOfVariableWithTitle:@"Uppvärmningssystem"];
        NSString *systemOfRegulation = [self.dbFetch getValueOfVariableWithTitle:@"Elradiator styrsystem"];
        
        BOOL weShouldBail = ![heatingSystem isEqualToString:@"Elradiatorer"] ? YES : NO;
        BOOL weShouldBail2 = [systemOfRegulation isEqualToString:@"Central styrning"] ? YES : NO;
        
        if (weShouldBail || weShouldBail2) {
            thisFinancial.savings = [NSNumber numberWithInt:0];
            return;
        }
        
        
        /*
         THE SAVINGS
         */
        
        CGFloat heatingEnergy = [[self.dbFetch getValueOfVariableWithTitle:@"Uppvärmning"] floatValue];
        
        NSDictionary *electricalRadiatorRegulatingEfficiencies = [self.varCalc regulatingSystemsForElectricalRadiators];
        CGFloat currentXc = [[electricalRadiatorRegulatingEfficiencies objectForKey:systemOfRegulation] floatValue];
        CGFloat newXc =  [[electricalRadiatorRegulatingEfficiencies objectForKey:@"Central styrning"] floatValue];
        
        CGFloat savedEnergy = heatingEnergy * (currentXc - newXc);
        CGFloat costOfHeating = [self.varCalc costOfHeating];        
        NSInteger savings = savedEnergy * costOfHeating;
        savings = [self roundValue:savings];

        /*
         THE COST
         */
        
        NSInteger totalCost = 8250;
        totalCost = [self roundValue:totalCost];
        NSNumber *payback = [self payBackForHeating:NO withSavings:savings andCost:totalCost];
        
        /*
         
         SAVE
         */
        
        thisFinancial.cost = [NSNumber numberWithInt:totalCost];
        thisFinancial.payback = payback;
        
        thisFinancial.savings = [NSNumber numberWithInt:savings];
        thisFinancial.unitForTable = @"kr/år";
        
    }
    
    if ([title isEqualToString:@"Timer till handdukstork"]) {
        
        /*
         
         PRECONDITIONS
         
         */
        
        //if there are no driers, baaaaail
        //if it's operated by timer. baaaaaail
        
        NSString *systemOfRegulation = [self.dbFetch getValueOfVariableWithTitle:@"Handdukstork styrning"];
        NSInteger amountOfElectricalTowelDriers = [[self.dbFetch getValueOfVariableWithTitle:@"Elhanddukstork"] intValue];
        
        BOOL weShouldBail = amountOfElectricalTowelDriers == 0 ? YES : NO;
        BOOL weShouldBail2 = [systemOfRegulation isEqualToString:@"Timer"] ? YES : NO;
        
        if (weShouldBail || weShouldBail2) {
            thisFinancial.savings = [NSNumber numberWithInt:0];
            return;
        }
        
        
        /*
         THE SAVINGS
         */
        
        CGFloat powerOfDrier = [[self.dbFetch getValueOfVariableWithTitle:@"Handdukstork effekt"] floatValue];
        NSInteger currentTimePerYear = 7000;
        NSInteger timerPerYearAfterTimer = 730;
        NSInteger hoursSaved = currentTimePerYear - timerPerYearAfterTimer;
        CGFloat savedElectricalEnergyPerYear = hoursSaved * powerOfDrier;
        CGFloat costOfElectricity = [[self.dbFetch getValueOfVariableWithTitle:@"Elkostnad"] floatValue];
        CGFloat savedCostsInElectricity = savedElectricalEnergyPerYear * costOfElectricity * 0.001;
        
        //however, some energy became useful heat. The heating system has to go in and help heat that, which costs more
        
        CGFloat fractionUsefulEnergyFromDrier = 0.56;
        CGFloat energyWeNeedToReplace = savedElectricalEnergyPerYear * fractionUsefulEnergyFromDrier;
        CGFloat costOfRegularHeating = [self.varCalc costOfHeating];        

        CGFloat costToHeatUpLostUsefulEnergy = energyWeNeedToReplace * costOfRegularHeating * 0.001;
        
        NSInteger savings = (savedCostsInElectricity - costToHeatUpLostUsefulEnergy) * amountOfElectricalTowelDriers;
        savings = [self roundValue:savings];

        /*
         THE COST
         */
        
        NSInteger totalCost = 1750 * amountOfElectricalTowelDriers;
        totalCost = [self roundValue:totalCost];

        NSNumber *payback = [self payBackForHeating:NO withSavings:savings andCost:totalCost];
        
        /*
         
         SAVE
         */
        
        thisFinancial.cost = [NSNumber numberWithInt:totalCost];
        thisFinancial.payback = payback;
        
        thisFinancial.savings = [NSNumber numberWithInt:savings];
        thisFinancial.unitForTable = @"kr/år";
        
    }
    

    if ([title isEqualToString:@"Byta cirkulationspump"]) {
        
        /*
         
         PRECONDITIONS
         
         */
        
        //if it isn't water radiators, fuck it.
        //if the current one isn't old enough, fuck it.
        
        NSString *typeOfRadiators = [self.varCalc typeOfRadiators];
        NSInteger yearOfCreationOfCurrentPump = [[self.dbFetch getValueOfVariableWithTitle:@"Cirkulationspump"] intValue];
        NSInteger shouldNotBeOlderThanThis = 14;
        
        BOOL weShouldBail = ![typeOfRadiators isEqualToString:@"vatten"] ? YES : NO;
        BOOL weShouldBail2 = yearOfCreationOfCurrentPump > (2012-shouldNotBeOlderThanThis) ? YES : NO;
        
        if (weShouldBail || weShouldBail2) {
            thisFinancial.savings = [NSNumber numberWithInt:0];
            return;
        }
        
        
        /*
         THE SAVINGS
         */
        
        NSInteger savedElectricityPerYear = 500;
        CGFloat costOfElectricity = [[self.dbFetch getValueOfVariableWithTitle:@"Elkostnad"] floatValue];
        NSInteger savings = savedElectricityPerYear * costOfElectricity;
        savings = [self roundValue:savings];

        
        /*
         THE COST
         */
        
        NSInteger totalCost = 3500;
        totalCost = [self roundValue:totalCost];

        NSNumber *payback = [self payBackForHeating:NO withSavings:savings andCost:totalCost];
        
        /*
         
         SAVE
         */
        
        thisFinancial.cost = [NSNumber numberWithInt:totalCost];
        thisFinancial.payback = payback;
        
        thisFinancial.savings = [NSNumber numberWithInt:savings];
        thisFinancial.unitForTable = @"kr/år";
        
    }
    

    
    
    if ([title isEqualToString:@"Sänk inomhustemperatur"]) {
        
        /*
         
         PRECONDITIONS
         
         */
        
        //if temperature is at or below 20, bail out. That's the temp we recommend lowering to.
        
        NSInteger currentTemperature = [[self.dbFetch getValueOfVariableWithTitle:@"Inomhustemperatur"] intValue];
        
        BOOL weShouldBail = currentTemperature <= 20 ? YES : NO;
        
        if (weShouldBail) {
            thisFinancial.savings = [NSNumber numberWithInt:0];
            return;
        }
        
        
        /*
         THE SAVINGS
         */
        
        NSInteger currentHeatingEnergy = [[self.dbFetch getValueOfVariableWithTitle:@"Uppvärmning"] intValue];
        CGFloat calculateSavingsToThisTemperature = 20;
        CGFloat savingsPerDegree = 0.06;
        CGFloat savingsFraction = savingsPerDegree * (currentTemperature - calculateSavingsToThisTemperature);
        CGFloat savingsInEnergy = currentHeatingEnergy * savingsFraction;
        CGFloat regularHeatingCost = [self.varCalc costOfHeating];        

        NSInteger savings = savingsInEnergy * regularHeatingCost;
        savings = [self roundValue:savings];

        
        /*
         THE COST
         */

        NSNumber *payback = [NSNumber numberWithInt:0];
        
        /*
         
         SAVE
         */
        
        thisFinancial.cost = [NSNumber numberWithInt:0];
        thisFinancial.payback = payback;
        
        thisFinancial.savings = [NSNumber numberWithInt:savings];
        thisFinancial.unitForTable = @"kr/år";
        
    }
    

    if ([title isEqualToString:@"Tillfälligt sänka inomhustemperatur"]) {
        
        /*
         
         PRECONDITIONS
         
         */
        
        
        /*
         THE SAVINGS
         */
        
        NSInteger currentHeatingEnergy = [[self.dbFetch getValueOfVariableWithTitle:@"Uppvärmning"] intValue];
        CGFloat amountOfDegreesToLower = 3;
        CGFloat savingsPerDegree = 0.05;
        CGFloat savingsFraction = savingsPerDegree * amountOfDegreesToLower;
        CGFloat savingsInEnergy = currentHeatingEnergy * savingsFraction;
        CGFloat regularHeatingCost = [self.varCalc costOfHeating];        

        CGFloat savingsForAnEntireYear = savingsInEnergy * regularHeatingCost;
        CGFloat actualTimePeriod = 1.0/52; //one week of a year;
        NSInteger savings = savingsForAnEntireYear * actualTimePeriod;
        savings = [self roundValue:savings];

        /*
         THE COST
         */
        
        NSNumber *payback = [NSNumber numberWithInt:0];
        
        /*
         
         SAVE
         */
        
        thisFinancial.cost = [NSNumber numberWithInt:0];
        thisFinancial.payback = payback;
        
        thisFinancial.savings = [NSNumber numberWithInt:savings];
        thisFinancial.unitForTable = @"kr/vecka";
        
    }
    

    
    /*
     
     Installationstekniska
     
     */
    
    
    if ([title isEqualToString:@"Snålspolande armaturer"]) {
        
        /*
         
         PRECONDITIONS
         
         */
        
        
        /*
         THE SAVINGS
         */
        
        //1 calculate how big a part of the whole water usage each type of faucet stands for
        //2 see how much you can save for each faucet
        //3 calculate total savings
        
        
        //1
        
        int amountTwoHandleFaucetsInKitchen = [[self.dbFetch getValueOfVariableWithTitle:@"Tvågrepps kökskranar"] intValue];
        int amountTwoHandleFaucetsInBathroom = [[self.dbFetch getValueOfVariableWithTitle:@"Tvågrepps tvättställ"] intValue];
        int amountTwoHandleFaucetsInShower = [[self.dbFetch getValueOfVariableWithTitle:@"Tvågrepps duschar"] intValue];
        
        int amountOneHandleFaucetsInKitchen = [[self.dbFetch getValueOfVariableWithTitle:@"Engrepps kökskranar"] intValue];
        int amountOneHandleFaucetsInBathroom = [[self.dbFetch getValueOfVariableWithTitle:@"Engrepps tvättställ"] intValue];
        int amountOneHandleFaucetsInShower = [[self.dbFetch getValueOfVariableWithTitle:@"Engrepps duschar"] intValue];
        
        int amountResourceEfficientFaucetsInKitchen = [[self.dbFetch getValueOfVariableWithTitle:@"Resurseffektiva kökskranar"] intValue];
        int amountResourceEfficientFaucetsInBathroom = [[self.dbFetch getValueOfVariableWithTitle:@"Resurseffektiva tvättställ"] intValue];
        int amountResourceEfficientFaucetsInShower = [[self.dbFetch getValueOfVariableWithTitle:@"Resurseffektiva duschar"] intValue];
        
        CGFloat statisticalUsageFromTwoHandleFaucetsInKitchen  = 8.0;
        CGFloat statisticalUsageFromTwoHandleFaucetsInBathroom  = 2.0;
        CGFloat statisticalUsageFromTwoHandleFaucetsInShower  = 10.0;
        
        CGFloat statisticalUsageFromOneHandleFaucetsInKitchen  = 6.4;
        CGFloat statisticalUsageFromOneHandleFaucetsInBathroom  = 1.6;
        CGFloat statisticalUsageFromOneHandleFaucetsInShower  = 8.0;
        
        CGFloat statisticalUsageFromResourceEfficientFaucetsInKitchen  = 5.1;
        CGFloat statisticalUsageFromResourceEfficientFaucetsInBathroom  = 1.3;
        CGFloat statisticalUsageFromResourceEfficientFaucetsInShower  = 6.4;
        
        
        //weighed
        
        CGFloat weighed1 = amountTwoHandleFaucetsInKitchen * statisticalUsageFromTwoHandleFaucetsInKitchen;
        CGFloat weighed2 = amountTwoHandleFaucetsInBathroom * statisticalUsageFromTwoHandleFaucetsInBathroom;
        CGFloat weighed3 = amountTwoHandleFaucetsInShower * statisticalUsageFromTwoHandleFaucetsInShower;
        
        CGFloat weighed4 = amountOneHandleFaucetsInKitchen * statisticalUsageFromOneHandleFaucetsInKitchen;
        CGFloat weighed5 = amountOneHandleFaucetsInBathroom * statisticalUsageFromOneHandleFaucetsInBathroom;
        CGFloat weighed6 = amountOneHandleFaucetsInShower * statisticalUsageFromOneHandleFaucetsInShower;
        
        CGFloat weighed7 = amountResourceEfficientFaucetsInKitchen * statisticalUsageFromResourceEfficientFaucetsInKitchen;
        CGFloat weighed8 = amountResourceEfficientFaucetsInBathroom * statisticalUsageFromResourceEfficientFaucetsInBathroom;
        CGFloat weighed9 = amountResourceEfficientFaucetsInShower * statisticalUsageFromResourceEfficientFaucetsInShower;
        
        CGFloat totalWeighed = weighed1 + weighed2 + weighed3 + weighed4 + weighed5 + weighed6 + weighed7 + weighed8 + weighed9;
        
        
        //how big a part of the whole water consumption does each thing represent?
        CGFloat partOfWholeTwoHandleKitchen = weighed1 / totalWeighed;
        CGFloat partOfWholeTwoHandleBathroom = weighed2 / totalWeighed;
        CGFloat partOfWholeTwoHandleShower = weighed3 / totalWeighed;
        CGFloat partOfWholeOneHandleKitchen = weighed4 / totalWeighed;
        CGFloat partOfWholeOneHandleBathroom = weighed5 / totalWeighed;
        CGFloat partOfWholeOneHandleShower = weighed6 / totalWeighed;
        CGFloat partOfWholeResourceEffKitchen = weighed7 / totalWeighed;
        CGFloat partOfWholeResourceEffBathroom = weighed8 / totalWeighed;
        CGFloat partOfWholeResourceEffShower = weighed9 / totalWeighed;
        
        
        //2
        //the savings if you switch from mentioned water source to the most efficient
        
        CGFloat savingPotentialForTwoHandle = 0.36;
        CGFloat savingPotentialForOneHandle = 0.20;
        CGFloat savingPotentialForResourceEfficient = 0;
        
        CGFloat savingPotentialTwoHandle = (partOfWholeTwoHandleKitchen + partOfWholeTwoHandleBathroom + partOfWholeTwoHandleShower) * savingPotentialForTwoHandle;
        
        CGFloat savingPotentialOneHandle = (partOfWholeOneHandleKitchen + partOfWholeOneHandleBathroom + partOfWholeOneHandleShower) * savingPotentialForOneHandle;
        
        CGFloat savingPotentialResourceEfficient = (partOfWholeResourceEffKitchen + partOfWholeResourceEffBathroom + partOfWholeResourceEffShower) * savingPotentialForResourceEfficient;
        
        
        //3
        CGFloat totalSavingPotential = savingPotentialTwoHandle + savingPotentialOneHandle + savingPotentialResourceEfficient;
    
        CGFloat totalWaterConsumption = [[self.dbFetch getValueOfVariableWithTitle:@"Vatten"] floatValue];
        CGFloat amountOfWaterUsedByWashingMachine = 0.058;
        totalWaterConsumption *= (1 - amountOfWaterUsedByWashingMachine);
        CGFloat totalSavedWater = totalWaterConsumption * totalSavingPotential;
        CGFloat fractionOfWarmWater = 1/3.5;
        CGFloat savedWarmWater = fractionOfWarmWater * totalSavedWater;
        
        NSInteger energyRequiredPerCbmOfWarmWater = 55; //kWh
        CGFloat totalSavedEnergy = savedWarmWater * energyRequiredPerCbmOfWarmWater;
        
        CGFloat costOfWater = [[self.dbFetch getValueOfVariableWithTitle:@"Vattenkostnad"] floatValue]; 
        CGFloat savedMoneyFromLessWater = totalSavedWater * costOfWater;
        
        CGFloat costOfHeating = [self.varCalc costOfHeating];        
        CGFloat savedMoneyFromLessEnergy = totalSavedEnergy * costOfHeating;
        
        NSInteger savings = savedMoneyFromLessWater + savedMoneyFromLessEnergy;
        savings = [self roundValue:savings];

        
        /*
         THE COST
         */
        
        //we'll simply list the cost of fixing each, then multiply them with the respective amount
        
        
        //these are the costs to fix two-handle stuff
        NSInteger costOfResourceEfficientBathroom = 2065;
        NSInteger costOfResourceEfficientKitchen = 2065;
        NSInteger costOfResourceEfficientShower = 2737;
        
        //these are the costs if there's a one-handle faucet already.
        NSInteger costOfResourceEfficientShowerHead = 975;
        NSInteger costOfResourceEfficientSink = 200;
        
        
        NSInteger costOfFixingTwoHandleKitchen = amountTwoHandleFaucetsInKitchen * costOfResourceEfficientKitchen;
        NSInteger costOfFixingTwoHandleBathroom = amountTwoHandleFaucetsInBathroom * costOfResourceEfficientBathroom;
        NSInteger costOfFixingTwoHandleShower = amountTwoHandleFaucetsInShower * costOfResourceEfficientShower;
        
        NSInteger costOfFixingOneHandleKitchen = amountOneHandleFaucetsInKitchen * costOfResourceEfficientSink;
        NSInteger costOfFixingOneHandleBathroom = amountOneHandleFaucetsInBathroom * costOfResourceEfficientSink;
        NSInteger costOfFixingOneHandleShower = amountOneHandleFaucetsInShower * costOfResourceEfficientShowerHead;
        
        NSInteger totalCost = costOfFixingTwoHandleKitchen + costOfFixingTwoHandleBathroom + costOfFixingTwoHandleShower + costOfFixingOneHandleKitchen + costOfFixingOneHandleBathroom + costOfFixingOneHandleShower;
        
        
        totalCost = [self roundValue:totalCost];

        NSNumber *payback = [self payBackForHeating:YES withSavings:savings andCost:totalCost];
        
        /*
         
         SAVE
         */
        
        thisFinancial.cost = [NSNumber numberWithInt:totalCost];
        thisFinancial.payback = payback;
        
        thisFinancial.savings = [NSNumber numberWithInt:savings];
        thisFinancial.unitForTable = @"kr/år";
        
    }

    if ([title isEqualToString:@"Byta uppvärmningssystem"]) {
        
        /*
         
         PRECONDITIONS
         
         */
        
        //if the heating system is 13 years or older, show this
        NSInteger heatingSystemLastUpgradedThisYear = [[self.dbFetch getValueOfVariableWithTitle:@"Ålder uppvärmningssystem"] intValue];

        
        
        if (heatingSystemLastUpgradedThisYear >= 2012-13) {
            thisFinancial.savings = [NSNumber numberWithInt:0];
            return;
        }
        
        
        /*
         THE SAVINGS
         */
        
        //decrease U-value by 0.9 if we replace
        NSInteger savings = 1;
        
        
        /*
         THE COST
         */
        NSInteger totalCost = 0;
        NSNumber *payback = [NSNumber numberWithInt:0];
        
        /*
         
         SAVE
         */
        
        thisFinancial.cost = [NSNumber numberWithInt:totalCost];
        thisFinancial.payback = payback;
        
        thisFinancial.savings = [NSNumber numberWithInt:savings];
        thisFinancial.unitForTable = @"";
        
    }
    

    if ([title isEqualToString:@"Använda befintlig eldstad"]) {
        
        /*
         
         PRECONDITIONS
         
         */
        //get string of "no fireplace", the first of keys array in fire place dict
        NSArray *namesOfFireplaces = [self.varCalc fireplaces];
        NSString *nameOfNoFireplace = [namesOfFireplaces objectAtIndex:0];
        
        
        //if there is no fireplace, bail out
        NSString *currentFireplace = [self.dbFetch getValueOfVariableWithTitle:@"Typ av eldstad"];
        
        BOOL cond1 = [currentFireplace isEqualToString:nameOfNoFireplace];

        if (cond1) {
            thisFinancial.savings = [NSNumber numberWithInt:0];
            return;
        }
        
        
        /*
         THE SAVINGS
         */
        
        
        //1 calculate cost of heating 1 kWh with fireplace
        //2 withdraw against current cost of heating
        
        //1
        CGFloat energyInTheWoodUserLightsUp = [self.varCalc energyValueForChosenWood];
        
        NSString *howDoesUserBuyWood = [self.dbFetch getValueOfVariableWithTitle:@"Kubikmått"];
        
        CGFloat amountOfWoodInOneCbm;
        if ([howDoesUserBuyWood isEqualToString:@"Travat"]) {
            amountOfWoodInOneCbm = 0.65;
        } else if ([howDoesUserBuyWood isEqualToString:@"Stjälpt"]){
            amountOfWoodInOneCbm = 0.43;
        } else {
            NSAssert1(nil,@"Should never be here, something is wrong with fire in the fireplace function", nil);
        }
        
        CGFloat energyInOneCbm = energyInTheWoodUserLightsUp * amountOfWoodInOneCbm;

        NSDictionary *fireplacesAndEfficiencies = [self.varCalc fireplacesAndTheirEfficiencies];        
        CGFloat efficiencyOfCurrentFireplace = [[fireplacesAndEfficiencies objectForKey:currentFireplace] floatValue];
        CGFloat energyOutputOfOneCbm = energyInOneCbm * efficiencyOfCurrentFireplace;
        
        CGFloat costOfOneCbm = [[self.dbFetch getValueOfVariableWithTitle:@"Vedkostnad"] floatValue];
        
        //2
        CGFloat regularHeatingCost = [self.varCalc costOfHeating];        
        CGFloat profitPerCbm = regularHeatingCost * energyOutputOfOneCbm - costOfOneCbm;
        
        
        
        NSInteger savings = profitPerCbm;
        savings = [self roundValue:savings];

        
        /*
         THE COST
         */

        NSNumber *payback = [NSNumber numberWithInt:0];
        
        /*
         
         SAVE
         */
        
        thisFinancial.cost = [NSNumber numberWithInt:0];
        thisFinancial.payback = payback;
        
        thisFinancial.savings = [NSNumber numberWithInt:savings];
        thisFinancial.unitForTable = @"kr/kbm";
        
    }
    
    
    
    /*
     
     Byggnadstekniska
     
     */
    if ([title isEqualToString:@"Byt ruta till energiglas"]) {
        
        /*
         
         PRECONDITIONS
         
         */
        
        //if the window is not 1+1 or 1+1+1, bail out
        NSString *currentWindow = [self.dbFetch getValueOfVariableWithTitle:@"Fönstertyp"];
        NSString *cond1 = [self.varCalc.windowsArray objectAtIndex:1];
        NSString *cond2 = [self.varCalc.windowsArray objectAtIndex:3];
        
        if (![currentWindow isEqualToString:cond1] && ![currentWindow isEqualToString:cond2]) {
            thisFinancial.savings = [NSNumber numberWithInt:0];
            return;
        }
        
        
        /*
         THE SAVINGS
         */
        
        //decrease U-value by 0.9 if we replace
        CGFloat potentialDecreaseInUvalue = 0.9;
        
        NSInteger degreeHours = [self.varCalc degreeHours];
        CGFloat costOfHeating = [self.varCalc costOfHeating];        
        
        CGFloat windowArea = [self.varCalc windowArea];
        
        NSInteger savings = potentialDecreaseInUvalue * windowArea * degreeHours * costOfHeating * (0.001);
        savings = [self roundValue:savings];

        
        /*
         THE COST
         */
        
        NSInteger costPerSqm = 1900;
        NSInteger totalCost = costPerSqm * windowArea;
        totalCost = [self roundValue:totalCost];

        NSNumber *payback = [self payBackForHeating:YES withSavings:savings andCost:totalCost];
        
        /*
         
         SAVE
         */
        
        thisFinancial.cost = [NSNumber numberWithInt:totalCost];
        thisFinancial.payback = payback;
        
        thisFinancial.savings = [NSNumber numberWithInt:savings];
        thisFinancial.unitForTable = @"kr/år";
        
    }
    
    if ([title isEqualToString:@"Komplettera med energiglas"]) {
        
        /*
         
         PRECONDITIONS
         
         */
        
        //if the window is not 1, 1+1, 2 glass or 1+2, bail out
        NSString *currentWindow = [self.dbFetch getValueOfVariableWithTitle:@"Fönstertyp"];
        NSString *cond1 = [self.varCalc.windowsArray objectAtIndex:0];
        NSString *cond2 = [self.varCalc.windowsArray objectAtIndex:1];
        NSString *cond3 = [self.varCalc.windowsArray objectAtIndex:2];
        NSString *cond5 = [self.varCalc.windowsArray objectAtIndex:4];
        
        
        NSString *conditionOfWindows = [self.dbFetch getValueOfVariableWithTitle:@"Skick på bågar"];
        int cond4 = [conditionOfWindows isEqualToString:@"Dåligt skick"] ? 1 : 0;
        
        if ((![currentWindow isEqualToString:cond1] && ![currentWindow isEqualToString:cond2] && ![currentWindow isEqualToString:cond3] &&  ![currentWindow isEqualToString:cond5]) 
            || cond4) {
            thisFinancial.savings = [NSNumber numberWithInt:0];
            return;
        }
        
        
        /*
         THE SAVINGS
         */
        
        //decrease U-value by 1.2 if we insert new stuff
        CGFloat potentialDecreaseInUvalue = 1.2;
        
        NSInteger degreeHours = [self.varCalc degreeHours];
        CGFloat costOfHeating = [self.varCalc costOfHeating];        

        CGFloat windowArea = [self.varCalc windowArea];
        
        NSInteger savings = potentialDecreaseInUvalue * windowArea * degreeHours * costOfHeating * (0.001);
        savings = [self roundValue:savings];

        
        /*
         THE COST
         */
        
        NSInteger costPerSqm = 1700;
        NSInteger totalCost = costPerSqm * windowArea;
        totalCost = [self roundValue:totalCost];

        NSNumber *payback = [self payBackForHeating:YES withSavings:savings andCost:totalCost];
        
        /*
         
         SAVE
         */
        
        thisFinancial.cost = [NSNumber numberWithInt:totalCost];
        thisFinancial.payback = payback;
        
        thisFinancial.savings = [NSNumber numberWithInt:savings];
        thisFinancial.unitForTable = @"kr/år";
        
    }
    
    if ([title isEqualToString:@"Nya fönster"]) {
        /*
         PRECONDITIONS
         */
        
        //if the window is not 1, 1+1 or 2 glass, bail out
        NSString *currentWindow = [self.dbFetch getValueOfVariableWithTitle:@"Fönstertyp"];
        int is1glass = [currentWindow isEqualToString:[self.varCalc.windowsArray objectAtIndex:0]];
        int is1_1glass = [currentWindow isEqualToString:[self.varCalc.windowsArray objectAtIndex:1]];
        int is2glass = [currentWindow isEqualToString:[self.varCalc.windowsArray objectAtIndex:2]];
        NSString *culturallyProtected = [self.dbFetch getValueOfVariableWithTitle:@"Kulturskyddat"];
        BOOL thisHouseIsCulturallyProtected  = [culturallyProtected isEqualToString:@"Ja"] ? YES : NO;
        
        if ((!is1glass && !is1_1glass && !is2glass)
            || thisHouseIsCulturallyProtected)
        {
            thisFinancial.savings = [NSNumber numberWithInt:0];
            return;
        }
        
        /*
         THE SAVINGS
         */
        
        CGFloat currentUValue = [self.varCalc currentWindowUValue];
        //base it on 1.2 according to LEIF
        CGFloat uValueOfNewWindows = 1.2;
        CGFloat potentialDecreaseInUvalue = currentUValue - uValueOfNewWindows;
        NSInteger degreeHours = [self.varCalc degreeHours];
        CGFloat costOfHeating = [self.varCalc costOfHeating];        
        CGFloat windowArea = [self.varCalc windowArea];
        NSInteger savings = potentialDecreaseInUvalue * windowArea * degreeHours * costOfHeating * (0.001);
        savings = [self roundValue:savings];

        /*
         THE COST
         */
        
        NSInteger costPerSqm = 6666; //according to faktablad energikontoret värmland
        NSInteger totalCost = windowArea * costPerSqm;
        totalCost = [self roundValue:totalCost];

        NSNumber *payback = [self payBackForHeating:YES withSavings:savings andCost:totalCost];
        
        /*
         SAVE
         */
        
        thisFinancial.cost = [NSNumber numberWithInt:totalCost];
        thisFinancial.payback = payback;
        thisFinancial.savings = [NSNumber numberWithInt:savings];
        thisFinancial.unitForTable = @"kr/år";
        
    }
    
    if ([title isEqualToString:@"Täta fönster och dörrar"]) {
        
        
        /*
         PRECONDITIONS
         */
        
        //bail out if it's good sealed 
        NSString *currentSeal = [self.dbFetch getValueOfVariableWithTitle:@"Tätningslister"];

        BOOL weShouldBail = ![currentSeal isEqualToString:@"Dåligt skick"] ? YES : NO;
        if (weShouldBail)
        {
            thisFinancial.savings = [NSNumber numberWithInt:0];
            return;
        }
        
        /*
         THE SAVINGS
         */
        
        

        double potentialDecreaseOfYearlyEnergy = 0.05;
        CGFloat costOfHeating = [self.varCalc costOfHeating];        
        NSInteger yearlyHeating = [[self.dbFetch getValueOfVariableWithTitle:@"Uppvärmning"] intValue];
        NSInteger savings = potentialDecreaseOfYearlyEnergy  * yearlyHeating * costOfHeating;
        savings = [self roundValue:savings];

        /*
         THE COST
         */
        
        CGFloat windowArea = [self.varCalc windowArea];
        CGFloat circumferenceOfAWindow = 4.0;//assume each window about 1*1 meter. or 1.2*0.8, same same.
        CGFloat totalLength = windowArea*circumferenceOfAWindow;
        
        NSInteger costPerMeter = 35; //according to faktablad energikontoret värmland
        
        NSInteger totalCost = totalLength * costPerMeter;
        totalCost = [self roundValue:totalCost];

        NSNumber *payback = [self payBackForHeating:YES withSavings:savings andCost:totalCost];
        
        /*
         SAVE
         */
        
        thisFinancial.cost = [NSNumber numberWithInt:totalCost];
        thisFinancial.payback = payback;
        thisFinancial.savings = [NSNumber numberWithInt:savings];
        thisFinancial.unitForTable = @"kr/år";
        
    }
    
    if ([title isEqualToString:@"Tilläggsisolera kallvind"]) {
        /*
         PRECONDITIONS
         */
        //bail out
        //if the attic is not a cold attic
        //if there is not enough room to add more.
        
        NSString *typeOfAttic = [self.dbFetch getValueOfVariableWithTitle:@"Typ av vind"];
        int hasColdAttic = [typeOfAttic isEqualToString:@"Kallvind"] ? 1 : 0;
        
        CGFloat currentInsulationThickness = [[self.dbFetch getValueOfVariableWithTitle:@"Nuvarande isolering"] doubleValue];
        //get it to meters from cm
        currentInsulationThickness *= 0.01;
        
        CGFloat maximumInsulation = 0.50;
        CGFloat extraPotentialInsulation = maximumInsulation - currentInsulationThickness;

        if ( !hasColdAttic || extraPotentialInsulation <= 0.10)
        {
            thisFinancial.savings = [NSNumber numberWithInt:0];
            return;
        }
        
        /*
         THE SAVINGS
         */
        
        double currentUValue = [self.varCalc currentAtticUValue];

        
        //for cellulosafibre
        CGFloat newMateriaLambda = 0.04;
        CGFloat newUvalueAfterInsulation = 1 / ((extraPotentialInsulation / newMateriaLambda) + (1/currentUValue));
        CGFloat potentialDecreaseInUvalue = currentUValue - newUvalueAfterInsulation;
        NSInteger degreeHours = [self.varCalc degreeHours];
        CGFloat costOfHeating = [self.varCalc costOfHeating];        
        NSInteger atticArea = [[self.dbFetch getValueOfVariableWithTitle:@"Vindsarea"] intValue];
        NSInteger savings = potentialDecreaseInUvalue * atticArea * degreeHours * costOfHeating * (0.001);
        savings = [self roundValue:savings];

        /*
         THE COST
         */
        
         
        //cost for peeps to come to the site
        NSInteger fixedCost;
        if (atticArea <= 100) {
            fixedCost = 2500;
        } else if (atticArea <= 200)
            fixedCost = 1500;
        else {
            fixedCost = 750;
        }
        
        CGFloat costForInsulation = ( 46 + 380 * extraPotentialInsulation ) * atticArea;
        
        BOOL needWindDistributors = [[self.dbFetch getValueOfVariableWithTitle:@"Möter taket vindsgolvet"] isEqualToString:@"Ja"] ? YES : NO;
        
        NSInteger costForWindDistributors = 0;
        if (needWindDistributors) {
            NSInteger costForASingleWindDistributor = 120;
            CGFloat lengthOfAWindDistributor = 1.2;
            //we need one for each side
            CGFloat lengthOfHouse = [[self.dbFetch getValueOfVariableWithTitle:@"Huslängd"] floatValue];
            costForWindDistributors = 2 * (lengthOfHouse / lengthOfAWindDistributor) * costForASingleWindDistributor;
        }
       
        NSInteger totalCost = fixedCost + costForInsulation + costForWindDistributors;
        totalCost = [self roundValue:totalCost];

        NSNumber *payback = [self payBackForHeating:YES withSavings:savings andCost:totalCost];
        
        /*
         SAVE
         */
        
        thisFinancial.cost = [NSNumber numberWithInt:totalCost];
        thisFinancial.payback = payback;
        thisFinancial.savings = [NSNumber numberWithInt:savings];
        thisFinancial.unitForTable = @"kr/år";
        
    }
    
    if ([title isEqualToString:@"Dra ner persienner"]) {
        
        /*
         THE SAVINGS
         */
        
        double currentWindowUValue = [self.varCalc currentWindowUValue];
        
        //if the window is very new, we probably don't get anything out of it
        double potentialDecreaseInUvalue = 0.9;
        if (currentWindowUValue <= 1.5) {
            potentialDecreaseInUvalue = 0.45;
        } else if (currentWindowUValue <= 1) {
            potentialDecreaseInUvalue = 0.2;
        }
        
        NSInteger degreeHours = [self.varCalc degreeHours];
        CGFloat costOfHeating = [self.varCalc costOfHeating];        
        
        CGFloat windowArea = [self.varCalc windowArea];
        
        NSInteger savings = potentialDecreaseInUvalue * windowArea * degreeHours * 1.0/3 * costOfHeating * (0.001);
        savings = [self roundValue:savings];

        
        /*
         THE COST
         */
        
        thisFinancial.cost = [NSNumber numberWithInt:0];
        thisFinancial.payback = nil;
        
        thisFinancial.savings =  [NSNumber numberWithInt:savings];
        thisFinancial.unitForTable = @"kr/år";
        
    }
    
    
    
}

-(NSNumber*)payBackForHeating:(BOOL)heating withSavings:(NSInteger)savings andCost:(NSInteger)cost
{
    
    CGFloat payBack = 0;
    CGFloat unitIncreasePerYear;
    
    if (heating) {
        unitIncreasePerYear = [self.varCalc heatingCostIncrease];
    } else {
        //ELECTRICITY!! 5.8% per year!!
        unitIncreasePerYear = 1.058;
    }
    
    
    if (cost <= 0 || savings <= 0 ) {
        return 0;
    }
    
    while (cost-savings >= 0) {
        cost -= savings;
        savings *= unitIncreasePerYear;
        payBack++;
    }
    
    //after we're done, add one last unit increase
    savings *= unitIncreasePerYear;
    
    //now we should be down to our last year, the decimal
    payBack += (float)cost/savings;
    
    return [NSNumber numberWithFloat:payBack];
    
}

-(NSInteger)roundValue:(NSInteger)value
{    
    NSInteger multiplier = 1000000;
    NSInteger divider;
    NSInteger minimumRounding = 100;
    while (multiplier != 1) {
        if (value/multiplier > 0) {
            divider = MAX(multiplier/100,minimumRounding);
            value += divider/2;
            value -= (value%divider);
            break;
        }
        multiplier /= 10;
    }

    return value;

}

-(EADatabaseFetcher*)dbFetch
{
    static EADatabaseFetcher *dbFetch;
    if (dbFetch == nil) {
        dbFetch = [[EADatabaseFetcher alloc] init];
    }
    return dbFetch;
}

-(EAVariableCalculator*)varCalc
{
    static EAVariableCalculator *calc;
    if (calc == nil) {
        calc = [[EAVariableCalculator alloc] init];
    }
    return calc;
}


@end
