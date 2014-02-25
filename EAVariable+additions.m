//
//  EAVariable+additions.m
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EAVariable+additions.h"
#import "EAValue.h"

//for lookup purposes
#import "EADatabaseFetcher.h"
#import "EAVariableCalculator.h"

//so as not to call a million variables recursively, we save them in a temp storage
#import "EATemporaryValueStorage.h"

@interface EAVariable (Private)

-(EADatabaseFetcher*)dbFetch;
-(EAVariableCalculator*)variableStorage;
@end

@implementation EAVariable (additions)


- (void)addSubitemsObject:(EAValue *)value {
    NSMutableSet* tempSet = [NSMutableSet setWithSet:self.valuesForPicker];
    [tempSet addObject:value];
    self.valuesForPicker = tempSet;
}

-(NSString*)theValue
{
    [self willAccessValueForKey:@"value"];
    EAValue *value = [self valueForKey:@"value"];
    [self didAccessValueForKey:@"value"];
    
    NSString* valueOfVariable = value.value;
    
    if ([valueOfVariable isEqualToString: @""] || valueOfVariable == nil) {
        
        NSString *nameOfVariable = self.title;
        
        //if value is saved in tempStorage, get it from that place
        valueOfVariable = [EATemporaryValueStorage valueForTitle:nameOfVariable];

        //if not in tempstorage, go and find it from default assumptions
        if (valueOfVariable == nil) {
            valueOfVariable = [self getDefaultValueForVariable:nameOfVariable];
        }
    }
    
    return valueOfVariable;
}

-(NSString*)getDefaultValueForVariable:(NSString *)nameOfVariable
{
    //this function should be called if the value is not set. So here we're working with assumptions
    //this is a general function for every variable, so it has to handle all of them.
    
    NSString *stringToReturn;
    
    
    /*
     The variables
     
     Byggnadsår
     Ort
     Kulturskyddat
     Boyta
     Antal plan
     Kallvind
     Antal boende
     
     */
    
    
    if ([nameOfVariable isEqualToString:@"Byggnadsår"])
    {
        stringToReturn = @"1960";
        
    }
    
    if ([nameOfVariable isEqualToString:@"Ort"])
    {
        stringToReturn = @"Stockholm";
        
    }

    
    if ([nameOfVariable isEqualToString:@"Boyta"])
    {
        EAVariable *houseAge = [self.dbFetch getVariableWithTitle:@"Byggnadsår"];
        NSString *houseAgeValue = [houseAge theValue];
        NSInteger yearHouseWasBuilt = [houseAgeValue intValue];
        
        if (yearHouseWasBuilt <= 1960) {
            stringToReturn = @"172";
        } else
            if (yearHouseWasBuilt <= 1975) {
                stringToReturn = @"163";
            } else
                if (yearHouseWasBuilt <= 1985) {
                    stringToReturn = @"142";
                } else
                    if (yearHouseWasBuilt <= 1995) {
                        stringToReturn = @"122";
                    } else
                    {
                        stringToReturn = @"145";
                    }
    }
   
    
    if ([nameOfVariable isEqualToString:@"Antal plan"])
    {
        stringToReturn = @"1 1/2";
        
    }
    
    if ([nameOfVariable isEqualToString:@"Antal boende"])
    {
        stringToReturn = @"2.6";
        
    }
    
    if ([nameOfVariable isEqualToString:@"Typ av vind"])
    {
        stringToReturn = @"Kallvind";
        
    }
    
    
    if ([nameOfVariable isEqualToString:@"Kulturskyddat"])
    {
        stringToReturn = @"Nej";
        
    }
    
    /*
     
     Uppvärmning
     El
     Vatten
     Uppvärmningskostnad
     Elkostnad
     Vattenkostnad
     
     */
    
    if ([nameOfVariable isEqualToString:@"Uppvärmning"])
    {
        NSString *systemOfHeating = [self.dbFetch getValueOfVariableWithTitle:@"Uppvärmningssystem"];
        
        BOOL heatingPumpIsInstalled;
        NSString *heatingPump = @"pump";
        if ([systemOfHeating rangeOfString:heatingPump].location == NSNotFound) {
            heatingPumpIsInstalled = NO;
        } else {
            heatingPumpIsInstalled = YES;
        }
        
        BOOL electricRadiatorsAreInstalled;
        NSString *electricRadiators = @"Elradiatorer";
        if ([systemOfHeating rangeOfString:electricRadiators].location == NSNotFound) {
            electricRadiatorsAreInstalled = NO;
        } else {
            electricRadiatorsAreInstalled = YES;
        }
        
        NSInteger amountOfElectricity = [[self.dbFetch getValueOfVariableWithTitle:@"El"] intValue];
        CGFloat houseInhabitants =  [[self.dbFetch getValueOfVariableWithTitle:@"Antal boende"] doubleValue];
        NSInteger estimatedElectricity = 2500 + houseInhabitants * 800;
        BOOL theyHaveEnteredElectricity = (amountOfElectricity != estimatedElectricity);
        
        NSInteger estimatedHeating = 0;
        if (heatingPumpIsInstalled && theyHaveEnteredElectricity)
        {
            CGFloat efficiencyOfPump = [[self.dbFetch getValueOfVariableWithTitle:@"Pumps värmefaktor"] floatValue];
            estimatedHeating = (amountOfElectricity - estimatedElectricity) * efficiencyOfPump;
        } else if (electricRadiatorsAreInstalled && theyHaveEnteredElectricity) {
            estimatedHeating = amountOfElectricity - estimatedElectricity;
        }
        
        if (estimatedHeating == 0) {
            NSInteger areaOfLiving =  [[self.dbFetch getValueOfVariableWithTitle:@"Boyta"] intValue];
            
            CGFloat averageAreaOfLivingInSweden = 159.6;
            CGFloat currentHouseFactorOfAverageAreaOfLiving = areaOfLiving/averageAreaOfLivingInSweden;
            
            NSInteger averageEnergyInAHouse = 23980;
            NSInteger averageEnergyForAHouseThisSize = averageEnergyInAHouse * currentHouseFactorOfAverageAreaOfLiving;
            
            CGFloat factorOfHeatingEnergy = 0.56;
            estimatedHeating = averageEnergyForAHouseThisSize * factorOfHeatingEnergy;
        }
        
        stringToReturn = [NSString stringWithFormat:@"%d",estimatedHeating];
    }
    
    if ([nameOfVariable isEqualToString:@"El"])
    {
        CGFloat houseInhabitants =  [[self.dbFetch getValueOfVariableWithTitle:@"Antal boende"] doubleValue];
        
        NSInteger estimatedeElectricity = 2500 + houseInhabitants * 800;
        
        stringToReturn = [NSString stringWithFormat:@"%d",estimatedeElectricity];
    }
    
    if ([nameOfVariable isEqualToString:@"Vatten"])
    {
        CGFloat houseInhabitants =  [[self.dbFetch getValueOfVariableWithTitle:@"Antal boende"] doubleValue];
        
        CGFloat estimatedWarmWater = 16*houseInhabitants;
        CGFloat estimatedTotalWater  = estimatedWarmWater * 3.5;
        
        stringToReturn = [NSString stringWithFormat:@"%.1f",estimatedTotalWater];
    }
    
    if ([nameOfVariable isEqualToString:@"Uppvärmningskostnad"])
    {
        NSString *systemChosen = [self.dbFetch getValueOfVariableWithTitle:@"Uppvärmningssystem"];
        NSNumber *costOfHeating = [self.variableStorage.heatingSystemsAndCost objectForKey:systemChosen];
        CGFloat cost = [costOfHeating floatValue];

        stringToReturn = [NSString stringWithFormat:@"%.2f",cost];
    }
    
    if ([nameOfVariable isEqualToString:@"Elkostnad"])
    {        
        //enligt uppvärmning i Sverige 
        float costOfElectricity = 1.20;
        stringToReturn = [NSString stringWithFormat:@"%.2f",costOfElectricity];
    }
    
    if ([nameOfVariable isEqualToString:@"Vattenkostnad"])
    {
        //2005 var rörliga genomsnittpriset 15kr/kbm.
        float costOfWater  = 17.00;
        
        stringToReturn = [NSString stringWithFormat:@"%.2f",costOfWater];
    }
    
    
    
   
    
    /*
     
     Inomhustemperatur
     Uppvärmningssystem
     Ålder uppvärmningssystem
     Uppvärmningens styrsystem
     Elradiator styrsystem
     Antal element
     Termostatsålder
     Cirkulationspump
     Typ av eldstad
     Vedkostnad
     Kubikmått
     Typ av ved
     
     */
    
    if ([nameOfVariable isEqualToString:@"Inomhustemperatur"])
    {
        stringToReturn = @"22";
    }
    
    if ([nameOfVariable isEqualToString:@"Uppvärmningssystem"])
    {
        stringToReturn = @"Elpanna";
    }
    
    if ([nameOfVariable isEqualToString:@"Pumps värmefaktor"])
    {
        stringToReturn = @"3.00";
    }
    
    if ([nameOfVariable isEqualToString:@"Ålder uppvärmningssystem"])
    {
        NSString *currentHeatingSystem = [self.dbFetch getValueOfVariableWithTitle:@"Uppvärmningssystem"];
        
        NSInteger ageOfHeatingSystem;
        if ([currentHeatingSystem isEqualToString:@"Elradiatorer"]) {
            ageOfHeatingSystem = 1980;
        } else {
            ageOfHeatingSystem = 2005;
        }
        stringToReturn = [NSString stringWithFormat:@"%d",ageOfHeatingSystem];
    }
    
    if ([nameOfVariable isEqualToString:@"Uppvärmningens styrsystem"])
    {
        NSArray *namesOfRegulatorSystems = [self.variableStorage systemsOfRegulationForWaterHeating];
        NSString *theMostUsedRegulatingSystem = [namesOfRegulatorSystems objectAtIndex:3]; //Utomhusgivare och termostat
        
        stringToReturn = theMostUsedRegulatingSystem;
    }
    
    if ([nameOfVariable isEqualToString:@"Elradiator styrsystem"])
    {
        NSInteger ageOfHeatingSystem = [[self.dbFetch getValueOfVariableWithTitle:@"Ålder uppvärmningssystem"] intValue];
        NSInteger yearThatBimetallWasStoppedBeingUsed = 1980;
        
        NSString *currentRegulatingSystem;
        if (ageOfHeatingSystem <= yearThatBimetallWasStoppedBeingUsed) {
            currentRegulatingSystem = @"Bimetallstermostat"; 
        } else {
            currentRegulatingSystem = @"Central styrning";
        }
        stringToReturn = currentRegulatingSystem;
    }
    
    
    if ([nameOfVariable isEqualToString:@"Antal element"])
    {
        CGFloat exampleHousArea = 440.0;
        CGFloat exampleHouseAmountOfRadiators = 27.0;
        CGFloat radiatorsPerSqm = exampleHouseAmountOfRadiators / exampleHousArea;
        CGFloat sizeOfThisHouse = [[self.dbFetch getValueOfVariableWithTitle:@"Boyta"] floatValue];
        CGFloat radiatorsInHouse = sizeOfThisHouse * radiatorsPerSqm;
        radiatorsInHouse = floorf(radiatorsInHouse);
        
        stringToReturn = [NSString stringWithFormat:@"%.0f",radiatorsInHouse];
    }
    
    if ([nameOfVariable isEqualToString:@"Termostatsålder"])
    {
        NSInteger mostCommonAge = 1995;
        stringToReturn = [NSString stringWithFormat:@"%d",mostCommonAge];
    }
    
    if ([nameOfVariable isEqualToString:@"Cirkulationspump"])
    {
        NSInteger mostCommonAge = 1995;
        stringToReturn = [NSString stringWithFormat:@"%d",mostCommonAge];
    }
    
    if ([nameOfVariable isEqualToString:@"Typ av eldstad"])
    {
        NSString *nameOfNoFireplace = [[self.variableStorage fireplaces] objectAtIndex:0];
        stringToReturn = nameOfNoFireplace;
    }
    
    if ([nameOfVariable isEqualToString:@"Vedkostnad"])
    {
        stringToReturn = @"400";
    }
    
    if ([nameOfVariable isEqualToString:@"Kubikmått"])
    {
        stringToReturn = @"Stjälpt";
    }
    
    if ([nameOfVariable isEqualToString:@"Typ av ved"])
    {
        stringToReturn = @"Björk";
    }
    
    
    
    /*     
     Fasadarea
     Tätningslistskick
     Fönstertyp
     Skick på ramar
     
     */
    
    
    if ([nameOfVariable isEqualToString:@"Fasadarea"])
    {
        NSInteger areaOfLiving =  [[self.dbFetch getValueOfVariableWithTitle:@"Boyta"] intValue];
        NSInteger yearHouseWasBuilt = [[self.dbFetch getValueOfVariableWithTitle:@"Byggnadsår"] intValue];
        
        CGFloat facadeFactor;
        
        if (yearHouseWasBuilt <= 1960) {
            facadeFactor = 0.92;            
        } else
            if (yearHouseWasBuilt <= 1975) {
                facadeFactor = 0.73;
            } else
                if (yearHouseWasBuilt <= 1985) {
                    facadeFactor = 0.81;
                } else
                    if (yearHouseWasBuilt <= 1995) {
                        facadeFactor = 0.85;
                    } else
                    {
                        facadeFactor = 0.95;
                    }
        CGFloat facadeArea = facadeFactor * areaOfLiving;
        stringToReturn = [NSString stringWithFormat:@"%d",(int)facadeArea];
    }
    
    
    if ([nameOfVariable isEqualToString:@"Tätningslister"])
    {
        NSString *windowsCondition = @"Bra skick";
        stringToReturn = windowsCondition;
    }
    
    if ([nameOfVariable isEqualToString:@"Skick på bågar"])
    {
        NSString *windowsCondition = @"Bra skick";
        stringToReturn = windowsCondition;
    }
    
    if ([nameOfVariable isEqualToString:@"Fönstertyp"])
    {
        NSString *houseAgeValue = [self.dbFetch getValueOfVariableWithTitle:@"Byggnadsår"];
        NSInteger yearHouseWasBuilt = [houseAgeValue intValue];
        
        NSArray *arrayWithValues = self.variableStorage.windowsArray;
        
        NSString *installedWindows;
        
        if (yearHouseWasBuilt <= 1970) {
            installedWindows = [arrayWithValues objectAtIndex:1];
        } else
            if (yearHouseWasBuilt <= 1975) {
                installedWindows = [arrayWithValues objectAtIndex:2];
            } else
                if (yearHouseWasBuilt <= 1980) {
                    installedWindows = [arrayWithValues objectAtIndex:3];
                } else
                    if (yearHouseWasBuilt <= 1985) {
                        installedWindows = [arrayWithValues objectAtIndex:4];
                    } else
                        if (yearHouseWasBuilt <= 1995) {
                            installedWindows = [arrayWithValues objectAtIndex:5];
                        } else
                        {
                            installedWindows = [arrayWithValues objectAtIndex:6];
                        }        
        
        stringToReturn = installedWindows;
    }
    
    
    /*
     
     Vindsarea
     TIlläggsisolerad
     Nuvarande isolering
     Når taket vägg
     Huslängd
     
     
     */
    
    if ([nameOfVariable isEqualToString:@"Vindsarea"])
    {
        CGFloat areaOfLiving = [[self.dbFetch getValueOfVariableWithTitle:@"Boyta"] floatValue];
        NSString *numberOfFloors = [self.dbFetch getValueOfVariableWithTitle:@"Antal plan"];
        
        CGFloat sizeOfAttic;
        
        if([numberOfFloors isEqualToString:@"1 1/2"]) {
            sizeOfAttic = areaOfLiving / 3.0f;
        }
        else  if([numberOfFloors isEqualToString:@"2 1/2"]) {
            sizeOfAttic = areaOfLiving / 5.0f;
        } else {
            sizeOfAttic = areaOfLiving / [numberOfFloors floatValue];
        }

        stringToReturn = [NSString stringWithFormat:@"%d",(int)sizeOfAttic];
    }
    
    if ([nameOfVariable isEqualToString:@"Tilläggsisolerad"])
    {
        NSString *hasBeenExtraInsulatedBefore = @"Nej";
        stringToReturn = hasBeenExtraInsulatedBefore;
    }
    
    if ([nameOfVariable isEqualToString:@"Nuvarande isolering"])
    {
        NSInteger yearHouseWasBuilt = [[self.dbFetch getValueOfVariableWithTitle:@"Byggnadsår"] intValue];
        BOOL hasAtticBeenImproved = [[self.dbFetch getValueOfVariableWithTitle:@"Tilläggsisolerad"] intValue] ? YES : NO;
        
        CGFloat currentThickness;
        
        if (yearHouseWasBuilt <= 1920) {
            currentThickness = 10;
        } 
        else if (yearHouseWasBuilt <= 1939)
        {
            currentThickness = 13;
        }
        else if (yearHouseWasBuilt <= 1975)
        {
            currentThickness = 20;
        }
        else
        {
            currentThickness = 50; 
        }
        if (hasAtticBeenImproved) {
            currentThickness+=15;
        }
        
        stringToReturn = [NSString stringWithFormat:@"%f",currentThickness];
        
    }
    
    if ([nameOfVariable isEqualToString:@"Möter taket vindsgolvet"])
    {
        NSString *numberOfFloors = [self.dbFetch getValueOfVariableWithTitle:@"Antal plan"];
        
        NSString *doWeNeedWindDistributors;

        if ([numberOfFloors isEqualToString:@"1 1/2"]) {
            doWeNeedWindDistributors = @"Nej";
        } else {
            doWeNeedWindDistributors = @"Ja";
        }
        
        stringToReturn = doWeNeedWindDistributors;
    }
    
    if ([nameOfVariable isEqualToString:@"Huslängd"])
    {
        
        CGFloat areaOfLiving = [[self.dbFetch getValueOfVariableWithTitle:@"Boyta"] floatValue];
        NSString *numberOfFloors = [self.dbFetch getValueOfVariableWithTitle:@"Antal plan"];
        
        //we assume the length is 2  times longer than the width.
        //as such, if x is the length, x*0.5x = areaOfTopFloor. x = sqrt(areaOfTopFloor/0.5).
        //in 1 1/2 we assume the top floor is half the size of the first floor, and as such x*x = areaOfTopFloor.
        CGFloat lengthOfHouse;
        CGFloat areaOfTopFloor;
        
        if ([numberOfFloors isEqualToString:@"1"]) {
            areaOfTopFloor = areaOfLiving;
            lengthOfHouse = sqrtf(areaOfTopFloor/0.5f);
        } else if([numberOfFloors isEqualToString:@"1 1/2"]) {
            areaOfTopFloor = areaOfLiving/3.0f;
            lengthOfHouse = sqrtf(areaOfTopFloor);
        } else if([numberOfFloors isEqualToString:@"2"]) {
            areaOfTopFloor = areaOfLiving/2.0f;
            lengthOfHouse = sqrtf(areaOfTopFloor/0.5f);
        }
        
        stringToReturn = [NSString stringWithFormat:@"%.1f",lengthOfHouse];
    }
    

    
    
    
    /*
     Antal LED
     Antal lågenergilampor
     Antal glödlampor
     
     
     Elhanddukstork
     Handdukstork effekt
     Styrsystem handdukstork
     
    
     */
    
    if ([nameOfVariable isEqualToString:@"Antal lampor"])
    {
        NSString *numberOfLamps = @"50";
        stringToReturn = numberOfLamps;
    }
    
    
    
    if ([nameOfVariable isEqualToString:@"Elhanddukstork"])
    {
        NSString *numberOfDriers = @"0";
        stringToReturn = numberOfDriers;
    }
    
    if ([nameOfVariable isEqualToString:@"Handdukstork effekt"])
    {
        NSString *powerOfDrier = @"80";
        stringToReturn = powerOfDrier;
    }
    
    if ([nameOfVariable isEqualToString:@"Handdukstork styrning"])
    {
        NSString *windowsCondition = @"Manuell";
        stringToReturn = windowsCondition;
    }
    
    
    
    /*

    Tvågrepps dusch
    Engrepps dusch
    Resurseffektiv dusch
    Tvågrepps tvättställ
    Engrepps tvättställ
    Resurseffektiv tvättställ
    Tvågrepps kökskran
    Engrepps kökkskran
    Resurseffektiv kökskran
    */
     
    
    if ([nameOfVariable isEqualToString:@"Tvågrepps kökskranar"])
    {
        NSString *doWeNeedWindDistributors = @"0";
        stringToReturn = doWeNeedWindDistributors;
    }
    
    if ([nameOfVariable isEqualToString:@"Tvågrepps tvättställ"])
    {
        NSString *doWeNeedWindDistributors = @"0";
        stringToReturn = doWeNeedWindDistributors;
    }
    
    if ([nameOfVariable isEqualToString:@"Tvågrepps duschar"])
    {
        NSString *doWeNeedWindDistributors = @"0";
        stringToReturn = doWeNeedWindDistributors;
    }
    
    if ([nameOfVariable isEqualToString:@"Engrepps kökskranar"])
    {
        NSString *doWeNeedWindDistributors = @"1";
        stringToReturn = doWeNeedWindDistributors;
    }
    
    if ([nameOfVariable isEqualToString:@"Engrepps tvättställ"])
    {
        NSString *doWeNeedWindDistributors = @"3";
        stringToReturn = doWeNeedWindDistributors;
    }
    
    if ([nameOfVariable isEqualToString:@"Engrepps duschar"])
    {
        NSString *doWeNeedWindDistributors = @"1";
        stringToReturn = doWeNeedWindDistributors;
    }
    
    if ([nameOfVariable isEqualToString:@"Resurseffektiva kökskranar"])
    {
        NSString *doWeNeedWindDistributors = @"0";
        stringToReturn = doWeNeedWindDistributors;
    }
    
    if ([nameOfVariable isEqualToString:@"Resurseffektiva tvättställ"])
    {
        NSString *doWeNeedWindDistributors = @"0";
        stringToReturn = doWeNeedWindDistributors;
    }
    
    if ([nameOfVariable isEqualToString:@"Resurseffektiva duschar"])
    {
        NSString *doWeNeedWindDistributors = @"0";
        stringToReturn = doWeNeedWindDistributors;
    }
     
     /*
     use this
     
     if ([nameOfVariable isEqualToString:@""])
     {
     
     }
     
     */
    
    if (stringToReturn == nil) {
        NSLog(@"Didn't find value for: %@",nameOfVariable);
        NSAssert1(stringToReturn != nil, @"StringToReturn is nil. didn't find value", nil);

    }
    
    //we're here if we havent saved the value before. So save save it now
    [EATemporaryValueStorage addValue:stringToReturn forVariableTitle:nameOfVariable];
    
    return stringToReturn;
}

-(EADatabaseFetcher*)dbFetch
{
    static EADatabaseFetcher *dbFetch;
    if (dbFetch == nil) {
        dbFetch = [[EADatabaseFetcher alloc] init];
    }
    return dbFetch;
}

-(EAVariableCalculator*)variableStorage
{
    static EAVariableCalculator *calc;
    if (calc == nil) {
        calc = [[EAVariableCalculator alloc] init];
    }
    return calc;
}
@end
