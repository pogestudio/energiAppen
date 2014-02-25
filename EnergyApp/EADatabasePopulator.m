//
//  EADatabasePopulator.m
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EADatabasePopulator.h"
#import "EAVariable+additions.h"
#import "EAVariableGroup+addObjects.h"
#import "EAValue.h"
#import "EASavings.h"
#import "EAInfoToUser.h"
#import "EAFinancial.h"
#import "EAVariableCondition.h"

//this is for linking of cities array
#import "EAVariableCalculator.h"

//for save function
#import "EAAppDelegate.h"


typedef enum {
    TypeOfVariableString = 0,
    TypeOfVariableInteger,
    TypeOfVariableDouble,
    TypeOfVariableBool,
} TypeOfVariable;


@interface EADatabasePopulator ()
{
    EAVariableGroup *_recentlyCreatedGroup;
    EAVariable *_recentlyCreatedVariable;
    NSUInteger _sortKeyForPickerValues;
}
-(BOOL)doesDBContainEntries;
-(void)populateEntireDB;
-(void)addVariables;
-(void)addSavings;
-(void)addInfo;

//savings related
-(void)addSavingsWithTitle:(NSString *)title infoForAudit:(NSString *)infoForAudit infoForUser:(NSString *)infoForUser;
-(void)addNewFinancialToSavings:(EASavings*)savingsToAddTo;


//variable related
-(EAVariable*)createNewVariableWithTitle:(NSString*)title information:(NSString*)info inputDescription:(NSString*)inputDesc whereToFindIt:(NSString*)location sortKey:(int)sortK unitForTable:(NSString*)unit usesPickerView:(BOOL)isUsingPickerView usesTextField:(BOOL)isUsingTextField usesBool:(BOOL)isUsingBool sectionForTable:(int)section sectionName:(NSString*)sName lowerBound:(int)lB upperBound:(int)uB;
-(EAVariableGroup*)createNewVariableGroupWithTitle:(NSString*)title sectionForTable:(int)section sortKey:(int)sortKey;
-(EAValue*)createNewValueForPicker:(BOOL)forPicker WithValue:(NSString*)value typeOfValue:(TypeOfVariable)typeOfValue;
-(void)createConditionForPrevousVariableWithTitleEqualTo:(NSString*)varTitle andValueCondition:(NSString*)condition;


//info related

-(void)fillPickerWithValuesFrom:(double)fromThis To:(double)toThis withInterval:(double)interval;
-(void)fillPickerWithStringsFromArray:(NSArray*)array;

@end


@implementation EADatabasePopulator

@synthesize managedObjectContext = __managedObjectContext;
@synthesize variableStorage = __variableStorage;

-(void)checkDatabaseAndPopulateIfNeeded
{
    //1 check if the database have items
    //2 if it hasn't, then create all the items and insert them into the database
    
    
    //1
    BOOL dBAlreadyContainItems = [self doesDBContainEntries];
    
    //2
    if (!dBAlreadyContainItems) {
        [self populateEntireDB];
    }
    
    
}

-(BOOL)doesDBContainEntries
{
    
    //1 try to fetch a single EAVariable from the database
    //2 evaluate if we have anything
    //3 return bool
    
    
    //1
    NSManagedObjectContext *moc = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"EAVariable" inManagedObjectContext:moc];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:1];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortKey" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:@"An error ocurred: PerformFetch @ DB"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok :("
                                              otherButtonTitles: nil];
        [alert show];
        //abort();
}
    
    ///2
    NSInteger numberOfFetchedObjects = [aFetchedResultsController.fetchedObjects count];
    BOOL doWeHaveAnItemInTheDatabase = numberOfFetchedObjects ? YES : NO;
    
    //3
    return doWeHaveAnItemInTheDatabase;
}

-(void)populateEntireDB
{
    //0 set the pickervaluessortkey to 0. we'll use it to add all the pickers so we can get them in the correct order, even though they're not ordered sets
    //1 add the variables
    //2 add the energy saving suggestions
    //3 add the tip for expert
    
    //0
    _sortKeyForPickerValues = 0;
    
    //1
    [self addVariables];
    
    //2
    [self addSavings];
    
    //3
    [self addInfo];
    
    EAAppDelegate *appDelegate = (EAAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate saveContext];
    
}

#pragma mark Variable functions

-(void)addVariables
{
    //1 create the house
    //2 create the group
    //3 name the group
    //4 add group to house
    //5 create variables and add them to group
    //6 create values and add them to pickerValues
    //7 repeat until all is done
    
    //1
    theHouse = [self createNewVariableGroupWithTitle:@"Huset"
                                     sectionForTable:0
                                             sortKey:0];    
    
    NSInteger sectionSortKey;
    NSInteger variableSortKey;
    
    /*
     
     -------------------------------------------
     Section 1!!
     -------------------------------------------
     
     */
    
    sectionSortKey = 0;
    variableSortKey = 0;
    
    [self createNewVariableGroupWithTitle:@"Grundinformation"
                          sectionForTable:0
                                  sortKey:sectionSortKey++];
    
    //Variable number 1! ---------------------
    
    [self createNewVariableWithTitle:@"Byggnadsår"
                         information:@"Året som huset byggdes"
                    inputDescription:@"Året som huset byggdes"
                       whereToFindIt:@"Ritningar"
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Husfakta"
                          lowerBound:0
                          upperBound:0];
    
    //add a value before the regular 1891-2012
    [self createNewValueForPicker:YES WithValue:@"1890 eller äldre"
                      typeOfValue:TypeOfVariableString];
    
    [self fillPickerWithValuesFrom:1891
                                To:2012 
                      withInterval:1];
    
    
    //Variable number 2! ---------------------
    
    [self createNewVariableWithTitle:@"Ort"
                         information:@"Välj den stad som är närmast den ort där huset ligger. Orterna representerar ett antal av Sveriges mätstationer för väderlek och presenteras i ungefärlig nord- till sydlig placering"
                    inputDescription:@"Ange närmaste ort"
                       whereToFindIt:@"Karta"
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@""
                          lowerBound:0
                          upperBound:0];
    
    //array copied from EAVariableCalculator
    NSArray *arrayWithCities = self.variableStorage.citiesArray;
    
    [self fillPickerWithStringsFromArray:arrayWithCities];
    
    //Variable number 3! ---------------------
    
    [self createNewVariableWithTitle:@"Boyta"
                         information:@"Ange den totala golvarean uppvärmt över 10 grader i huset, minus eventuellt varmgarage. Använd Atemp om ni har tillgång till det. Bortse ifrån kallgarage, pannrum och andra ouppvärmda ytor.\n\nNi kan även göra en uppskattning baserad på ritningen."
                    inputDescription:@"Uppvärmd golvarea"
                       whereToFindIt:@"Ritningar, fastighetstaxering"
                             sortKey:variableSortKey++
                        unitForTable:@"kvm"
                      usesPickerView:NO
                       usesTextField:YES
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Husfakta"
                          lowerBound:0
                          upperBound:800];
    
    
    //New Variable! ---------------------
    
    [self createNewVariableWithTitle:@"Antal boende"
                         information:@"Antalet personer, inklusive småbarn, som normalt vistas i huset"
                    inputDescription:@"Antal personer i huset"
                       whereToFindIt:@"Husägare"
                             sortKey:variableSortKey++
                        unitForTable:@"st"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Husfakta"
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithValuesFrom:1 To:7 withInterval:1];
    
    //New Variable!! ---------------------
    
    [self createNewVariableWithTitle:@"Typ av vind"
                         information:@"Om er vind ej är uppvärmd, d.v.s. det isolerande lagret är på vindsgolvet, anses den vara kallvind. Är den inredd och/eller håller rumstemperatur året runt (det isolerande lagret ligger mot yttertaket) är det en varmvind."
                    inputDescription:@"Typ av vind"
                       whereToFindIt:@"Ritningar, visuell inspektering"
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Husfakta"
                          lowerBound:0
                          upperBound:0];
    
    [self createNewValueForPicker:YES WithValue:@"Kallvind" typeOfValue:TypeOfVariableString];
    [self createNewValueForPicker:YES WithValue:@"Varmvind" typeOfValue:TypeOfVariableString];
    [self createNewValueForPicker:YES WithValue:@"Ingen vind" typeOfValue:TypeOfVariableString];
    
    //New Variable!! ---------------------
    
    [self createNewVariableWithTitle:@"Antal plan"
                         information:@"Ange vilken typ av villa bostaden är. Enkelt sagt är ett 1 och 1/2 planshus ett hus där ytan av en vånging är större än den andra våningen"
                    inputDescription:@"Antal våningsplan"
                       whereToFindIt:@"Ritningar"
                             sortKey:variableSortKey++
                        unitForTable:@"plan"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Husfakta"
                          lowerBound:0
                          upperBound:0];
    
    [self createNewValueForPicker:YES WithValue:@"1" typeOfValue:TypeOfVariableString];
    [self createNewValueForPicker:YES WithValue:@"1 1/2" typeOfValue:TypeOfVariableString];
    [self createNewValueForPicker:YES WithValue:@"2" typeOfValue:TypeOfVariableString];
    [self createNewValueForPicker:YES WithValue:@"2 1/2" typeOfValue:TypeOfVariableString];
    [self createNewValueForPicker:YES WithValue:@"3" typeOfValue:TypeOfVariableString];
    
    
    NSString *conditionVariableTitle = @"Typ av vind";
    NSString *coldAttic = @"Kallvind";
    NSString *condition = [NSString stringWithFormat:@"(value.value = \'%@\')", coldAttic]; 
    [self createConditionForPrevousVariableWithTitleEqualTo:conditionVariableTitle andValueCondition:condition];
    
    
    //Variable number 2! ---------------------
    
    [self createNewVariableWithTitle:@"Kulturskyddat"
                         information:@"K-märkning står för kulturskyddad egendom. Om Er byggnad är kulturskyddad får Ni inte göra ingrepp som syns utifrån utan att få ett godkännande från kommunen"
                    inputDescription:@"Kulturminnesskyddat eller ej"
                       whereToFindIt:@"Ritningar, kommunen"
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Husfakta"
                          lowerBound:0
                          upperBound:0];
    
    [self createNewValueForPicker:YES WithValue:@"Nej" typeOfValue:TypeOfVariableString];
    [self createNewValueForPicker:YES WithValue:@"Ja" typeOfValue:TypeOfVariableString];
    
    /*
     
     -------------------------------------------
     Section 2!!
     -------------------------------------------
     
     */
    
    
    [self createNewVariableGroupWithTitle:@"Faktura"
                          sectionForTable:0
                                  sortKey:sectionSortKey++];
    
    variableSortKey = 0;
    //Variable number 1! ---------------------
    
    [self createNewVariableWithTitle:@"Uppvärmningskostnad"
                         information:@"Pris per uppvärmd kWh, ange endast rörlig kostnad. Ange ett medelvärde över senaste året om det inte är bundet. Rörlig kostnad motsvarar hur mycket Ni skulle spara om Ni köpte en kWh mindre. Om ni använder värmepump eller elradiator kan ni lämna detta värde tomt, i så fall antas driftkostnaden till samma värde som Elektriciteten."
                    inputDescription:@"Kostnad per uppvärmd kWh"
                       whereToFindIt:@"Faktura från energibolaget"
                             sortKey:variableSortKey++
                        unitForTable:@"kr/kWh"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Energikostnad"
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithValuesFrom:0.30
                                To:3.00
                      withInterval:0.02];
    
    [self createNewVariableWithTitle:@"Elkostnad"
                         information:@"Pris per köpt kWh, ange endast rörlig kostnad. Ange ett medelvärde över senaste året om det inte är bundet. Rörlig kostnad motsvarar hur mycket Ni skulle spara om Ni sänkte er elanvändning med en kWh."
                    inputDescription:@"Kostnad per kWh el"
                       whereToFindIt:@"Faktura från energibolaget"
                             sortKey:variableSortKey++
                        unitForTable:@"kr/kWh"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Energikostnad"
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithValuesFrom:0.50
                                To:3.00
                      withInterval:0.02];
    
    [self createNewVariableWithTitle:@"Vattenkostnad"
                         information:@"Pris per köpt kubikmeter. Ange endast rörlig kostnad och ange ett medelvärde över senaste året om det inte är bundet. Rörlig kostnad motsvarar hur mycket Ni skulle spara om Ni sänkte er användning med en kbm."
                    inputDescription:@"Pris per kubikmeter"
                       whereToFindIt:@"Faktura från energibolaget"
                             sortKey:variableSortKey++
                        unitForTable:@"kr/kbm"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Energikostnad"
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithValuesFrom:8
                                To:24
                      withInterval:0.5];
    
    
    //Variable number 2! ---------------------
    
    [self createNewVariableWithTitle:@"Uppvärmning"
                         information:@"Den totala mängd energi som Ni använder i ert uppvärmningssystem varje år. Om Ert hus värms upp av värmepump eller elradiatorer, ange all köpt energi under 'El' och lämna detta värde tomt. OBS: Ej 0, utan ta bort alla siffror."
                    inputDescription:@"Årlig användning av uppvärmningsenergi"
                       whereToFindIt:@"Faktura från energibolaget"
                             sortKey:variableSortKey++
                        unitForTable:@"kWh/år"
                      usesPickerView:NO
                       usesTextField:YES
                            usesBool:NO
                     sectionForTable:1
                         sectionName:@"Energimängd"
                          lowerBound:0
                          upperBound:90000];
    
    [self createNewVariableWithTitle:@"El"
                         information:@"Den totala mängd el som Ni använder i Ert hushåll varje år. Om Ert hus använder el som uppvärmning (elradiatorer och värmepump), ange all el här och lämna värde 'Uppvärmning' tom."
                    inputDescription:@"Köpt el per år"
                       whereToFindIt:@"Faktura från energibolaget"
                             sortKey:variableSortKey++
                        unitForTable:@"kWh/år"
                      usesPickerView:NO
                       usesTextField:YES
                            usesBool:NO
                     sectionForTable:1
                         sectionName:@"Energimängd"
                          lowerBound:0
                          upperBound:15000];
    
    [self createNewVariableWithTitle:@"Vatten"
                         information:@"Den totala mängd vatten som Ni använder varje år. EnergiAppen räknar ut hur stor del som är varm- respektive kallvatten."
                    inputDescription:@"Årlig användning av vatten"
                       whereToFindIt:@"Faktura från vattenverket"
                             sortKey:variableSortKey++
                        unitForTable:@"kbm/år"
                      usesPickerView:NO
                       usesTextField:YES
                            usesBool:NO
                     sectionForTable:1
                         sectionName:@"Energimängd"
                          lowerBound:0
                          upperBound:400];
    
    
    /*
     
     -------------------------------------------
     Section 3!!
     -------------------------------------------
     
     */
    variableSortKey = 0;
    
    
    [self createNewVariableGroupWithTitle:@"Uppvärmning"
                          sectionForTable:0
                                  sortKey:sectionSortKey++];
    
    [self createNewVariableWithTitle:@"Inomhustemperatur"
                         information:@"Den temperatur som Ni har i ert hus."
                    inputDescription:@"Temperatur i huset"
                       whereToFindIt:@"Termometer är säkrast. På vissa reglersystem (de som styr effekt på uppvärmningssystemet) kan man ofta ställa in temperatur. Inomhusgivare bör sitta på en innervägg i skugga, och utomhusgivare styrs ifrån pannrummet. Att köpa in en billig termometer och kontrollera att givarsystemet fungerar som önskat kan vara en god ide."
                             sortKey:variableSortKey++
                        unitForTable:@"grader"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"System"
                          lowerBound:0
                          upperBound:0];
    
    
    [self fillPickerWithValuesFrom:10 To:25 withInterval:1];
    
    
    [self createNewVariableWithTitle:@"Ålder uppvärmningssystem"
                         information:@"Året då Ni bytte eller uppgraderade ert uppvärmningssystem senast."
                    inputDescription:@"År vid senaste uppgradering"
                       whereToFindIt:@"Räkningar, Husägare, Tidigare husägare"
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Uppvärmning"
                          lowerBound:0
                          upperBound:0];
    
    //add a value before the regular 1985-2012
    [self createNewValueForPicker:YES WithValue:@"1985 eller äldre"
                      typeOfValue:TypeOfVariableString];
    
    [self fillPickerWithValuesFrom:1986 To:2012 withInterval:1];
    
    
    
    [self createNewVariableWithTitle:@"Uppvärmningssystem"
                         information:@"Om Ni har olika uppvärmningssystem, exempelvis ett som jobbar mest och ett som hjälper till de sista graderna bör Ni ange ett i taget och se vad systemet rekommenderar. Presentera sedan alla åtgärdsförslag för en energiexpert för att få deras synpunkter. Är Ni osäker så ange det system som huvudsakligen värmer upp huset.\n\nFinns Ert uppvärmningssystem inte med i listan? Välj det mest lika alternativet beroende på vilken värmekälla ni använder mest."
                    inputDescription:@"Uppvärmningssystem"
                       whereToFindIt:@"Räkningar, Husägare"
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Blha blah"
                          lowerBound:0
                          upperBound:0];
    
    NSArray *heatingSystems = [self.variableStorage heatingSystems];
    [self fillPickerWithStringsFromArray:heatingSystems];
    
    
    [self createNewVariableWithTitle:@"Pumps värmefaktor"
                         information:@"Värmepumpens värmefaktor kallas även språk COP - Coefficienct of Performance. COP står för hur mycket värme pumpen levererar för varje del el om den värmer upp. Om den använder 1 kWh el för att leverera 3 kWh värme är COP 3."
                    inputDescription:@"Värmepumpens värmefaktor"
                       whereToFindIt:@"Manualer, Tillverkare, Husägare"
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@""
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithValuesFrom:2.0 To:5.0 withInterval:0.2];
    
    conditionVariableTitle = @"Uppvärmningssystem";
    NSArray *allHeatingSystems = [self.variableStorage heatingSystems];
    condition = [NSString stringWithFormat:@"(value.value = \'%@\' OR value.value = \'%@\')",
                 [allHeatingSystems objectAtIndex:4],
                 [allHeatingSystems objectAtIndex:5]]; 
    [self createConditionForPrevousVariableWithTitleEqualTo:conditionVariableTitle andValueCondition:condition];
    
    
    
    
    [self createNewVariableWithTitle:@"Uppvärmningens styrsystem"
                         information:@"Styrsystemet bestämmer vilken effekt som uppvärmningssystemet skall arbeta på för att uppnå önskat resultat. Desto bättre styrsystem, desto jämnare temperatur i huset. Om exempelvis utomhustemperaturen ökar bör värmesystemet öka först när det blir kallt inne, om man eldar inne bör det minska med en gång.\n\n•Manuell shunt står för att man manuellt bestämmer vilken effekt som skall matas ut från värmesystemet eller elementet. Även om man ofta justerar uppvärmningen med en ratt eller knapp kan man säga att man har manuell styrning, ange manuell shunt.\n•Manuell shunt med termostater innebär att man manuellt ställer in en viss last och att termostater sedan stänger av flödet till ett visst element om det blir för varmt just där. Beroende på värmesystem produceras fortfarande värmen och åker runt i rören på huset.\n•Utomhusgivare står för att en termometer sitter utomhus av huset och styr effekten beroende på utomhustemperatur. En utomhusgivare tar inte i åtanke tröghet i huset (värme lagras i stommen) och inte heller om det tillkommer gratisvärme i form av  många personer, solljus, om man eldar inomhus, lagar mat el. liknande. Då kan man behöva vädra för att få sänka temperaturen.\n•Utomhusgivare med termostat är en utomhusgivare med termostater på varje element för att lokalt stoppa energiförsörjningen.\n•Inomhusgivare är en givare centralt placerad i huset som styr uppvärmningen för hela huset. Man anger den inomhustemperatur som man önskar och systemet ökar sedan effekten på uppvärmningsystemet om temperaturen inte är uppnådd, och slår av när den är det."
                    inputDescription:@"Det vattenburna styrsystemet"
                       whereToFindIt:@"•Om manuell reglering: Manuell shunt.\n•Om det finns en utomhusgivare och Ni styr från pannrummet: Utomhusgivare\n•Om det finns termostater: ange med termostater\n•Om Ni styr temperatur från inomhus: Inomhusgivare"
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Uppvärmning"
                          lowerBound:0
                          upperBound:0];
    
    NSArray *arrayOfWaterHeatingSystems = [self.variableStorage systemsOfRegulationForWaterHeating];
    [self fillPickerWithStringsFromArray:arrayOfWaterHeatingSystems];
    
    
    conditionVariableTitle = @"Uppvärmningssystem";
    allHeatingSystems = [self.variableStorage heatingSystems];
    condition = [NSString stringWithFormat:@"(value.value = \'%@\' OR value.value = \'%@\' OR value.value = \'%@\' OR value.value = \'%@\' OR value.value = \'%@\')",
                           [allHeatingSystems objectAtIndex:0],
                           [allHeatingSystems objectAtIndex:1],
                           [allHeatingSystems objectAtIndex:2],
                           [allHeatingSystems objectAtIndex:3],
                           [allHeatingSystems objectAtIndex:5]]; 
    [self createConditionForPrevousVariableWithTitleEqualTo:conditionVariableTitle andValueCondition:condition];
    
    
    
    [self createNewVariableWithTitle:@"Elradiator styrsystem"
                         information:@"En central styrning är absolut effektivast för att uppnå en jämn inomhustemperatur, vilket är mest kostnadseffektivt. Om Ni har äldre element med bimetallgivare (som knäpper då och då), ange detta. Har Ni nyare element utan central styrning kan Ni även då ange bimetall för att få en fingervisning och tips till energibesiktning. Om Ni har en central styrenhet, ange detta."
                    inputDescription:@"Hur regleras värmen?"
                       whereToFindIt:@"Lyssna på elementen, undersök hur man reglerar rumstemperatur"
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Uppvärmning"
                          lowerBound:0
                          upperBound:0];
    
    NSArray *arrayOfElectricalRadiatorSystems = [self.variableStorage systemsOfRegulationForElectricRadiators];
    [self fillPickerWithStringsFromArray:arrayOfElectricalRadiatorSystems];
    
    conditionVariableTitle = @"Uppvärmningssystem";
    NSString *electricalRadiators = [allHeatingSystems objectAtIndex:6];
    condition = [NSString stringWithFormat:@"(value.value = \'%@\')", electricalRadiators]; 
    [self createConditionForPrevousVariableWithTitleEqualTo:conditionVariableTitle andValueCondition:condition];
    
    
    
    [self createNewVariableWithTitle:@"Antal element"
                         information:@"Antal vattenburna element som finns i huset"
                    inputDescription:@"Vattenburna element"
                       whereToFindIt:@"Visuell inspektion"
                             sortKey:variableSortKey++
                        unitForTable:@"st"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Uppvärmning"
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithValuesFrom:1 To:30 withInterval:1];
    
    conditionVariableTitle = @"Uppvärmningssystem";
    condition = [NSString stringWithFormat:@"(value.value = \'%@\' OR value.value = \'%@\' OR value.value = \'%@\' OR value.value = \'%@\' OR value.value = \'%@\')",
                 [allHeatingSystems objectAtIndex:0],
                 [allHeatingSystems objectAtIndex:1],
                 [allHeatingSystems objectAtIndex:2],
                 [allHeatingSystems objectAtIndex:3],
                 [allHeatingSystems objectAtIndex:5]]; 
    [self createConditionForPrevousVariableWithTitleEqualTo:conditionVariableTitle andValueCondition:condition];
    
    
    [self createNewVariableWithTitle:@"Termostatsålder"
                         information:@"Ange det år då Ni senast uppgraderade era termostater på era vattenburna element."
                    inputDescription:@"Årtal för termostatsinköp"
                       whereToFindIt:@"Fakturor, Husägare, Tidigare husägare"
                             sortKey:variableSortKey++
                        unitForTable:@"år"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Uppvärmning"
                          lowerBound:0
                          upperBound:0];
    
    //add a value before the regular 1891-2012
    [self createNewValueForPicker:YES WithValue:@"1980 eller äldre"
                      typeOfValue:TypeOfVariableString];
    [self fillPickerWithValuesFrom:1981 To:2012 withInterval:1];
    
    conditionVariableTitle = @"Uppvärmningssystem";
    condition = [NSString stringWithFormat:@"(value.value = \'%@\' OR value.value = \'%@\' OR value.value = \'%@\' OR value.value = \'%@\' OR value.value = \'%@\')",
                 [allHeatingSystems objectAtIndex:0],
                 [allHeatingSystems objectAtIndex:1],
                 [allHeatingSystems objectAtIndex:2],
                 [allHeatingSystems objectAtIndex:3],
                 [allHeatingSystems objectAtIndex:5]]; 
    [self createConditionForPrevousVariableWithTitleEqualTo:conditionVariableTitle andValueCondition:condition];
    
    
    
    [self createNewVariableWithTitle:@"Cirkulationspump"
                         information:@"Ofta kan det vara installerat en gammal cirkulationspump. När Ni senast bytte uppvärmningssystemet kan Ni i samband ha bytt ut cirkulationspumpen, undersök de fakturorna."
                    inputDescription:@"Ange installationsår"
                       whereToFindIt:@"Fakturor, Husägare, Tidigare husägare"
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Uppvärmning"
                          lowerBound:0
                          upperBound:0];
    
    //add a value before the regular 1990-2012
    [self createNewValueForPicker:YES WithValue:@"1990 eller äldre"
                      typeOfValue:TypeOfVariableString];
    [self fillPickerWithValuesFrom:1991 To:2012 withInterval:1];
    
    conditionVariableTitle = @"Uppvärmningssystem";
    condition = [NSString stringWithFormat:@"(value.value = \'%@\' OR value.value = \'%@\' OR value.value = \'%@\' OR value.value = \'%@\' OR value.value = \'%@\')",
                 [allHeatingSystems objectAtIndex:0],
                 [allHeatingSystems objectAtIndex:1],
                 [allHeatingSystems objectAtIndex:2],
                 [allHeatingSystems objectAtIndex:3],
                 [allHeatingSystems objectAtIndex:5]]; 
    [self createConditionForPrevousVariableWithTitleEqualTo:conditionVariableTitle andValueCondition:condition];
    
    
    [self createNewVariableWithTitle:@"Typ av eldstad"
                         information:@"•Öppen spis är en eldstad utan några tillbehör. Luftintaget är okontrollerat och värmen stiger rakt upp i skorstenen.\n•Öppen spis med spisinsats är en öppen spis där man i efterhand har installerat en spisinsats för att förbättra verkninsgraden. Äldre insatser har rör runtomkring den öppna spisen och modernare insatser kan ha en lucka och en fläkt på ovansidan.\n•Murspis är ofta inte inbyggd i väggen men är permanent, själva eldstaden ser ut att vara inmurad i lättbetong eller liknande material. Murspis har ofta en insats med lucka.\n•Traditionella kakel- och tegelugnar har ett rörsystem som effektivt värmer upp. Kakelugn känns igen på sitt kaklade utanmäte. Tegelugn är likvärdig fast har ofta ett vitkalkat utmäte. Både kakel- och tegelugn har i regel en mindre lucka som man ej kan se igenom\n•Moderna kakel-, tegel- och täljstensugnar ser likvärdiga ut som sina äldre motsvarigheter, men har i regel inte samma kvalitet på material. Om ugnen är installerad under den senare delen av förra seklet kan det antas vara en modern sådan.\n•Gjutjärnskaminen står oftast fritt från vägg och är en ganska liten metallklump. Eldstadsutrymmet är litet och behöver därmed fyllas på relativt ofta.\n•Braskaminer är ofta fristående eldstäder i plåt, men kan i vissa fall vara infästa i större konstruktioner. Braskaminer har oftast ett utblås drivet av antingen självdrag eller fläkt som blåser ut varmluft.\n•Kakelkamin är ett mellanting mellan braskamin och kakelugn. Den ser ofta ut som en större insats inmurad i material som gör att den håller värmeenergin länge.\n\nEnergiAppen räknar ut hur mycket ni tjänar på att använda eldstaden - kommer det inte upp i åtgärdsförslaget finns det risk att det kostar mer än man tjänar in."
                    inputDescription:@""
                       whereToFindIt:@"Visuell inspektion. En kort beskrivning på varje eldstad följer nedan, om Ni finner den otillräcklig kan Ni på internet söka efter bilder på de olika typerna och jämföra med Er eldstad."
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:1
                         sectionName:@"Eldstad"
                          lowerBound:0
                          upperBound:0];
    
    NSArray *namesOfFirePlaces = [self.variableStorage fireplaces];
    [self fillPickerWithStringsFromArray:namesOfFirePlaces];
    
    
    [self createNewVariableWithTitle:@"Vedkostnad"
                         information:@"Ange hur mycket Ni betalar för en kubikmeter ved. Vilken typ av kubikmeter Ni köper (stjälpt eller travat) anger Ni under 'Kubikmått'.\n\nOm Ni köper ved i travade säckar går det ca 12st 80-litersäckar och 25 st 40-litersäckar på en travad kubikmeter."
                    inputDescription:@""
                       whereToFindIt:@"Faktura"
                             sortKey:variableSortKey++
                        unitForTable:@"kr/kbm"
                      usesPickerView:NO
                       usesTextField:YES
                            usesBool:NO
                     sectionForTable:1
                         sectionName:@""
                          lowerBound:0
                          upperBound:1200];
    
    conditionVariableTitle = @"Typ av eldstad";
    NSString *noFirePlace = [[self.variableStorage fireplaces] objectAtIndex:0];
    condition = [NSString stringWithFormat:@"(value.value != \'%@\')", noFirePlace]; 
    [self createConditionForPrevousVariableWithTitleEqualTo:conditionVariableTitle andValueCondition:condition];
    
    [self createNewVariableWithTitle:@"Kubikmått"
                         information:@"Redovisa vilket mått som gäller för den vedkostnad Ni angav. Travat innebär att det är staplat, och själpt innebär att det ligger i en hög"
                    inputDescription:@""
                       whereToFindIt:@"Person som köper ved"
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:1
                         sectionName:@""
                          lowerBound:0
                          upperBound:0];
    
    
    [self createNewValueForPicker:YES WithValue:@"Stjälpt" typeOfValue:TypeOfVariableString];
    [self createNewValueForPicker:YES WithValue:@"Travat" typeOfValue:TypeOfVariableString];
    
    conditionVariableTitle = @"Typ av eldstad";
    condition = [NSString stringWithFormat:@"(value.value != \'%@\')", noFirePlace]; 
    [self createConditionForPrevousVariableWithTitleEqualTo:conditionVariableTitle andValueCondition:condition];
    
    
    
    [self createNewVariableWithTitle:@"Typ av ved"
                         information:@"Beroende på densitet och energivärde kan det skilja sig en del mellan energisorter. Ange det trädslag som ni eldar mest med."
                    inputDescription:@""
                       whereToFindIt:@"Person som köper ved"
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:1
                         sectionName:@""
                          lowerBound:0
                          upperBound:0];
    
    NSArray *woodsArray = [self.variableStorage namesOfWoods];
    [self fillPickerWithStringsFromArray:woodsArray];
    
    conditionVariableTitle = @"Typ av eldstad";
    condition = [NSString stringWithFormat:@"(value.value != \'%@\')", noFirePlace]; 
    [self createConditionForPrevousVariableWithTitleEqualTo:conditionVariableTitle andValueCondition:condition];
    
    /*
     
     -------------------------------------------
     Section 4!!
     -------------------------------------------
     
     */
    
    
    [self createNewVariableGroupWithTitle:@"Klimatskal"
                          sectionForTable:0
                                  sortKey:sectionSortKey++];
    
    
    variableSortKey = 0;
    
    //Variable number 4! ---------------------
    
    [self createNewVariableWithTitle:@"Fasadarea"
                         information:@"Ange arean för yttervägg över mark, inklusive dörrar och fönster. Om ert hus har fyrkantigt formade väggar (ej snedtak) kan man göra uppskattningen: fasadarea = hushöjd x omkrets"
                    inputDescription:@"Ytterväggsarea över mark"
                       whereToFindIt:@"Ritningar"
                             sortKey:variableSortKey++
                        unitForTable:@"kvm"
                      usesPickerView:NO
                       usesTextField:YES
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Husfakta"
                          lowerBound:0
                          upperBound:800];
    //Variable number 1! ---------------------
    
    [self createNewVariableWithTitle:@"Tätningslister"
                         information:@"Tätningslister runt fönster, dörrar och vindsluckor blir dåliga med tiden. Om de inte har bytts ut på 7-10 år kan det vara dags igen."
                    inputDescription:@"Skick på tätningslister vid fönster och dörrar"
                       whereToFindIt:@"Visuell inspektion - tryck på listerna och se ifall de är mjuka och återfår formen. Om mer än en tredjedel av listerna är dåliga, eller det har börjat uppstå sprickor i dem, anger Ni att de är i dåligt skick."
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Fönster"
                          lowerBound:0
                          upperBound:0];
    
    [self createNewValueForPicker:YES WithValue:@"Bra skick" typeOfValue:TypeOfVariableString];
    [self createNewValueForPicker:YES WithValue:@"Dåligt skick" typeOfValue:TypeOfVariableString];
    
    
    [self createNewVariableWithTitle:@"Fönstertyp"
                         information:@"Ange det fönster som Ni har i dagsläget.\n\nKopplade bågar är bågar där man kan öppna och tvätta på insidan. \n\n2-glas isolerfönster står för en kasett av isolerfönster. Det är två glas som sätts ihop med fast mellanrum och sedan installeras i bågen, den kan man ofta känna igen på att det är en metallram mellan två fönsterglas vid karmen.\n\n1+1+1-glas står för tre stycken ej sammanhängande fönsterrutor i en fönsterkarm.\n\n1+2-glas isolerfönster är en ruta med en isolerkassett."
                    inputDescription:@"Välj installerade fönster"
                       whereToFindIt:@"Visuell inspektion, fakturor"
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Fönster"
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithStringsFromArray:self.variableStorage.windowsArray];
    
    // New Variable ****- -----------------------
    
    [self createNewVariableWithTitle:@"Skick på bågar"
                         information:@"Fönsterbågar är de ramar som fönsterglaset är fastsatt i, och som i sin tur sitter på gångjärnen. Ange vilket skick era fönsterbågar är i. Om de är av trä, testa att sticka i dem. Sjunker kniven ner är de i dåligt skick. Avgör om ni tror de räcker i tiotals år till om man underhåller dem, eller bör man byta ut dem snart. I regel skall de vara i bra skick om de underhålls med ca 7-10 års mellanrum."
                    inputDescription:@"Fönsterbågars skick"
                       whereToFindIt:@"Visuell inspektion - leta efter bl.a. rötskador i trä. Om fönstret har underhållits regelbundet bör det vara friskt"
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Fönster"
                          lowerBound:0
                          upperBound:0];
    
    [self createNewValueForPicker:YES WithValue:@"Bra skick" typeOfValue:TypeOfVariableString];
    [self createNewValueForPicker:YES WithValue:@"Dåligt skick" typeOfValue:TypeOfVariableString];
    
    
    // New Variable ****- -----------------------
    
    [self createNewVariableWithTitle:@"Vindsarea"
                         information:@"Area för kallvind. Ange endast kallvindsarea, dvs endast de utrymmen som gränsar mot kalla områden. Den används för att räkna på potentiell tilläggsisolering."
                    inputDescription:@""
                       whereToFindIt:@"Ritningar, Uppmätning"
                             sortKey:variableSortKey++
                        unitForTable:@"kvm"
                      usesPickerView:NO
                       usesTextField:YES
                            usesBool:NO
                     sectionForTable:1
                         sectionName:@"Vind"
                          lowerBound:0
                          upperBound:300];
    
    conditionVariableTitle = @"Typ av vind";
    coldAttic = @"Kallvind";
    condition = [NSString stringWithFormat:@"(value.value = \'%@\')", coldAttic]; 
    [self createConditionForPrevousVariableWithTitleEqualTo:conditionVariableTitle andValueCondition:condition];
    
    
    
    
    // New Variable ****- -----------------------
    
    
    [self createNewVariableWithTitle:@"Tilläggsisolerad"
                         information:@"Ange om vinden tidigare har blivit tilläggsisolerad."
                    inputDescription:@""
                       whereToFindIt:@"Ritningar, Fakturor från ombyggnationer, Tidigare husägare"
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:1
                         sectionName:@"Vind"
                          lowerBound:0
                          upperBound:0];
    
    
    [self createNewValueForPicker:YES WithValue:@"Nej" typeOfValue:TypeOfVariableString];
    [self createNewValueForPicker:YES WithValue:@"Ja" typeOfValue:TypeOfVariableString];
    
    conditionVariableTitle = @"Typ av vind";
    condition = [NSString stringWithFormat:@"(value.value = \'%@\')", coldAttic]; 
    [self createConditionForPrevousVariableWithTitleEqualTo:conditionVariableTitle andValueCondition:condition];
    
    
    // New Variable ****- -----------------------
    
    
    [self createNewVariableWithTitle:@"Nuvarande isolering"
                         information:@"Tjocklek på nuvarande isolering."
                    inputDescription:@""
                       whereToFindIt:@"Se om det går att läsa av från ritningar och eventuella fakturor från tilläggsisoleringar. Om man är händig kan man gå upp på vinden och kontrollera själv, men var försiktig så att Ni inte förstör någon fuktspärr i isoleringen."
                             sortKey:variableSortKey++
                        unitForTable:@"cm"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:1
                         sectionName:@"Vind"
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithValuesFrom:10 To:50 withInterval:1];
    
    conditionVariableTitle = @"Typ av vind";
    condition = [NSString stringWithFormat:@"(value.value = \'%@\')", coldAttic]; 
    [self createConditionForPrevousVariableWithTitleEqualTo:conditionVariableTitle andValueCondition:condition];
    
    
    // New Variable ****- -----------------------
    
    [self createNewVariableWithTitle:@"Möter taket vindsgolvet"
                         information:@"Om taket på sidan går hela vägen ner till vindsgolvet behövs det extra utrustning för att leda luften rätt."
                    inputDescription:@"Möter taket vindsgolvet"
                       whereToFindIt:@"Visuell inspektion - kolla om långsidorna på taket går hela vägen ner till golvet, om man längst ut på kanten kan lägga handen på golvet och nudda taket. Ibland går det istället upp en kort vägg en bit från kanten som kopplar ihop tak och golv."
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:1
                         sectionName:@"Vind"
                          lowerBound:0
                          upperBound:0];
    
    
    [self createNewValueForPicker:YES WithValue:@"Nej" typeOfValue:TypeOfVariableString];
    [self createNewValueForPicker:YES WithValue:@"Ja" typeOfValue:TypeOfVariableString];
    
    conditionVariableTitle = @"Typ av vind";
    condition = [NSString stringWithFormat:@"(value.value = \'%@\')", coldAttic]; 
    [self createConditionForPrevousVariableWithTitleEqualTo:conditionVariableTitle andValueCondition:condition];
    
    
    // New Variable ****- -----------------------
    
    [self createNewVariableWithTitle:@"Huslängd"
                         information:@"Den längre sidan på huset"
                    inputDescription:@"meter"
                       whereToFindIt:@"Ritningar"
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:NO
                       usesTextField:YES
                            usesBool:NO
                     sectionForTable:1
                         sectionName:@"Vind"
                          lowerBound:0
                          upperBound:50];
    
    conditionVariableTitle = @"Typ av vind";
    condition = [NSString stringWithFormat:@"(value.value = \'%@\')", coldAttic]; 
    [self createConditionForPrevousVariableWithTitleEqualTo:conditionVariableTitle andValueCondition:condition];
    
    
    conditionVariableTitle = @"Möter taket vindsgolvet";
    condition = @"Ja";
    condition = [NSString stringWithFormat:@"(value.value = \'%@\')", condition]; 
    [self createConditionForPrevousVariableWithTitleEqualTo:conditionVariableTitle andValueCondition:condition];
    
    
    /*
     
     -------------------------------------------
     Section 4!!
     -------------------------------------------
     
     */
    
    
    [self createNewVariableGroupWithTitle:@"Vattenanvändning"
                          sectionForTable:0
                                  sortKey:sectionSortKey++];
    
    
    variableSortKey = 0;
    //Variable number 1! ---------------------
    
    [self createNewVariableWithTitle:@"Resurseffektiva kökskranar"
                         information:@"Resurseffektiv står för engreppsblandare med snålspolande funktion. Om Ni har engreppsblandare med snålspolande munstycke, eller resurseffektiva engreppsblandare, anger Ni det sammanlagda antalet här. Ange bara det antal som aktivt används."
                    inputDescription:@"Resurseffektiva blandare i kök"
                       whereToFindIt:@"Visuell inspektion. Har Ni en nyinstallerad armatur, sedan ett par år tillbaka, kan den vara resurseffektiv. Har Ni ett påskruvat munstycke på armaturen kan detta också ge en snålspolande effekt."
                             sortKey:variableSortKey++
                        unitForTable:@"st"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Armaturer"
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithValuesFrom:0 To:4 withInterval:1];
    
    
    
    
    [self createNewVariableWithTitle:@"Resurseffektiva tvättställ"
                         information:@"Resurseffektiv står för engreppsblandare med snålspolande funktion. Om Ni har engreppsblandare med snålspolande munstycke, eller resurseffektiva engreppsblandare, på badrummet anger Ni det sammanlagda antalet här. Ange bara det antal som aktivt används."
                    inputDescription:@"Resurseffektiva blandare i badrum"
                       whereToFindIt:@"Visuell inspektion. Har Ni en nyinstallerad armatur, sedan ett par år tillbaka, kan den vara resurseffektiv. Har Ni ett påskruvat munstycke på armaturen kan detta också ge en snålspolande effekt."
                             sortKey:variableSortKey++
                        unitForTable:@"st"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Armaturer"
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithValuesFrom:0 To:5 withInterval:1];
    
    
    
    [self createNewVariableWithTitle:@"Resurseffektiva duschar"
                         information:@"Resurseffektiv står för engreppsblandare med snålspolande funktion. Om Ni har engreppsblandare med snålspolande munstycke, eller resurseffektiva engreppsblandare, i badrummet anger Ni det sammanlagda antalet här. Ange bara det antal som aktivt används."
                    inputDescription:@"Resurseffektiva blandare i dusch"
                       whereToFindIt:@"Visuell inspektion. Har Ni en nyinstallerad armatur, sedan ett par år tillbaka, kan den vara resurseffektiv. Är den äldre är den antagligen inte resurseffektiv. En dusch kan både ha ett snålspolande handtag, eller en begränsande packning i slangen. Den som installerade duschen vet hur det ligger till."
                             sortKey:variableSortKey++
                        unitForTable:@"st"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Armaturer"
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithValuesFrom:0 To:4 withInterval:1];
    
    
    
    [self createNewVariableWithTitle:@"Engrepps tvättställ"
                         information:@"Engreppsbandare står för att man ställer in temperaturen på vattnet med en ratt. Ange bara det antal som aktivt används."
                    inputDescription:@"Engreppsblandare i badrum"
                       whereToFindIt:@"Visuell inspektion. Har Ni engreppsblandare i badrum som inte är resurseffektiva (se information för resurseffektiva badrumskranar) anger Ni det totala antalet engreppsblandare i badrum här."
                             sortKey:variableSortKey++
                        unitForTable:@"st"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Armaturer"
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithValuesFrom:0 To:5 withInterval:1];
    
    
    
    [self createNewVariableWithTitle:@"Engrepps kökskranar"
                         information:@"Engreppsbandare står för att man ställer in temperaturen på vattnet med en ratt. Ange bara det antal som aktivt används."
                    inputDescription:@"Engreppsblandare i kök"
                       whereToFindIt:@"Visuell inspektion. Har Ni engreppsblandare i köket som inte är resurseffektiva (se information för resurseffektiva kökskranar) anger Ni det totala antalet engreppsblandare i kök här."
                             sortKey:variableSortKey++
                        unitForTable:@"st"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Armaturer"
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithValuesFrom:0 To:4 withInterval:1];
    
    
    
    [self createNewVariableWithTitle:@"Engrepps duschar"
                         information:@"Engreppsbandare står för att man ställer in temperaturen på vattnet med en ratt. Ange bara det antal som aktivt används."
                    inputDescription:@"Engreppsblandare i dusch"
                       whereToFindIt:@"Visuell inspektion. Har Ni engreppsblandare i duschar som inte är resurseffektiva (se information för resurseffektiva duschar) anger Ni det totala antalet engreppsblandare på duschar här."
                             sortKey:variableSortKey++
                        unitForTable:@"st"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Armaturer"
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithValuesFrom:0 To:4 withInterval:1];
    
    
    [self createNewVariableWithTitle:@"Tvågrepps tvättställ"
                         information:@"Tvågreppsblandare står för att man ställer in temperaturen på vattnet med två rattar. Ange bara det antal som aktivt används."
                    inputDescription:@"Tvågreppsblandare i badrum"
                       whereToFindIt:@"Visuell inspektion. Har Ni tvågreppsblandare i badrum anger Ni det totala tvågreppsblandare i badrum antalet här."
                             sortKey:variableSortKey++
                        unitForTable:@"st"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Armaturer"
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithValuesFrom:0 To:4 withInterval:1];
    
    
    [self createNewVariableWithTitle:@"Tvågrepps kökskranar"
                         information:@"Tvågreppsblandare står för att man ställer in temperaturen på vattnet med två rattar. Ange bara det antal som aktivt används."
                    inputDescription:@"Tvågreppsblandare i kök"
                       whereToFindIt:@"Visuell inspektion. Har Ni tvågreppsblandare i kök anger Ni det totala antalet tvågreppsblandare i kök här."
                             sortKey:variableSortKey++
                        unitForTable:@"st"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Armaturer"
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithValuesFrom:0 To:4 withInterval:1];
    
    
    [self createNewVariableWithTitle:@"Tvågrepps duschar"
                         information:@"Tvågreppsblandare står för att man ställer in temperaturen på vattnet med två rattar. Ange bara det antal som aktivt används."
                    inputDescription:@"Tvågreppsblandare till dusch"
                       whereToFindIt:@"Visuell inspektion. Har Ni tvågreppsblandare till dusch anger Ni det totala antalet tvågreppsblandare i dusch här."
                             sortKey:variableSortKey++
                        unitForTable:@"st"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Armaturer"
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithValuesFrom:0 To:4 withInterval:1];
    
    /*
     
     -------------------------------------------
     Section 5!!
     -------------------------------------------
     
     */
    
    
    [self createNewVariableGroupWithTitle:@"Hushållsel"
                          sectionForTable:0
                                  sortKey:sectionSortKey++];
    
#if 0
    //this is not included
    [self createNewVariableWithTitle:@"Antal lampor"
                         information:@"BLAH BLAH"
                    inputDescription:@"LAH BLAHLAH BLAH installerat antal"
                       whereToFindIt:@"LAH BLAH LAH BLAH"
                             sortKey:variableSortKey++
                        unitForTable:@"LAH BLAH"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Belysning"
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithValuesFrom:20 To:100 withInterval:1];
    
#endif
    
    
    [self createNewVariableWithTitle:@"Elhanddukstork"
                         information:@"De finns sig ofta i badrummet"
                    inputDescription:@"Ange installerat antal"
                       whereToFindIt:@"Visuell inspektion"
                             sortKey:variableSortKey++
                        unitForTable:@"st"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Elanddukstork"
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithValuesFrom:0 To:4 withInterval:1];
    
    
    [self createNewVariableWithTitle:@"Handdukstork effekt"
                         information:@"Effekten avser hur mycket värme som handdukstorken värmer."
                    inputDescription:@""
                       whereToFindIt:@"Visuell inspektion. Det finns ofta en klisterlapp någonstans på handdukstorken som visar vilken effekt den har."
                             sortKey:variableSortKey++
                        unitForTable:@"Watt"
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Elhanddukstork"
                          lowerBound:0
                          upperBound:0];
    
    [self fillPickerWithValuesFrom:40 To:120 withInterval:5];
    
    conditionVariableTitle = @"Elhanddukstork";
    condition = [NSString stringWithFormat:@"(value.value > 0)"]; 
    [self createConditionForPrevousVariableWithTitleEqualTo:conditionVariableTitle andValueCondition:condition];
    
    
    
    
    [self createNewVariableWithTitle:@"Handdukstork styrning"
                         information:@"Hur regleras av och på? Om Ni har en timer som reglerar tiden väljer ni 'Timer', annars 'Manuell'."
                    inputDescription:@"Styrning"
                       whereToFindIt:@"Visuell inspektion"
                             sortKey:variableSortKey++
                        unitForTable:@""
                      usesPickerView:YES
                       usesTextField:NO
                            usesBool:NO
                     sectionForTable:0
                         sectionName:@"Elhanddukstork"
                          lowerBound:0
                          upperBound:0];
    
    [self createNewValueForPicker:YES WithValue:@"Timer" typeOfValue:TypeOfVariableString];
    [self createNewValueForPicker:YES WithValue:@"Manuell" typeOfValue:TypeOfVariableString];
    
    conditionVariableTitle = @"Elhanddukstork";
    condition = [NSString stringWithFormat:@"(value.value > 0)"]; 
    [self createConditionForPrevousVariableWithTitleEqualTo:conditionVariableTitle andValueCondition:condition];
    
    /*
     
     Byggnadsår
     Ort
     Boyta
     Fasadarea
     Antal plan
     Antal boende
     Kallvind
     Kulturskyddat
     
     
     Uppvärmning
     El
     Vatten
     Uppvärmningspris
     Elpris
     Vattenpris
     
     Inomhustemperatur
     Uppvärmningssystem
     Ålder uppvärmningssystem
     Reglersystem
     Antal radiatorer
     Radiatorålder
     Termostatsålder
     Cirkulationspumpsålder
     Typ av eldstad
     Inköpsvolymer ved
     Inköpspris ved
     
     
     Fönster senast åtgärda
     Tätningslistskick
     Fönstertyp
     Skick på bågar
     
     Vindsarea
     TIlläggsisolerad
     Nuvarande isolering
     Behövs vindavledare
     Huslängd
     
     Antal LED
     Antal lågenergilampor
     Antal glödlampor
     
     */
    
    
}

-(void)fillPickerWithValuesFrom:(double)fromThis To:(double)toThis withInterval:(double)interval
{
    
    //1 check if we're handling int or double
    //2 loop through and add a new value every time
    //2 save
    
    //1
    BOOL intervalIsInteger = YES;
    if ((int)interval != interval) {
        //we're handling decimals
        intervalIsInteger = NO;
    }
    
    float numberForLoop = fromThis;
    
    NSString *value;
    int typeOfValue;
    
    while (numberForLoop <= toThis) {
        
        if (intervalIsInteger) {
            typeOfValue = TypeOfVariableInteger;
            value = [NSString stringWithFormat:@"%d",(int)numberForLoop];
        } else {
            typeOfValue = TypeOfVariableString;
            value = [NSString stringWithFormat:@"%0.2f",numberForLoop];
        }
        
        [self createNewValueForPicker:YES WithValue:value
                          typeOfValue:typeOfValue];
        
        numberForLoop += interval;
    }
}

-(EAVariable*)createNewVariableWithTitle:(NSString *)title information:(NSString *)info inputDescription:(NSString *)inputDesc whereToFindIt:(NSString *)location sortKey:(int)sortK unitForTable:(NSString *)unit usesPickerView:(BOOL)isUsingPickerView usesTextField:(BOOL)isUsingTextField usesBool:(BOOL)isUsingBool sectionForTable:(int)section sectionName:(NSString *)sName lowerBound:(int)lB upperBound:(int)uB
{
    NSManagedObjectContext *contextToUse = self.managedObjectContext;
    EAVariable *newObject = [NSEntityDescription
                             insertNewObjectForEntityForName:@"EAVariable"
                             inManagedObjectContext:contextToUse];
    
    newObject.title = title;
    newObject.information = info;
    newObject.whereToFindIt = location;
    newObject.sortKey = [NSNumber numberWithInt:sortK];
    newObject.unitForTable = unit;
    newObject.usesPickerView = [NSNumber numberWithInt: isUsingPickerView ? 1 : 0];
    newObject.usesTextField = [NSNumber numberWithInt: isUsingTextField ? 1 : 0];
    newObject.usesBool = [NSNumber numberWithInt: isUsingBool ? 1 : 0];
    newObject.sectionForTable = [NSNumber numberWithInt:section];
    newObject.sectionName = sName;
    newObject.inputDescription = inputDesc;
    
    
    if (isUsingTextField) {
        
        NSAssert1(lB > 0 || uB != 0, @"need a lower and upper bound if we're using textfield",nil);
        newObject.lowerBound = [NSNumber numberWithInt:lB];
        newObject.upperBound = [NSNumber numberWithInt:uB];
        
        //create a value for the variable. Since we don't save any in the picker array, we need one here.
        EAValue *valueForVariable = [self createNewValueForPicker:NO WithValue:@"" typeOfValue:TypeOfVariableInteger];
        newObject.value = valueForVariable;
    }
    
    if (isUsingBool) {
        //create a value for the variable. Since we don't save any in the picker array, we need one here.
        EAValue *valueForVariable = [self createNewValueForPicker:NO WithValue:@"" typeOfValue:TypeOfVariableBool];
        newObject.value = valueForVariable;
    }
    
    _recentlyCreatedVariable = newObject;
    [_recentlyCreatedGroup addSubitemsObject:_recentlyCreatedVariable];
    
    return newObject;
}

-(EAVariableGroup*)createNewVariableGroupWithTitle:(NSString *)title sectionForTable:(int)section sortKey:(int)sortKey
{
    NSManagedObjectContext *contextToUse = self.managedObjectContext;
    EAVariableGroup *newObject = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"EAVariableGroup"
                                  inManagedObjectContext:contextToUse];
    
    newObject.title = title;
    newObject.sectionForTable = [NSNumber numberWithInt:section];
    newObject.sortKey = [NSNumber numberWithInt:sortKey];
    
    _recentlyCreatedGroup = newObject;
    [theHouse addSubitemsObject:_recentlyCreatedGroup];
    
    
    return newObject;
}

-(EAValue*)createNewValueForPicker:(BOOL)forPicker WithValue:(NSString *)value typeOfValue:(TypeOfVariable)typeOfValue
{
    NSManagedObjectContext *contextToUse = self.managedObjectContext;
    EAValue *newValue = [NSEntityDescription
                         insertNewObjectForEntityForName:@"EAValue"
                         inManagedObjectContext:contextToUse];
    
    newValue.typeOfValue = [NSNumber numberWithInt:typeOfValue];
    newValue.value = value;
    
    if (forPicker) {
        newValue.sortKey = [NSNumber numberWithInt:_sortKeyForPickerValues++];
        [_recentlyCreatedVariable addSubitemsObject:newValue];
    }
    
    return newValue;
}

#pragma mark Savings functions

-(void)addSavings
{
    //1 create a group
    //2 create savings
    //3 repeat until done
    //4 save
    
    
    
    /*
     
     -------------------------------------------
     Styr och reglertekniska!
     -------------------------------------------
     
     */
    
    
    
    [self addSavingsWithTitle:@"Installera inomhusgivare"
                 infoForAudit:@"Vissa i branschen rekommenderar istället att köpa nya termostater och kan argumentera för detta. Prata med oberoende fackmän, berätta hur ert hus ser ut, och dra egna slutsatser."
                  infoForUser:@"Byte till inomhusgivare gör att man oftast bäst tar tillvara på gratisvärmen som erbjuds i huset i form av eldstad, matlagning och solinstrålning. En inomhusgivare blir extra intressant om man gör andra åtgärder, då den inte behövers justeras för minsta förändring på klimatskal eller uppvärmning. När alla element i huset jobbar tillsammans blir det kostnadseffektivare uppvärmning.\n\nOm Ni inte har angett ålder på termostater antags det att de är för gamla. Notera även att Ni inte behöver investera i nya termostater om Ni köper en inomhusgivare.\n\nVid installation skall inomhusgivaren sättas på en inomhusvägg som inte nås av solljus. Alla termostater och shuntar på elementen ställs in på maxflöde. Injustering av givarsystemet är viktigt och kan bidra till stor del av besparingen, så ta tid och prata med installatören om hur bästa inomhuskomfort uppnås."];
    
    [self addSavingsWithTitle:@"Nya termostater"
                 infoForAudit:@""
                  infoForUser:@"Om era termostater fungerar dåligt kan nya termostater bidra till en jämnare inomhustemperatur. Dessa bör uppgraderas eller åtminstone noggrant kontrolleras efter 10 år. En händig småhusägare kan genomföra arbetet själv och på så vis spara investeringskostnad, men rådfråga en kunnig före installation så att Ni är säkra på utförandet.\n\nNya ventiler behövs vanligtvis inte och då behöver man inte heller tappa ur vatten ur hela systemet. Kontrollera däremot gummipackningen mellan ventil och termostat så att den är mjuk.\n\nEtt effektivt alternativ är att installera en inomhusgivare istället för att använda er av termostater, rådfråga fackman inom området för mer hjälp."];
    
    
    [self addSavingsWithTitle:@"Centralt styrsystem"
                 infoForAudit:@"Har man nyare element med enskilda termostater finns det även här pengar att spara. Be energiexpert om tips och råd på vilket sorts givarsystem som passar bra. Exempelvis är ett flerzonssysstem användbart om man har klart avgränsade ytor i vilka man kan sänka temperaturen, exempelvis i källare. Att sätta lägre temperatur i ett vanligt rum ger ofta inte så mycket. Om allt som skärmar av är en vanlig rumsdörr som är öppnas då och då kommer andra element att värma upp utrymmet."
                  infoForUser:@"Elradiatorer som inte har central styrning slösar ofta värme om de exempelvis sitter nära en utomhusdörr eller fönster med kallras (dålig isolering). Elementet går igång extra mycket och man får effekttoppar. Element skall i så stor utsträckning som möjligt arbeta tillsammans för kostnadseffektivast uppvärmning.\n\nDetsamma gäller elradiatorer som styrs med bimetall. Utöver lokala effekttoppar så blir bimetallsgivaren ofta dålig och reglerar fel. Om elementet fungerar utmärkt kan man endast genom att förbättra givarsystemet spara mycket.\n\nAtt installera ett centralt styrsystem ger en jämnare temperatur och minskar effekttoppar. Uträkningen är baserat på en central givare av den enklaste modellen med bimetallsgivare. Det finns centrala styrsystem med fler funktioner som flerzonssystem samt tidsstyrningsfunktion. Med hjälp av dessa får man större kontroll på temperaturen och kan exempelvis sänka i källaren eller andra utrymmen som är avskärmade. Tidsstyrningsfunktion gör att man kan sänka temperaturen med ett par grader under nattid eller då ingen är hemma vilket ger ökad besparing."];
    
    [self addSavingsWithTitle:@"Timer till handdukstork"
                 infoForAudit:@"Vissa argumenterar att handdukstorken hjälper mot fukt, det stämmer inte. Om Ni har överflödig fukt i badrummet (vilket märks om man får imma på spegeln) bör man istället installera lösa fuktproblemet på rätt sätt, exempelvis med fläktar. Nämn situationen till energiexpert och be om råd."
                  infoForUser:@"Användande av elhanddukstork är energikrävande och bör minimeras, speciellt under de månader då uppvärmning inte är nödvändigt (sommarmånader). Om man installerar en timer som automatiskt slår av en timme efter man sätter igång torken sparar man mycket energi, och handduken hinner fortfarande bli torr.\n\nUträkningen är baserat på ett schablonvärde på ca 19 timmar per dag. Det låter mycket men är realistiskt. Att inte använda handdukstorken utan istället låta handduken självtorka kan vara ett nog så attraktivt alternativ som att installera en timer, men en timer gör att den mänskliga faktorn försvinner."];
    
    [self addSavingsWithTitle:@"Byta cirkulationspump"
                 infoForAudit:@""
                  infoForUser:@"Var noga med att undersöka vilken pump Ni bör köpa innan ni genomför inköpet. Vissa nya pumpar på marknaden kan vara hälften så dyra i drift som andra. Driftkostnaden av en cirkulationspump är ca 90% av den totala kostnaden så det är viktigt att man väljer en driftsnål. Investera även i en pump som har tryckreglering av varvtalet, de har oftast bäst energiprestanda."];
    
    [self addSavingsWithTitle:@"Sänk inomhustemperatur"
                 infoForAudit:@""
                  infoForUser:@"Rekommenderad inomhustemperatur är 20-21 grader. Besparingen gäller för 20 grader, testa och höj om det behövs. Om man investerar i ett par ylletofflor och koftor går det att sänka med ytterligare ett par grader. Varje grads sänkning innebär en ungefärlig besparing på 5% av uppvärmningskostnaden per år."];
    
    
    [self addSavingsWithTitle:@"Tillfälligt sänka inomhustemperatur"
                 infoForAudit:@""
                  infoForUser:@"Om man reser bort mer än en vecka lönar det sig att sänka värmen i huset. Det rekommenderas att man sänker med tre grader jämfört med den normala temperaturen, sänker man mer riskerar man störningar i systemet."];
    
    
    /*
     
     -------------------------------------------
     Installationstekniska!
     -------------------------------------------
     
     */
    
    [self addSavingsWithTitle:@"Snålspolande armaturer"
                 infoForAudit:@""
                  infoForUser:@"Att installera så effektiva armaturer som möjligt sparar både vatten och energi och bör göras så fort som möjligt. Det finns bra alternativ till kök, tvättställ och duschar. Uträkningen är baserad på att byta ut tvågreppsblandare till resurseffektiva engreppsblandare eller att installera ett snålspolande munstycke (duschhandtag för dusch, munstycke för tvättställ och kök) om en engreppsblandare redan existerar.\n\nFör tvättställ finns det många alternativ som kallt neutralläge och halv + helfunktion, vilka ger extra besparingar. Fråga en VVS-kunnig för mer information."];
    
    [self addSavingsWithTitle:@"Byta uppvärmningssystem"
                 infoForAudit:@"Fråga vad energiexperten rekommenderar och varför. Prata även med er energirådgivare i kommunen för att få tips inför bytet."
                  infoForUser:@"Uppvärmningssystem beaktas inte här utan detta är endast en förvarning att Ni bör se över ert inom par år. I regel säger man att ett uppvärmningssystem håller i 15 år. Om Ni planerar att utföra andra energirelaterade åtgärder kan det vara bra att kontrollerar så det fungerar med ett framtida uppvärmningssystem."];
    
    
    [self addSavingsWithTitle:@"Använda befintlig eldstad"
                 infoForAudit:@""
                  infoForUser:@"En öppen planlösning hjälper till att sprida värmen effektivt. För att få maximal besparing, se till att Ert reglersystem tar tillvara på värme som produceras inomhus. En inomhusgivare är det mest effektiva och rekommenderas.\n\nNotera att i regel rekommenderas endast kakel-, tegel- samt täljstensugnar för kontinuerlig uppvärmning. Övriga eldstäder funkar bra som komplettering men kan exempelvis sakna förmåga att lagra värme över natten.\n\nEnergivärdet baseras på björkved och blandved med mycket lövved, var noga med att den är tillräckligt torr vid eldning! Fukt sänker kraftigt vedens uppvärmningspotential."];
    
    
    /*
     
     -------------------------------------------
     Byggnadstekniska!
     -------------------------------------------
     
     */
    
    [self addSavingsWithTitle:@"Byt ruta till energiglas"
                 infoForAudit:@"Om man är intresserad av isolerglas skall man veta att det är lite tyngre än en vanlig fönsterruta. Det är viktigt att man kontrollerar att gångjärn och fönsterbåge kan hantera den extra vikten av en isolerkassett. Om fönsterkarm är i dåligt skick kan det vara tillfälle att byta till helt nya, fönster inkl. ny fönsterkarm, fönsterbåge och energiglas. Fråga om experten om bästa lösning med era förutsättningar."
                  infoForUser:@"När man byter ut innerrutan finns det två vanliga alternativ. Antingen kan man byta innerrutan mot ett lågemissionsglas som är nästan identiskt mot ett vanligt fönsterglas. Det andra alternativet är att byta innerglaset mot en kassett av isolerglas. En isolerglaskassett är två glas i en metallram där innanmätet är tätat och kan innehålla gaser för extra isolering. De kostar mer, men ger i gengäld större besparingar.  Exemplet är räknat på lågemissionsglas. Notera att det är innerrutan som skall bytas ut oavsett vilket alternativ man väljer."];
    
    [self addSavingsWithTitle:@"Komplettera med energiglas"
                 infoForAudit:@"Då man inte byter ut glaset utan endast lägger till mer vikt innebär det extra påfrestningar för fönsterkarm och gångjärn.\n\nSe också till så att det finns tillräckligt med utrymme för att kunna montera glaset med en kantlist. Var extra noga med att låta energiexpert och glasmästare inspektera fönstren innan åtgärd."
                  infoForUser:@"Att komplettera med ett extra lågemissionsglas på insidan av existerande fönsterkarmar är ett bra alternativ om man har friska fönsterbågar. Vid omvandling av ett 2-glas till ett 3-glas fönster förbättrar man energiprestanda och minskar bullernivå samtidigt som man behåller samma utseende från utsidan.  Utseendet på insidan förändras lite, då åtgärden går ut på att man sätter fast ett extra glas på insidan av fönsterkarmen m.h.a. kantlist."];
    
    
    [self addSavingsWithTitle:@"Nya fönster"
                 infoForAudit:@"Be att fönsterbågar och fönsterkarm undersöks så att det är säkert att man inte kan energieffektivisera genom billigare metoder, exempelvis komplettera med ett energiglas."
                  infoForUser:@"Om fönsterkarmar är i dåligt skick kan det vara ide att byta ut hela fönsterkarmen inklusive glas till energismarta alternativ. Värt att notera är att detta kraftigt förändrar byggnadens utseende. Vill man bevara kulturvärdet är detta alltså ej möjligt. Formeln baseras på ett fönster med nytt U-värde på 1,2 för hela fönsterkonstruktionen. Det går att få lägre U-värde på fönster, men i så fall kan det isolera så bra att kondens bildas på utsidan. I svenskt klimat innebär detta ofta att man får is på utsidan under vintertid som man kanske måste skrapa bort. Om Ni rådfrågar lokala energiexperter eller er kommun kan de svara på vad som gäller för Er ort."];
    
    [self addSavingsWithTitle:@"Täta fönster och dörrar"
                 infoForAudit:@""
                  infoForUser:@"Att ha täta fönster gör stor skillnad, inte minst för att man minskar drag och ökar den termiska komforten. Om man inte har separata tilluftskanaler, utan räknar med att luften skall ta sig in runt fönstren, kan man lämna ovankanten utan tätningslist. Täta alla objekt som har varmluft på enda sidan och kalluft på andra, som ytterdörr, källardörr, vindslucka/-dörr. När Ni tätar, investera i tätningslist av silikon som håller längst av alla"];
    
    [self addSavingsWithTitle:@"Tilläggsisolera kallvind"
                 infoForAudit:@"Ta fram material på tidigare utförda tilläggsisoleringar."
                  infoForUser:@"Det är lätt att tilläggsisolera på fel sätt, undvik att ta förhastade beslut. Kom ihåg att ventilera så att man inte får fuktskador på vinden, men var medveten om att det finns risk för överventilering.\n\nFör att minimera risken för fuktskador rekommenderas organisk tilläggsisolering om nuvarande isolering är organisk, och oorganisk för det motsatta fallet. Anledningen är att organisk isolering hanterar fukt mycket bra och inte behöver fuktspärras, en egenskap som bör utnyttjas om det är möjligt. Organiska material är naturliga material som bl.a. sågspån, kutterspån och ekofiber. Motsatsen är oorganiska material som mineralull, stenull, cellplast m.m. Organisk isolering kan ha liknande isoleringsförmåga som mineralull och skiljer inte avsevärt i kostnaden. Se det som ett billigt skydd mot fuktskador. Nuvarande pris är räknat med cellulosafiber (organiskt).\n\nVar även extra noga med att en vindavledare är installerad mot takstolarna om det behövs. Dessa skall installeras om taket möter vindsgolvet, så att isoleringsmaterialet ej kommer i kontakt med taket."];
    
    [self addSavingsWithTitle:@"Dra ner persienner"
                 infoForAudit:@""
                  infoForUser:@"Att dra ner persienner och rullgardiner på nätter sparar värme. Det ger ett extra lager framför fönstren och isolerar på samma sätt som en filt hjälper en person. Ju mer man kan isolera med hjälp av gardiner och persienner desto mindre energi slipper ut på natten. Om man isolerar mycket så kan man få kondens på utsidan av fönstret, men detta är inget att oroa sig för. Kom ihåg att dra upp på dagtid så att man får solvärme in i huset."];
    
    
    
    
}

-(void)addInfo
{
    NSInteger infoSortKey = 0;
    
    [self addNewInfoWithTitle:@"Tolka åtgärdsförslagen rätt"
                         text:@"Priser varierar över landet och inget hus är det andra likt, varje hus kräver sin unika lösning. Tolka därför åtgärdsförslagen som en potentiell besparing, men som behöver bekräftas av en expert."
                      sortKey:infoSortKey++
              sectionForTable:0
                  sectionName:@"Om åtgärdsförslagen"];
    
    [self addNewInfoWithTitle:@"Typ av hus"
                         text:@"EnergiAppen är endast riktad till småhus i Sverige och baseras på att man bor där året runt. Detta betyder att fritidshus och flerbostadshus inte kommer att få rättvisande resultat. \n\nNormalt sett tar det längre tid att räkna hem investeringar på fritidshus då de inte används lika mycket. \n\nAtt energieffektivisera flerbostadshus är definitivt lönsamt och man kan använda de tips som presenteras i EnergiAppen, även om kostnader och vissa åtgärdsförslag inte är helt korrekta."
                      sortKey:infoSortKey++
              sectionForTable:0
                  sectionName:@"Om åtgärdsförslagen"];
    
    
    [self addNewInfoWithTitle:@"Staplande åtgärdsförslag"
                         text:@"Alla åtgärdsförslag som rekommenderas baseras på data som är angiven för huset. Tyvärr kan man inte lägga ihop alla besparingar då dessa kan bli över 100 % av er energikostnad. I verkligheten sparar man mindre och mindre på varje åtgärd ju mer man energieffektiviserar. Om Ni vill undersöka hur mycket man kan spara med flera åtgärder rekommenderas att ni går till husets variabler och ändrar värden så att det motsvarar nuläget plus påhittad åtgärd.\n\nExempel: Om man vill se hur mycket man sparar att byta ut en fönsterruta mot energiglas efter att man sänkt inomhustemperaturen, ange då en lägre inomhustemperatur än den verkliga."
                      sortKey:infoSortKey++
              sectionForTable:0
                  sectionName:@""];
    
    
    [self addNewInfoWithTitle:@"Kallt eller varmt år"
                         text:@"De värden som Ni anger är inte klimatkorrigerade. Om energianvändningen Ni angav representerar ett varmt år blir alltså besparingarna ännu större, och vice versa. För att få ett mer rättvist resultat kan Ni ange uppvärmningsenergi som ett genomsnitt av flera år tillbaka."
                      sortKey:infoSortKey++
              sectionForTable:0
                  sectionName:@""];
    
    
    [self addNewInfoWithTitle:@"ROT-avdrag"
                         text:@"ROT-avdrag gör det möjligt att dra av arbetskostnaden för underhållsarbeten upp till en viss summa per år. Majoriteten av åtgärdsförslagen som presenteras i EnergiAppen innefattar arbetskostnad, således sjunker investeringskostnaden och återbetalningstiden om Ni har möjlighet att göra ROT-avdrag. När Ni beställer in offert, ta upp frågan och se hur totalsumman påverkas."
                      sortKey:infoSortKey++
              sectionForTable:0
                  sectionName:@""];
    
    
    [self addNewInfoWithTitle:@"Extra besparing"
                         text:@"Vid vissa investeringar, exempelvis vid förbättring av fönster, kan den totala besparingen ofta bli ännu större än vad som beräknas. Detta beror på att man tack vare bättre isolering får en stabilare inomhustemperatur, vilket bidrar till att man kan sänka temperaturen i hela huset. Trots en lägre effekt på uppvärmningssystemet upplever man alltså att det är ”varmt nog”. Varje grad man kan sänka sparar ytterligare ca 5% av den årliga uppvärmningskostnaden."
                      sortKey:infoSortKey++
              sectionForTable:0
                  sectionName:@""];
    
    [self addNewInfoWithTitle:@"Ökande energipris"
                         text:@"Återbetalningstiden som räknas ut räknar med ett stigande energipris i åtanke, med räntesatser ifrån Energimarknadsinspektionen. Räntesatser är olika för de flesta bränslen. Utöver detta har inga räntesatser tagits med i uträkningarna."
                      sortKey:infoSortKey++
              sectionForTable:0
                  sectionName:@""];
    
    
    [self addNewInfoWithTitle:@"Ökat fastighetsvärde"
                         text:@"Lönsamma energibesparande åtgärder sänker driftkostnaden av fastigheten. När fastighetens driftkostnader minskar ökar dess försäljningsvärde. "
                      sortKey:infoSortKey++
              sectionForTable:1
                  sectionName:@"Energikunskap"];
    
    [self addNewInfoWithTitle:@"Tänk på energi vid ombyggnad"
                         text:@"För att förbättra energiprestandan i vissa delar krävs ibland omfattande åtgärder. Att tilläggsisolera fasad, grund, isolera tak vid varmvind och totalbyte av fönster är några av dessa. Ibland kan endast en förbättring av energiprestanda inte vara tillräckligt för att motivera en sådan åtgärd, och då bör man vänta. När man väl bygger om så skall man däremot alltid räkna på hur mycket mer det skulle kosta att samtidigt förbättra energiprestandan, i regel tjänar man alltid på det."
                      sortKey:infoSortKey++
              sectionForTable:1
                  sectionName:@"Energikunskap"];
    
    [self addNewInfoWithTitle:@"Minskad miljöpåverkan"
                         text:@"Energibesparande åtgärder leder till en lägre energi- och resursförbrukning, både på samhällets och individens nivå. Hushåll med de resurser vi har leder till en minskad miljöpåverkan och en mer hållbar livsstil."
                      sortKey:infoSortKey++
              sectionForTable:1
                  sectionName:@""];
    
    [self addNewInfoWithTitle:@"Smart möblering"
                         text:@"Stäng inte in element bakom soffor eller sängar utan ge det tillgång till ett bra luftflöde. Ställ heller inte sängar eller sittplatser nära norrsida, då de oftast är kallast. Öppna upp dörrar i huset om Ni eldar i eldstäder, så att värmen sprids."
                      sortKey:infoSortKey++
              sectionForTable:1
                  sectionName:@""];    
    
    [self addNewInfoWithTitle:@"Energibesiktning av expert"
                         text:@"Huset är ett system med många variabler och en del av variablerna finns inte med i EnergiAppen - den är designad att kunna användas av alla. Ett seriöst försök att minska sina energikostnader i större bemärkelse bör föregås av en energibesiktning av energiexpert. Man skall angripa energibesparingen i huset på rätt sätt – det är lätt att göra fel. Se vad man bör tänka på när man anlitar en energiexpert under 'Tips inför energibesiktning'"
                      sortKey:infoSortKey++
              sectionForTable:2
                  sectionName:@"Nästa steg - Energibesiktning"];
    

    
    [self addNewInfoWithTitle:@"Energibesiktning/-deklaration"
                         text:@"En energideklaration har som huvudsyfte att på ett standardiserat sätt visa hur mycket energi ett hus drar. Det är frivilligt för den som utför energibesiktningen att inkludera åtgärdsförslag i rapporten, vilket ofta kan leda till få förslag om man endast beställer en energideklaration utan att närmare förklara vad man önskar.\n\nEn energibesiktning utförs av samma experter men innebär att man undersöker husets prestanda och förbättringsåtgärder. Energideklarationen bör bygga på en komplett energibesiktning, men så är inte alltid fallet.\n\nGör det klart för energiexperten att Ni önskar spara så mycket energi som möjligt. Om denne utför en utförlig energibesiktning kan experten sedan skriva ihop en energideklaration på kort tid. Energideklarationer håller i tio år och krävs vid försäljning av huset, så det är alltid bra att ha.\n\nAckrediterade experter för både energideklaration och energibesiktning finns på www.swedac.se. Där kan Ni hitta en i Er region."
                      sortKey:infoSortKey++
              sectionForTable:2
                  sectionName:@""];
    
    [self addNewInfoWithTitle:@"Be alltid om referenser"
                         text:@"Be alltid om referenser från liknande arbeten och undersök dem. Detta gäller både vid beställning av energibesiktning och när man skall investera i energibesparande åtgärder. Har tidigare kunder haft några problem med fukt, eller sämre inomhusmiljö efter utförda åtgärder? Kanske har det inte inbringat lika stor besparing som utlovat?"
                      sortKey:infoSortKey++
              sectionForTable:2
                  sectionName:@""]; 
    
    [self addNewInfoWithTitle:@"Tips inför energibesiktning"
                         text:@"•Energibesiktning i kalla månader ger ofta bättre resultat då man kan använda värmekamera.\n•Begär referenser för liknande hus innan Ni beställer en energibesiktning.\n•Var tydlig med att Ni önskar en grundlig genomgång och med åtgärdsförslag i syfte att spara så mycket energi som möjligt.\n•Beställ även en energideklaration om det är av intresse.\n•Begär av energiexperten att er rapport skall innehålla\n--Vilken besparing som varje åtgärd medför.\n--Investeringskostnad för varje åtgärd\n--Vilken ordning åtgärdsförslagen skall genomföras i.\n\nInnan besiktningsmannen har gått igenom kan Ni visa de förslag som presenteras här och be dem undersöka dessa under rundvandringen - be sedan om argument för och emot."
                      sortKey:infoSortKey++
              sectionForTable:2
                  sectionName:@""];
    
    [self addNewInfoWithTitle:@"Använd experter"
                         text:@"Ring och prata med kunniga om ämnet, de är ofta hjälpsamma. Var försiktig med att be om råd från någon som tjänar på att inte vara opartisk.\n\nDe flesta kommuner har egna energirådgivare som kan hjälpa dig helt gratis, använd dem. Kontaktuppgifter finns på Er kommuns hemsida."
                      sortKey:infoSortKey++
              sectionForTable:2
                  sectionName:@""];
    
    
    
}


-(void)addSavingsWithTitle:(NSString *)title infoForAudit:(NSString *)infoForAudit infoForUser:(NSString *)infoForUser
{
    NSManagedObjectContext *contextToUse = self.managedObjectContext;
    EASavings *newSavings = [NSEntityDescription
                             insertNewObjectForEntityForName:@"EASavings"
                             inManagedObjectContext:contextToUse];
    
    NSAssert1(newSavings != nil, @"newSavings should not be nil!", nil);
    
    
    newSavings.title = title;
    newSavings.infoForAudit = infoForAudit;
    newSavings.infoToUser = infoForUser;
    
    
    //we always need one financial value here
    [self addNewFinancialToSavings:newSavings];    
}

-(void)addNewFinancialToSavings:(EASavings *)savingsToAddTo
{
    NSManagedObjectContext *contextToUse = self.managedObjectContext;
    EAFinancial *newFinancial = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"EAFinancial"
                                 inManagedObjectContext:contextToUse];
    
    NSAssert1(newFinancial != nil, @"newSavings should not be nil!", nil);
    
    
    newFinancial.cost = [NSNumber numberWithInt:0];
    newFinancial.savings = [NSNumber numberWithInt:0];
    newFinancial.payback = [NSNumber numberWithDouble:0.0];
    newFinancial.unitForTable = @"";
    
    //add to ownerObject
    savingsToAddTo.financial = newFinancial;
    
}

-(void)addNewInfoWithTitle:(NSString*)title text:(NSString*)text sortKey:(NSInteger)sortKey sectionForTable:(NSInteger)section sectionName:(NSString*)sectionName
{
    NSManagedObjectContext *contextToUse = self.managedObjectContext;
    EAInfoToUser *newInfo = [NSEntityDescription
                             insertNewObjectForEntityForName:@"EAInfoToUser"
                             inManagedObjectContext:contextToUse];
    
    NSAssert1(newInfo != nil, @"createdObject should not be nil!", nil);
    
    
    newInfo.title = title;
    newInfo.text = text;
    newInfo.sortKey = [NSNumber numberWithInt:sortKey];
    newInfo.sectionForTable = [NSNumber numberWithInt:section];
    newInfo.sectionName = sectionName;
}

-(void)fillPickerWithStringsFromArray:(NSArray *)array
{
    for (NSString *item in array)
    {
        [self createNewValueForPicker:YES WithValue:item
                          typeOfValue:TypeOfVariableString];
    }
}

-(void)createConditionForPrevousVariableWithTitleEqualTo:(NSString *)varTitle andValueCondition:(NSString *)condition
{
    NSManagedObjectContext *contextToUse = self.managedObjectContext;
    EAVariableCondition *newCond = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"EAVariableCondition"
                                    inManagedObjectContext:contextToUse];
    
    NSAssert1(newCond != nil, @"createdObject should not be nil!", nil);
    
    newCond.condVarTitle = varTitle;
    newCond.condString = condition;
    _recentlyCreatedVariable.conditionToShow = newCond;
}

-(EAVariableCalculator*)variableStorage
{
    if (__variableStorage == nil) {
        __variableStorage = [[EAVariableCalculator alloc] init];
    }
    return __variableStorage;
}

-(NSManagedObjectContext*)managedObjectContext
{
    if (__managedObjectContext == nil) {
        
        EAAppDelegate *appDelegate = (EAAppDelegate*)[UIApplication sharedApplication].delegate;
        __managedObjectContext = appDelegate.managedObjectContext;
    }
    return __managedObjectContext;
}
@end
