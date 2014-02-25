//
//  EAVariableCalculator.m
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EAVariableCalculator.h"
#import "EAVariable+additions.h"
#import "EAValue.h"
#import "EADatabaseFetcher.h"

@interface EAVariableCalculator (Private)

-(CGFloat)outsideYearlyTemperature;

@end

@implementation EAVariableCalculator

@synthesize dbFetch = __databaseFetcher;
@synthesize citiesArray,windowsArray;

#pragma mark PRIVATE
-(CGFloat)outsideYearlyTemperature
{
    
    NSString *currentCity = [self.dbFetch getValueOfVariableWithTitle:@"Ort"];
    
    NSArray *arrayWithTemperatures = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:-1.2],
                                [NSNumber numberWithFloat:2.0],
                                [NSNumber numberWithFloat:1.3],
                                [NSNumber numberWithFloat:3.4],
                                [NSNumber numberWithFloat:3.9],
                                [NSNumber numberWithFloat:4.7],
                                [NSNumber numberWithFloat:5.0],
                                [NSNumber numberWithFloat:1.2],
                                [NSNumber numberWithFloat:2.7],
                                [NSNumber numberWithFloat:4.6],
                                [NSNumber numberWithFloat:2.9],
                                [NSNumber numberWithFloat:4.6],
                                [NSNumber numberWithFloat:5.7],
                                [NSNumber numberWithFloat:5.9],
                                [NSNumber numberWithFloat:6.6],
                                [NSNumber numberWithFloat:5.9],
                                [NSNumber numberWithFloat:6.8],
                                [NSNumber numberWithFloat:5.9],
                                [NSNumber numberWithFloat:6.6],
                                [NSNumber numberWithFloat:5.8],
                                [NSNumber numberWithFloat:7.9],
                                [NSNumber numberWithFloat:7.2],
                                [NSNumber numberWithFloat:7.0],
                                [NSNumber numberWithFloat:7.2],
                                [NSNumber numberWithFloat:7.6],
                                [NSNumber numberWithFloat:6.5],
                                [NSNumber numberWithFloat:6.1],
                                [NSNumber numberWithFloat:6.3],
                                [NSNumber numberWithFloat:6.5],
                                [NSNumber numberWithFloat:8.0],
                                [NSNumber numberWithFloat:7.8], nil];
    
    NSDictionary *temperatureDictionary = [[NSDictionary alloc] initWithObjects:arrayWithTemperatures forKeys:self.citiesArray];
    
    NSNumber *temperatureOfUsersCity = [temperatureDictionary objectForKey:currentCity];
    CGFloat numberToReturn = [temperatureOfUsersCity floatValue];
    
    return numberToReturn;
    
}


-(EADatabaseFetcher*)dbFetch
{
    if (__databaseFetcher == nil) {
        __databaseFetcher = [[EADatabaseFetcher alloc] init];
    }
    return __databaseFetcher;
}


#pragma mark PUBLIC

-(NSInteger)degreeHours
{


    NSArray *arrayFor5Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:80750],[NSNumber numberWithInt:73500],[NSNumber numberWithInt:66500],[NSNumber numberWithInt:59700],[NSNumber numberWithInt:53200],[NSNumber numberWithInt:47000],[NSNumber numberWithInt:41000],[NSNumber numberWithInt:35200],[NSNumber numberWithInt:29700],[NSNumber numberWithInt:24500],[NSNumber numberWithInt:19500], nil];
    
    NSArray *arrayFor6Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:87000],[NSNumber numberWithInt:79500],[NSNumber numberWithInt:72300],[NSNumber numberWithInt:65300],[NSNumber numberWithInt:58500],[NSNumber numberWithInt:52000],[NSNumber numberWithInt:45800],[NSNumber numberWithInt:39700],[NSNumber numberWithInt:33900],[NSNumber numberWithInt:28400],[NSNumber numberWithInt:23000], nil];
    
    NSArray *arrayFor7Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:93500],[NSNumber numberWithInt:85800],[NSNumber numberWithInt:78300],[NSNumber numberWithInt:71100],[NSNumber numberWithInt:64100],[NSNumber numberWithInt:57400],[NSNumber numberWithInt:50800],[NSNumber numberWithInt:44500],[NSNumber numberWithInt:38400],[NSNumber numberWithInt:32600],[NSNumber numberWithInt:26900], nil];
    
    NSArray *arrayFor8Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:100200],[NSNumber numberWithInt:92200],[NSNumber numberWithInt:84600],[NSNumber numberWithInt:77200],[NSNumber numberWithInt:69900],[NSNumber numberWithInt:62900],[NSNumber numberWithInt:56200],[NSNumber numberWithInt:49600],[NSNumber numberWithInt:43200],[NSNumber numberWithInt:37100],[NSNumber numberWithInt:31100], nil];
    
    NSArray *arrayFor9Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:107200],[NSNumber numberWithInt:99000],[NSNumber numberWithInt:91200],[NSNumber numberWithInt:83500],[NSNumber numberWithInt:76000],[NSNumber numberWithInt:68800],[NSNumber numberWithInt:61800],[NSNumber numberWithInt:54900],[NSNumber numberWithInt:48200],[NSNumber numberWithInt:42000],[NSNumber numberWithInt:35500], nil];
    
    NSArray *arrayFor10Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:114500],[NSNumber numberWithInt:106000],[NSNumber numberWithInt:98000],[NSNumber numberWithInt:90100],[NSNumber numberWithInt:82400],[NSNumber numberWithInt:74900],[NSNumber numberWithInt:67700],[NSNumber numberWithInt:60600],[NSNumber numberWithInt:53600],[NSNumber numberWithInt:47100],[NSNumber numberWithInt:40300], nil];
    
    NSArray *arrayFor11Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:121900],[NSNumber numberWithInt:113300],[NSNumber numberWithInt:105100],[NSNumber numberWithInt:97000],[NSNumber numberWithInt:89000],[NSNumber numberWithInt:81400],[NSNumber numberWithInt:73900],[NSNumber numberWithInt:66500],[NSNumber numberWithInt:59300],[NSNumber numberWithInt:52500],[NSNumber numberWithInt:45400], nil];
    
    NSArray *arrayFor12Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:129500],[NSNumber numberWithInt:120700],[NSNumber numberWithInt:112300],[NSNumber numberWithInt:104000],[NSNumber numberWithInt:95800],[NSNumber numberWithInt:88000],[NSNumber numberWithInt:80200],[NSNumber numberWithInt:72600],[NSNumber numberWithInt:65100],[NSNumber numberWithInt:58100],[NSNumber numberWithInt:50700], nil];
    
    NSArray *arrayFor13Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:137000],[NSNumber numberWithInt:128100],[NSNumber numberWithInt:119500],[NSNumber numberWithInt:111000],[NSNumber numberWithInt:102500],[NSNumber numberWithInt:94500],[NSNumber numberWithInt:86500],[NSNumber numberWithInt:78700],[NSNumber numberWithInt:70900],[NSNumber numberWithInt:63600],[NSNumber numberWithInt:55900], nil];
    
    NSArray *arrayFor14Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:144600],[NSNumber numberWithInt:135400],[NSNumber numberWithInt:126700],[NSNumber numberWithInt:118000],[NSNumber numberWithInt:109300],[NSNumber numberWithInt:101100],[NSNumber numberWithInt:92900],[NSNumber numberWithInt:84700],[NSNumber numberWithInt:76700],[NSNumber numberWithInt:69200],[NSNumber numberWithInt:61200], nil];
    
    NSArray *arrayFor15Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:152100],[NSNumber numberWithInt:142800],[NSNumber numberWithInt:133900],[NSNumber numberWithInt:125000],[NSNumber numberWithInt:116100],[NSNumber numberWithInt:107600],[NSNumber numberWithInt:99200],[NSNumber numberWithInt:90800],[NSNumber numberWithInt:82500],[NSNumber numberWithInt:74800],[NSNumber numberWithInt:66500], nil];
    
    NSArray *arrayFor16Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:159700],[NSNumber numberWithInt:150200],[NSNumber numberWithInt:141100],[NSNumber numberWithInt:132100],[NSNumber numberWithInt:122900],[NSNumber numberWithInt:114200],[NSNumber numberWithInt:105500],[NSNumber numberWithInt:96900],[NSNumber numberWithInt:88300],[NSNumber numberWithInt:80400],[NSNumber numberWithInt:71800], nil];
    
    NSArray *arrayFor17Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:167200],[NSNumber numberWithInt:157600],[NSNumber numberWithInt:148300],[NSNumber numberWithInt:139100],[NSNumber numberWithInt:129600],[NSNumber numberWithInt:120700],[NSNumber numberWithInt:111800],[NSNumber numberWithInt:103000],[NSNumber numberWithInt:94100],[NSNumber numberWithInt:85900],[NSNumber numberWithInt:77000], nil];
    
    NSArray *arrayFor18Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:174800],[NSNumber numberWithInt:165000],[NSNumber numberWithInt:155500],[NSNumber numberWithInt:146100],[NSNumber numberWithInt:136400],[NSNumber numberWithInt:127300],[NSNumber numberWithInt:118100],[NSNumber numberWithInt:109100],[NSNumber numberWithInt:99900],[NSNumber numberWithInt:91500],[NSNumber numberWithInt:82300], nil];
    
    NSArray *arrayFor19Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:182300],[NSNumber numberWithInt:172300],[NSNumber numberWithInt:162700],[NSNumber numberWithInt:153100],[NSNumber numberWithInt:143200],[NSNumber numberWithInt:133800],[NSNumber numberWithInt:124500],[NSNumber numberWithInt:115200],[NSNumber numberWithInt:105700],[NSNumber numberWithInt:97100],[NSNumber numberWithInt:87600], nil];
    
    NSArray *arrayFor20Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:189900],[NSNumber numberWithInt:179700],[NSNumber numberWithInt:169900],[NSNumber numberWithInt:160100],[NSNumber numberWithInt:149900],[NSNumber numberWithInt:140400],[NSNumber numberWithInt:130800],[NSNumber numberWithInt:121300],[NSNumber numberWithInt:111500],[NSNumber numberWithInt:102600],[NSNumber numberWithInt:92800], nil];
    
    NSArray *arrayFor21Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:197400],[NSNumber numberWithInt:187100],[NSNumber numberWithInt:177100],[NSNumber numberWithInt:167100],[NSNumber numberWithInt:156700],[NSNumber numberWithInt:146900],[NSNumber numberWithInt:137100],[NSNumber numberWithInt:127300],[NSNumber numberWithInt:117300],[NSNumber numberWithInt:108200],[NSNumber numberWithInt:98100], nil];
    
    NSArray *arrayFor22Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:205000],[NSNumber numberWithInt:194500],[NSNumber numberWithInt:184300],[NSNumber numberWithInt:174100],[NSNumber numberWithInt:163500],[NSNumber numberWithInt:153500],[NSNumber numberWithInt:143400],[NSNumber numberWithInt:133400],[NSNumber numberWithInt:123100],[NSNumber numberWithInt:113800],[NSNumber numberWithInt:103400], nil];
    
    NSArray *arrayFor23Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:212500],[NSNumber numberWithInt:201900],[NSNumber numberWithInt:191500],[NSNumber numberWithInt:181100],[NSNumber numberWithInt:170200],[NSNumber numberWithInt:160000],[NSNumber numberWithInt:149700],[NSNumber numberWithInt:139500],[NSNumber numberWithInt:128900],[NSNumber numberWithInt:119300],[NSNumber numberWithInt:108600], nil];
    
    NSArray *arrayFor24Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:220100],[NSNumber numberWithInt:209200],[NSNumber numberWithInt:198700],[NSNumber numberWithInt:188100],[NSNumber numberWithInt:177000],[NSNumber numberWithInt:166600],[NSNumber numberWithInt:156100],[NSNumber numberWithInt:145600],[NSNumber numberWithInt:134700],[NSNumber numberWithInt:124900],[NSNumber numberWithInt:113900], nil];
    
    NSArray *arrayFor25Degrees = [NSArray arrayWithObjects:[NSNumber numberWithInt:227600],[NSNumber numberWithInt:216600],[NSNumber numberWithInt:205900],[NSNumber numberWithInt:195100],[NSNumber numberWithInt:183800],[NSNumber numberWithInt:173100],[NSNumber numberWithInt:162400],[NSNumber numberWithInt:151700],[NSNumber numberWithInt:140500],[NSNumber numberWithInt:130500],[NSNumber numberWithInt:119200], nil];
    
    NSArray *arrayWithAllTemperatures = [NSArray arrayWithObjects:arrayFor5Degrees, arrayFor6Degrees, arrayFor7Degrees, arrayFor8Degrees, arrayFor9Degrees, arrayFor10Degrees, arrayFor11Degrees, arrayFor12Degrees, arrayFor13Degrees, arrayFor14Degrees, arrayFor15Degrees, arrayFor16Degrees, arrayFor17Degrees, arrayFor18Degrees, arrayFor19Degrees, arrayFor20Degrees, arrayFor21Degrees, arrayFor22Degrees, arrayFor23Degrees, arrayFor24Degrees, arrayFor25Degrees, nil];
    
    CGFloat outsideTemperature = [self outsideYearlyTemperature]+0.5;
    int outTemp = (int)outsideTemperature; //round to nearest integer
    outTemp = outTemp+2; //adjusted for index. index 0 in array is -2, so 0 becomes 2 etc

    NSString *insideTemperature = [self.dbFetch getValueOfVariableWithTitle:@"Inomhustemperatur"];
    int inTemp = [insideTemperature intValue]; 
    inTemp = inTemp-5; //adjusted for index as well. index 0 in array is 5, so degree 10 becomes index 5.
    
    NSNumber *degreeDays = [[arrayWithAllTemperatures objectAtIndex:inTemp] objectAtIndex:outTemp];
    
    return [degreeDays intValue];

}

-(CGFloat)currentWindowUValue
{
    //get current window choice (if it's not set, it will be estimated)
    //the name to get U-value
    
    NSString *currentWindows = [self.dbFetch getValueOfVariableWithTitle:@"Fönstertyp"];
    
    NSArray *arrayWithUValues = [NSArray arrayWithObjects:
                                      [NSNumber numberWithFloat:4.5],
                                      [NSNumber numberWithFloat:2.7],
                                      [NSNumber numberWithFloat:2.9],
                                    [NSNumber numberWithFloat:1.85],
                                    [NSNumber numberWithFloat:1.85],
                                      [NSNumber numberWithFloat:2.1],
                                      [NSNumber numberWithFloat:1.7],
                                      [NSNumber numberWithFloat:1.5], 
                                      [NSNumber numberWithFloat:1.0], nil];
    
    
    
    NSDictionary *windowDictionary = [[NSDictionary alloc] initWithObjects:arrayWithUValues forKeys:self.windowsArray];
    
    NSNumber *currentUValue = [windowDictionary objectForKey:currentWindows];
    
    return [currentUValue doubleValue];
    
}

-(NSArray*)citiesArray
{
    NSArray *arrayWithCities = [NSArray arrayWithObjects:
                                @"Kiruna",
                                @"Luleå",
                                @"Hällnäs",
                                @"Umeå",
                                @"Sundsvall",
                                @"Söderhamn",
                                @"Gävle",
                                @"Gisselås",
                                @"Östersund",
                                @"Rommehed",
                                @"Malung",
                                @"Falun",
                                @"Uppsala",
                                @"Norrtälje",
                                @"Stockholm",
                                @"Örebro",
                                @"Linköping",
                                @"Karlstad",
                                @"Vänersborg",
                                @"Skara",
                                @"Göteborg",
                                @"Halmstad",
                                @"Kalmar",
                                @"Visby",
                                @"Karlshamn",
                                @"Huskvarna",
                                @"Jönköping",
                                @"Borås",
                                @"Växjö",
                                @"Malmö",
                                @"Ystad", nil];
    
    return arrayWithCities;
}

-(NSArray*)windowsArray
{
    NSArray *arrayWithWindows = [NSArray arrayWithObjects:
                                @"1 glas",
                                @"1+1-glas i kopplade bågar",
                                @"2-glas isolerfönster",
                                @"1+1+1-glas",
                                @"1+2-glas isolerf.",
                                @"3-glas isolerf.",
                                @"3-glas isolerf. med gas",
                                @"3-glas isolerf. med LE-skikt", 
                                @"3-glas isolerf. med gas och LE",nil];
    
    return arrayWithWindows;
}

-(NSArray*)heatingSystems
{
    //if you change this, you have to check where it's used and modify!
    NSArray *namesOfSystem = [NSArray arrayWithObjects:
                              @"Fjärrvärme",
                              @"Oljepanna",
                              @"Biobränsle",
                              @"Elpanna",
                              @"Luft/luftvärmepump",
                              @"Övr. värmepump",
                              @"Elradiatorer",nil];
    
    return namesOfSystem;
}

-(NSDictionary*)heatingSystemsAndCost
{
 
    
    float costOfElectricity = [[self.dbFetch getValueOfVariableWithTitle:@"Elkostnad"] doubleValue];
    //ifrån "uppvärmning sverige energimarknadsinspektionen"
    //fjärrvärme enl. Svensk Fjärrvärme
    CGFloat costOfDistrictHeating = 0.76;
    CGFloat costOfOil = 1.15;
    CGFloat costOfBiofuel = 0.60;
    CGFloat costOfAirHeatpump = costOfElectricity;
    CGFloat costOfRestOfHeatpumps = costOfElectricity;
    CGFloat costOfElectricHeatingTank = costOfElectricity;
    CGFloat costOfElectricRadiators = costOfElectricity;
    
    NSArray *heatingCostsOfSystems = [NSArray arrayWithObjects:
                                      [NSNumber numberWithDouble:costOfDistrictHeating],
                                      [NSNumber numberWithDouble:costOfOil],
                                      [NSNumber numberWithDouble:costOfBiofuel],
                                      [NSNumber numberWithDouble:costOfElectricHeatingTank],
                                      [NSNumber numberWithDouble:costOfAirHeatpump],
                                      [NSNumber numberWithDouble:costOfRestOfHeatpumps],
                                      [NSNumber numberWithDouble:costOfElectricRadiators],nil];
   
    
    //looping through this every time. possible performance drain!
    NSMutableArray *correctedValuesOfHeatingCostOfSystems = [[NSMutableArray alloc] init];
    for (NSNumber *number in heatingCostsOfSystems)
    {
        
        CGFloat floatNumber = [number floatValue];
        floatNumber = [self roundFloat:floatNumber ToAmountOfDecimals:2];
        floatNumber = [self makeFloatFitPickerViewWithEvenDecimals:floatNumber];
        [correctedValuesOfHeatingCostOfSystems addObject:[NSNumber numberWithFloat:floatNumber]];

    }
    
    
    NSDictionary *dictionaryOfHeatingSystemsAndTheirCosts = [NSDictionary dictionaryWithObjects:correctedValuesOfHeatingCostOfSystems
                                                                                        forKeys:self.heatingSystems];
    return dictionaryOfHeatingSystemsAndTheirCosts;
}

-(NSArray*)fireplaces
{
    NSArray *namesOfFireplaces = [NSArray arrayWithObjects:
                                  @"Ingen eldstad",
                                  @"Öppen spis",
                                  @"Öppen spis m. spisinsats",
                                  @"Murspis",
                                  @"Modern kakel-/tegel-/täljstensugn",
                                  @"Traditionell kakel-/tegelugn",
                                  @"Gjutjärnskamin",
                                  @"Braskamin",
                                  @"Kakelkamin",nil];
    return namesOfFireplaces;
}


-(NSDictionary*)fireplacesAndTheirEfficiencies
{
    //efficiencies of different fire places
    CGFloat noFireplace = 0;
    CGFloat oppenSpis = (0.05+0.1)/2;
    CGFloat oppenSpisMedInsats = (0.5+0.6)/2;
    CGFloat murspis = (0.65+0.75)/2;
    CGFloat modernUgn = (0.67+0.75)/2;;
    CGFloat traditionellUgn = 0.80;
    CGFloat gjutjarn = (0.67+0.75)/2;;
    CGFloat braskamin = (0.65+0.85)/2;;
    CGFloat kakelkamin = (0.70+0.75)/2;;
    
    NSArray *fireplaceEfficiencies = [NSArray arrayWithObjects:
                                      [NSNumber numberWithDouble:noFireplace],
                                      [NSNumber numberWithDouble:oppenSpis],
                                      [NSNumber numberWithDouble:oppenSpisMedInsats],
                                      [NSNumber numberWithDouble:murspis],
                                      [NSNumber numberWithDouble:modernUgn],
                                      [NSNumber numberWithDouble:traditionellUgn],
                                      [NSNumber numberWithDouble:gjutjarn],
                                      [NSNumber numberWithDouble:braskamin],
                                      [NSNumber numberWithDouble:kakelkamin],nil];
    
    
    NSDictionary *fireplacesAndTheiEfficiencies = [NSDictionary dictionaryWithObjects:fireplaceEfficiencies forKeys:self.fireplaces];
    return fireplacesAndTheiEfficiencies;
}

-(CGFloat)heatingCostIncrease
{
    NSArray *arrayOfHeatingSystems = self.heatingSystems;
    
    
    CGFloat electricityIncrease = 1.058;
    //ifrån "uppvärmning sverige energimarknadsinspektionen"
    CGFloat increaseInCostOfDistrictHeating = 1.031;
    CGFloat increaseInCostOfOil = 1.059;
    CGFloat increaseInCostOfBiofuel = 1.053;
    CGFloat increaseInCostOfAirHeatpump = electricityIncrease;
    CGFloat increaseInCostOfOtherHeatpump = electricityIncrease;
    CGFloat increaseInCostOfElectricHeatingTank = electricityIncrease;
    CGFloat increaseInCostOfElectricRadiators = electricityIncrease;
    
    
    NSArray *increaseHeatingFactor = [NSArray arrayWithObjects:
                                      [NSNumber numberWithDouble:increaseInCostOfDistrictHeating], //FJV
                                      [NSNumber numberWithDouble:increaseInCostOfOil], //oil
                                      [NSNumber numberWithDouble:increaseInCostOfBiofuel], //pellets
                                      [NSNumber numberWithDouble:increaseInCostOfAirHeatpump], //electricity
                                      [NSNumber numberWithDouble:increaseInCostOfOtherHeatpump], //electricity
                                      [NSNumber numberWithDouble:increaseInCostOfElectricHeatingTank], //electricity
                                      [NSNumber numberWithDouble:increaseInCostOfElectricRadiators],nil]; //electricity
    
    
    NSDictionary *increaseInHeatingCosts = [NSDictionary dictionaryWithObjects:increaseHeatingFactor forKeys:arrayOfHeatingSystems];

    NSString *currentHeatingSystem = [self.dbFetch getValueOfVariableWithTitle:@"Uppvärmningssystem"];
    NSNumber *currentIncrease = [increaseInHeatingCosts objectForKey:currentHeatingSystem];
    return [currentIncrease floatValue];
}

-(CGFloat)currentAtticUValue
{
    NSInteger yearHouseWasBuilt = [[self.dbFetch getValueOfVariableWithTitle:@"Byggnadsår"] intValue];
    BOOL hasAtticBeenImproved = [[self.dbFetch getValueOfVariableWithTitle:@"Tilläggsisolerad"] isEqualToString:@"Ja"] ? YES : NO;
    
    CGFloat currentUValue;
    
    if (yearHouseWasBuilt <= 1920) {
        currentUValue = !hasAtticBeenImproved ? 0.6 : 0.25; 
    } 
    else if (yearHouseWasBuilt <= 1940)
    {
        currentUValue = !hasAtticBeenImproved ? 0.5 : 0.25; 
    }
    else if (yearHouseWasBuilt <= 1960)
    {
        currentUValue = !hasAtticBeenImproved ? 0.45 : 0.2;
    }
    else if (yearHouseWasBuilt <= 1975)
    {
        currentUValue = !hasAtticBeenImproved ? 0.3 : 0.18; 
    }
    else if (yearHouseWasBuilt <= 1985)
    {
        currentUValue = 0.18; 
    } else
    {
        currentUValue = 0.15;
    }
    
    return currentUValue;
    
}

-(NSString*)typeOfRadiators
{
    NSString *heatingSystem = [self.dbFetch getValueOfVariableWithTitle:@"Uppvärmningssystem"];
    
    NSString *typeOfRadiator;
    if ([heatingSystem isEqualToString:@"Fjärrvärme"] || 
        [heatingSystem isEqualToString:@"Oljepanna"] || 
        [heatingSystem isEqualToString:@"Biobränsle"] || 
        [heatingSystem isEqualToString:@"Övr. värmepump"] || 
        [heatingSystem isEqualToString:@"Elpanna"])
    {
        typeOfRadiator = @"vatten";
    } else if ([heatingSystem isEqualToString:@"Elradiatorer"])
    {
        typeOfRadiator = @"el";
    } else if ([heatingSystem isEqualToString:@"Övr. värmepump"] ||
               [heatingSystem isEqualToString:@"Luft/luftvärmepump"])
    {
        typeOfRadiator = @"";
    } else {
        NSAssert1(nil, @"Should never be here. Have we added some more heating systems?", nil);
    }
    
    return typeOfRadiator;
    
}


-(NSArray*)systemsOfRegulationForWaterHeating
{
    NSArray *namesOfRegulationSystems = [NSArray arrayWithObjects:
                                         @"Manuell shunt",
                                         @"Manuell shunt och termostater",
                                         @"Utomhusgivare",
                                         @"Utomhusgivare och termostater",
                                         @"Inomhusgivare", nil];
    
    return namesOfRegulationSystems;
    
}

-(NSArray*)systemsOfRegulationForElectricRadiators;
{
    NSArray *namesOfRegulationSystems = [NSArray arrayWithObjects:
                                         @"Bimetallstermostat",
                                         @"Central styrning",nil];

    return namesOfRegulationSystems;
    
}

-(NSDictionary*)regulatingSystemsForWaterHeatingAndEfficiencies
{
    NSArray *namesOfSystems = self.systemsOfRegulationForWaterHeating;
    
    CGFloat manualShunt = 1.3;
    CGFloat manualShuntAndThermostat = 1.25;
    CGFloat outsideController = 1.19;
    CGFloat outsideControllerAndThemostat = 1.14;
    CGFloat insideController = 1.07;
    
    NSArray * systemEfficiencies = [NSArray arrayWithObjects:
                                    [NSNumber numberWithDouble:manualShunt],
                                    [NSNumber numberWithDouble:manualShuntAndThermostat],
                                    [NSNumber numberWithDouble:outsideController],
                                    [NSNumber numberWithDouble:outsideControllerAndThemostat], 
                                    [NSNumber numberWithDouble:insideController],nil];     
    
    NSDictionary *systemsAndTheirEfficiencies = [NSDictionary dictionaryWithObjects:systemEfficiencies forKeys:namesOfSystems];
    
    return systemsAndTheirEfficiencies;
}

-(NSDictionary*)regulatingSystemsForElectricalRadiators
{
    NSArray *namesOfSystems = self.systemsOfRegulationForElectricRadiators;
    
    CGFloat bimetal = 1.17;
    CGFloat centralRegulator = 1.02;
    
    NSArray * systemEfficiencies = [NSArray arrayWithObjects:
                                    [NSNumber numberWithDouble:bimetal],
                                    [NSNumber numberWithDouble:centralRegulator],nil];     
    
    NSDictionary *systemsAndTheirEfficiencies = [NSDictionary dictionaryWithObjects:systemEfficiencies forKeys:namesOfSystems];
    
    return systemsAndTheirEfficiencies;
}

-(BOOL)areWaterThermostatsTooOld
{
    NSInteger yearOfThermostats = [[self.dbFetch getValueOfVariableWithTitle:@"Termostatsålder"] intValue];
    NSInteger currentYear = 2012;
    NSInteger ageOfThermostats = currentYear - yearOfThermostats;
    NSInteger maxYearBeforeTermostatsAreBad = 10;
    
    BOOL areTheyTooOld;
    
    if (ageOfThermostats > maxYearBeforeTermostatsAreBad) {
        areTheyTooOld = YES;
    } else {
        areTheyTooOld = NO;
    }

    return areTheyTooOld;
}

-(CGFloat)makeFloatFitPickerViewWithEvenDecimals:(CGFloat)number 
{
    NSUInteger scaledUpvalue = number * 100;

    NSUInteger leftOver = scaledUpvalue % 2;
    
    if (leftOver != 0) {
        number += 0.01;
    }
    return number;
}

-(CGFloat)roundFloat:(CGFloat)number ToAmountOfDecimals:(NSUInteger)decimals
{
    CGFloat scaler = powf(10, decimals);
    
    number = roundf(scaler * number) / scaler;
    
    return number;

}

-(CGFloat)windowArea
{
    NSInteger facadeArea = [[self.dbFetch getValueOfVariableWithTitle:@"Fasadarea"] intValue];
    NSInteger yearHouseWasBuilt = [[self.dbFetch getValueOfVariableWithTitle:@"Byggnadsår"] intValue];
    
    
    CGFloat windowFactor;
    
    if (yearHouseWasBuilt <= 1960) {
        windowFactor = 0.15;            
    } else
        if (yearHouseWasBuilt <= 1975) {
            windowFactor = 0.18;
        } else
            if (yearHouseWasBuilt <= 1985) {
                windowFactor = 0.17;
            } else
                if (yearHouseWasBuilt <= 1995) {
                    windowFactor = 0.18;
                } else
                {
                    windowFactor = 0.20;
                }
    CGFloat windowArea = windowFactor * facadeArea;
    
    return windowArea;
    
}

-(NSArray*)namesOfWoods
{
    NSArray *woods = [NSArray arrayWithObjects:@"Gran", 
                      @"Tall",
                      @"Asp",
                      @"Al",
                      @"Björk",
                      @"Bok",
                      @"Ek",
                      nil];
    return woods;
    
}


-(CGFloat)energyValueForChosenWood;
{
    NSArray *woodsArray = [self namesOfWoods];
    
    CGFloat megaJouleTokWh = 0.28;
    
    CGFloat energyValueOfChristmasTree = 18.5 * 400 * megaJouleTokWh;
    CGFloat energyValueOfPine = 19 * 410 * megaJouleTokWh;
    CGFloat energyValueOfAsh = 18.5 * 425 * megaJouleTokWh;
    CGFloat energyValueOfAl = 18.7 * 410 * megaJouleTokWh;
    CGFloat energyValueOfBirch = 18.27 * 490 * megaJouleTokWh;
    CGFloat energyValueOfBook = 18.4 * 600 * megaJouleTokWh;
    CGFloat energyValueOfOak = 18.4 * 575 * megaJouleTokWh;
    
    NSArray *energyValues = [NSArray arrayWithObjects:[NSNumber numberWithFloat:energyValueOfChristmasTree],
                             [NSNumber numberWithFloat:energyValueOfPine],
                             [NSNumber numberWithFloat:energyValueOfAsh],
                             [NSNumber numberWithFloat:energyValueOfAl],
                             [NSNumber numberWithFloat:energyValueOfBirch],
                             [NSNumber numberWithFloat:energyValueOfBook],
                             [NSNumber numberWithFloat:energyValueOfOak], nil];
    
    NSDictionary *energyValuesAndWoods = [NSDictionary dictionaryWithObjects:energyValues forKeys:woodsArray];
    NSString *currentlyChosenWood = [self.dbFetch getValueOfVariableWithTitle:@"Typ av ved"];
    NSNumber *energyValueOfChosenWood = [energyValuesAndWoods objectForKey:currentlyChosenWood];
    CGFloat energyValue = [energyValueOfChosenWood floatValue];
    return energyValue;
    
}

-(CGFloat)costOfHeating
{
    CGFloat costOfHeating = [[self.dbFetch getValueOfVariableWithTitle:@"Uppvärmningskostnad"] floatValue];
    NSString *systemOfHeating = [self.dbFetch getValueOfVariableWithTitle:@"Uppvärmningssystem"];
    
    BOOL heatingPumpIsInstalled;
    NSString *heatingPump = @"pump";
    if ([systemOfHeating rangeOfString:heatingPump].location == NSNotFound) {
        heatingPumpIsInstalled = NO;
    } else {
        heatingPumpIsInstalled = YES;
    }
    
    if (heatingPumpIsInstalled) {
        CGFloat efficiency = [[self.dbFetch getValueOfVariableWithTitle:@"Pumps värmefaktor"] floatValue];
        costOfHeating /= efficiency;
    }
    
    return costOfHeating;
}


@end
