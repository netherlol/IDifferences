//
//  Seed.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Seed.h"
#import "Theme+Create.h"
#import "Maze+Manage.h"
#import "DifferenceSet+Manage.h"
#import "Differences+Manage.h"
#import "Difficulty+Manage.h"
#import "Pack+manage.h"

@implementation Seed

+(void)insertDiffs:(int)topX
              topY:(int)topY
             downX:(int)downX
             downY:(int)downY
         diffFotos:(DifferenceSet*)differenceSet
         inContext:(NSManagedObjectContext*)context
{
    [Differences createDifference:[NSNumber numberWithInt:topX] topleftY:[NSNumber numberWithInt:topY] downrightX:[NSNumber numberWithInt:downX] downrightY:[NSNumber numberWithInt:downY] differenceFoto:differenceSet inManagedObjectContext:context];  
}

+(void)populateDatabase:(NSManagedObjectContext *)context
{
    NSString *normalState = @"normal";
    NSString *avalable = @"YES";
    //NSString *NewFotosAvalable = @"YES";
    NSString *NewThemeAvalable = @"YES";
    
    Theme * natureza = [Theme createTheme:@"NATURE" foto:@"theme_box_nature" inManagedObjectContext:context]; natureza.available = NewThemeAvalable;
    Theme * comida =[Theme createTheme:@"FOOD" foto:@"theme_box_food" inManagedObjectContext:context]; comida.available = NewThemeAvalable;
    Theme * animal =[Theme createTheme:@"ANIMAL" foto:@"theme_box_animals" inManagedObjectContext:context]; animal.available = NewThemeAvalable;
    Theme * desporto =[Theme createTheme:@"SPORTS" foto:@"theme_box_sports" inManagedObjectContext:context]; desporto.available = NewThemeAvalable;
    Theme * cidade =[Theme createTheme:@"CITY" foto:@"theme_box_cities" inManagedObjectContext:context]; cidade.available = NewThemeAvalable;
    
    Difficulty *beginner = [Difficulty createDifficulty:@"beginner" inManagedObjectContext:context];
    Difficulty *intermediate = [Difficulty createDifficulty:@"intermediate" inManagedObjectContext:context];
    Difficulty *expert = [Difficulty createDifficulty:@"expert" inManagedObjectContext:context];
    Difficulty *detective = [Difficulty createDifficulty:@"detective" inManagedObjectContext:context];
    
        /***********************************************************************************************************************************************************************
     *
     *
     *                                               THEME - CITIES
     *
     *
     **********************************************************************************************************************************************************************/
    Maze *Bridge = [Maze createMaze:@"Bridge" forTheme:cidade inManagedObjectContext:context];
    Bridge.dificulty = beginner;
    Bridge.state = normalState;
    Bridge.uniqueID = @"T-0002.M-0001";
    Bridge.available = avalable;
    DifferenceSet *BridgeA = [DifferenceSet createDifferenceFoto:@"BridgeA" forMaze:Bridge inManagedObjectContext:context];
    
    [Seed insertDiffs:26 topY:54 downX:42 downY:67  diffFotos:BridgeA inContext:context];
    [Seed insertDiffs:57 topY:39 downX:73 downY:51  diffFotos:BridgeA inContext:context];
    [Seed insertDiffs:11 topY:34 downX:26 downY:46  diffFotos:BridgeA inContext:context];
    [Seed insertDiffs:7 topY:56 downX:22 downY:68  diffFotos:BridgeA inContext:context];
    [Seed insertDiffs:77 topY:32 downX:93 downY:44  diffFotos:BridgeA inContext:context];
    
    Maze *Castle = [Maze createMaze:@"Castle" forTheme:cidade inManagedObjectContext:context];
    Castle.dificulty = beginner;
    Castle.state = normalState;
    Castle.uniqueID = @"T-0002.M-0002";
    Castle.available = avalable;
    DifferenceSet *CastleA = [DifferenceSet createDifferenceFoto:@"CastleA" forMaze:Castle inManagedObjectContext:context];
    
    [Seed insertDiffs:71 topY:4 downX:87 downY:16  diffFotos:CastleA inContext:context];
    [Seed insertDiffs:51 topY:78 downX:66 downY:90  diffFotos:CastleA inContext:context];
    [Seed insertDiffs:41 topY:47 downX:57 downY:59  diffFotos:CastleA inContext:context];
    [Seed insertDiffs:57 topY:19 downX:73 downY:32  diffFotos:CastleA inContext:context];
    [Seed insertDiffs:67 topY:52 downX:82 downY:64  diffFotos:CastleA inContext:context];
    
    Maze *Cityscape = [Maze createMaze:@"Cityscape" forTheme:cidade inManagedObjectContext:context];
    Cityscape.dificulty = beginner;
    Cityscape.state = normalState;
    Cityscape.uniqueID = @"T-0002.M-0003";
    Cityscape.available = avalable;
    DifferenceSet *CityscapeA = [DifferenceSet createDifferenceFoto:@"CityscapeA" forMaze:Cityscape inManagedObjectContext:context];
        
    [Seed insertDiffs:38 topY:62 downX:51 downY:73  diffFotos:CityscapeA inContext:context];
    [Seed insertDiffs:58 topY:72 downX:71 downY:83  diffFotos:CityscapeA inContext:context];
    [Seed insertDiffs:35 topY:80 downX:48 downY:91  diffFotos:CityscapeA inContext:context];
    [Seed insertDiffs:65 topY:50 downX:78 downY:61  diffFotos:CityscapeA inContext:context];
    [Seed insertDiffs:81 topY:63 downX:94 downY:74  diffFotos:CityscapeA inContext:context];
    
    
    Maze *London_BW = [Maze createMaze:@"London_BW" forTheme:cidade inManagedObjectContext:context];
    London_BW.dificulty = detective;
    London_BW.state = normalState;
    London_BW.uniqueID = @"T-0002.M-0010";
    London_BW.available = avalable;
    DifferenceSet *London_BWA = [DifferenceSet createDifferenceFoto:@"London_BWA" forMaze:London_BW inManagedObjectContext:context];
        
    [Seed insertDiffs:13 topY:40 downX:26 downY:51  diffFotos:London_BWA inContext:context];
    [Seed insertDiffs:7 topY:53 downX:21 downY:64  diffFotos:London_BWA inContext:context];
    [Seed insertDiffs:7 topY:69 downX:20 downY:80  diffFotos:London_BWA inContext:context];
    [Seed insertDiffs:34 topY:88 downX:47 downY:99  diffFotos:London_BWA inContext:context];
    [Seed insertDiffs:64 topY:75 downX:77 downY:86  diffFotos:London_BWA inContext:context];
    
    Maze *busystreet = [Maze createMaze:@"Busy_Street" forTheme:cidade inManagedObjectContext:context];
    busystreet.dificulty = detective;
    busystreet.state = normalState;
    busystreet.uniqueID = @"T-0002.M-0012";
    busystreet.available = avalable;
    DifferenceSet *Busy_StreetA = [DifferenceSet createDifferenceFoto:@"Busy_StreetA" forMaze:busystreet inManagedObjectContext:context];
    
    [Seed insertDiffs:53 topY:44 downX:68 downY:56  diffFotos:Busy_StreetA inContext:context];
    [Seed insertDiffs:29 topY:22 downX:45 downY:34  diffFotos:Busy_StreetA inContext:context];
    [Seed insertDiffs:29 topY:40 downX:44 downY:53  diffFotos:Busy_StreetA inContext:context];
    [Seed insertDiffs:3 topY:56 downX:19 downY:69  diffFotos:Busy_StreetA inContext:context];
    [Seed insertDiffs:27 topY:70 downX:42 downY:82  diffFotos:Busy_StreetA inContext:context];
    
    Maze *Modis_Building = [Maze createMaze:@"Modis_Building" forTheme:cidade inManagedObjectContext:context];
    Modis_Building.dificulty = expert;
    Modis_Building.state = normalState;
    Modis_Building.uniqueID = @"T-0002.M-0009";
    Modis_Building.available = avalable;
    DifferenceSet *Modis_BuildingA = [DifferenceSet createDifferenceFoto:@"Modis_BuildingA" forMaze:Modis_Building inManagedObjectContext:context];
    
    [Seed insertDiffs:3 topY:38 downX:18 downY:50  diffFotos:Modis_BuildingA inContext:context];
    [Seed insertDiffs:32 topY:19 downX:47 downY:31  diffFotos:Modis_BuildingA inContext:context];
    [Seed insertDiffs:51 topY:30 downX:66 downY:42  diffFotos:Modis_BuildingA inContext:context];
    [Seed insertDiffs:83 topY:26 downX:98 downY:39  diffFotos:Modis_BuildingA inContext:context];
    [Seed insertDiffs:74 topY:60 downX:89 downY:72  diffFotos:Modis_BuildingA inContext:context];
    
    Maze *Monaco = [Maze createMaze:@"Monaco" forTheme:cidade inManagedObjectContext:context];
    Monaco.dificulty = detective;
    Monaco.state = normalState;
    Monaco.uniqueID = @"T-0002.M-0011";
    Monaco.available = avalable;
    DifferenceSet *MonacoA = [DifferenceSet createDifferenceFoto:@"MonacoA" forMaze:Monaco inManagedObjectContext:context];
    
    [Seed insertDiffs:74 topY:80 downX:87 downY:90  diffFotos:MonacoA inContext:context];
    [Seed insertDiffs:51 topY:79 downX:65 downY:89  diffFotos:MonacoA inContext:context];
    [Seed insertDiffs:30 topY:48 downX:43 downY:58  diffFotos:MonacoA inContext:context];
    [Seed insertDiffs:13 topY:29 downX:26 downY:40  diffFotos:MonacoA inContext:context];
    [Seed insertDiffs:26 topY:6 downX:39 downY:16  diffFotos:MonacoA inContext:context]; 
    
    Maze *NewYork_Flatiron = [Maze createMaze:@"NewYork" forTheme:cidade inManagedObjectContext:context];
    NewYork_Flatiron.dificulty = intermediate;
    NewYork_Flatiron.state = normalState;
    NewYork_Flatiron.uniqueID = @"T-0002.M-0004";
    NewYork_Flatiron.available = avalable;
    DifferenceSet *NewYork_FlatironA = [DifferenceSet createDifferenceFoto:@"NewYorkA" forMaze:NewYork_Flatiron inManagedObjectContext:context];
    
    [Seed insertDiffs:67.948715 topY:5.176668 downX:82.478630 downY:13.459335  diffFotos:NewYork_FlatironA inContext:context];
    [Seed insertDiffs:84.615379 topY:56.253117 downX:95.726494 downY:66.261345  diffFotos:NewYork_FlatironA inContext:context];
    [Seed insertDiffs:30.769232 topY:76.269569 downX:43.589745 downY:87.313118  diffFotos:NewYork_FlatironA inContext:context];
    [Seed insertDiffs:74.358978 topY:76.614677 downX:88.461533 downY:86.277794  diffFotos:NewYork_FlatironA inContext:context];
    [Seed insertDiffs:38.888885 topY:55.217785 downX:51.709400 downY:66.606453  diffFotos:NewYork_FlatironA inContext:context];
    
    Maze *Night_City = [Maze createMaze:@"Night_City" forTheme:cidade inManagedObjectContext:context];
    Night_City.dificulty = intermediate;
    Night_City.state = normalState;
    Night_City.uniqueID = @"T-0002.M-0005";
    Night_City.available = avalable;
    DifferenceSet *Night_CityA = [DifferenceSet createDifferenceFoto:@"Night_CityA" forMaze:Night_City inManagedObjectContext:context];
    
    [Seed insertDiffs:22.649570 topY:11.043557 downX:35.470085 downY:21.396893  diffFotos:Night_CityA inContext:context];
    [Seed insertDiffs:44.017094 topY:15.875113 downX:63.675213 downY:24.848005  diffFotos:Night_CityA inContext:context];
    [Seed insertDiffs:47.863247 topY:29.679558 downX:61.111111 downY:40.032894  diffFotos:Night_CityA inContext:context];
    [Seed insertDiffs:82.478630 topY:20.361559 downX:96.153847 downY:28.644224  diffFotos:Night_CityA inContext:context];
    [Seed insertDiffs:62.393166 topY:68.677124 downX:73.931625 downY:80.756012  diffFotos:Night_CityA inContext:context];
    
    Maze *Old_Houses = [Maze createMaze:@"Old_Houses" forTheme:cidade inManagedObjectContext:context];
    Old_Houses.dificulty = intermediate;
    Old_Houses.state = normalState;
    Old_Houses.uniqueID = @"T-0002.M-0006";
    Old_Houses.available = avalable;
    DifferenceSet *Old_HousesA = [DifferenceSet createDifferenceFoto:@"Old_HousesA" forMaze:Old_Houses inManagedObjectContext:context];
    
    [Seed insertDiffs:47 topY:22 downX:63 downY:35  diffFotos:Old_HousesA inContext:context];
    [Seed insertDiffs:55 topY:56 downX:70 downY:68  diffFotos:Old_HousesA inContext:context];
    [Seed insertDiffs:68 topY:36 downX:84 downY:48  diffFotos:Old_HousesA inContext:context];
    [Seed insertDiffs:25 topY:58 downX:40 downY:70  diffFotos:Old_HousesA inContext:context];
    [Seed insertDiffs:8 topY:43 downX:23 downY:55  diffFotos:Old_HousesA inContext:context];
    
    Maze *Small_Street = [Maze createMaze:@"Small_Street" forTheme:cidade inManagedObjectContext:context];
    Small_Street.dificulty = expert;
    Small_Street.state = normalState;
    Small_Street.uniqueID = @"T-0002.M-0007";
    Small_Street.available = avalable;
    DifferenceSet *Small_StreetA = [DifferenceSet createDifferenceFoto:@"Small_StreetA" forMaze:Small_Street inManagedObjectContext:context];

    [Seed insertDiffs:47 topY:15 downX:62 downY:27  diffFotos:Small_StreetA inContext:context];
    [Seed insertDiffs:34 topY:47 downX:50 downY:60  diffFotos:Small_StreetA inContext:context];
    [Seed insertDiffs:52 topY:45 downX:67 downY:58  diffFotos:Small_StreetA inContext:context];
    [Seed insertDiffs:34 topY:82 downX:50 downY:94  diffFotos:Small_StreetA inContext:context];
    [Seed insertDiffs:81 topY:79 downX:96 downY:91  diffFotos:Small_StreetA inContext:context];
    
    Maze *Sunset_Crane = [Maze createMaze:@"Sunset_Crane" forTheme:cidade inManagedObjectContext:context];
    Sunset_Crane.dificulty = expert;
    Sunset_Crane.state = normalState;
    Sunset_Crane.uniqueID = @"T-0002.M-0008";
    Sunset_Crane.available = avalable;
    DifferenceSet *Sunset_CraneA = [DifferenceSet createDifferenceFoto:@"Sunset_CraneA" forMaze:Sunset_Crane inManagedObjectContext:context];

    
    [Seed insertDiffs:14 topY:52 downX:27 downY:63  diffFotos:Sunset_CraneA inContext:context];
    [Seed insertDiffs:26 topY:41 downX:39 downY:52  diffFotos:Sunset_CraneA inContext:context];
    [Seed insertDiffs:44 topY:61 downX:57 downY:72  diffFotos:Sunset_CraneA inContext:context];
    [Seed insertDiffs:58 topY:47 downX:72 downY:58  diffFotos:Sunset_CraneA inContext:context];
    [Seed insertDiffs:84 topY:53 downX:97 downY:64  diffFotos:Sunset_CraneA inContext:context];
    
    /***********************************************************************************************************************************************************************
     *
     *
     *                                               THEME - SPORT
     *
     *
     **********************************************************************************************************************************************************************/
    Maze *baseball = [Maze createMaze:@"baseball" forTheme:desporto inManagedObjectContext:context];
    baseball.dificulty = detective;
    baseball.state = normalState;
    baseball.uniqueID = @"T-0004.M-0011";
    baseball.available = avalable;
    DifferenceSet *baseballA = [DifferenceSet createDifferenceFoto:@"baseballA" forMaze:baseball inManagedObjectContext:context];
    
    [Seed insertDiffs:16 topY:30 downX:29 downY:41  diffFotos:baseballA inContext:context];
    [Seed insertDiffs:12 topY:43 downX:25 downY:53  diffFotos:baseballA inContext:context];
    [Seed insertDiffs:52 topY:43 downX:65 downY:53  diffFotos:baseballA inContext:context];
    [Seed insertDiffs:69 topY:77 downX:83 downY:88  diffFotos:baseballA inContext:context];
    [Seed insertDiffs:25 topY:80 downX:38 downY:91  diffFotos:baseballA inContext:context];

    
    Maze *cowrace = [Maze createMaze:@"cowrace" forTheme:desporto inManagedObjectContext:context];
    cowrace.dificulty = beginner;
    cowrace.state = normalState;
    cowrace.uniqueID = @"T-0004.M-0001";
    cowrace.available = avalable;
    DifferenceSet *cowraceA = [DifferenceSet createDifferenceFoto:@"cowraceA" forMaze:cowrace inManagedObjectContext:context];
    
    [Seed insertDiffs:32 topY:5 downX:47 downY:18  diffFotos:cowraceA inContext:context];
    [Seed insertDiffs:27 topY:31 downX:42 downY:43  diffFotos:cowraceA inContext:context];
    [Seed insertDiffs:7 topY:44 downX:22 downY:57  diffFotos:cowraceA inContext:context];
    [Seed insertDiffs:61 topY:53 downX:77 downY:65  diffFotos:cowraceA inContext:context];
    [Seed insertDiffs:50 topY:81 downX:65 downY:93  diffFotos:cowraceA inContext:context];

    
    Maze *cycling = [Maze createMaze:@"cycling" forTheme:desporto inManagedObjectContext:context];
    cycling.dificulty = expert;
    cycling.state = normalState;
    cycling.uniqueID = @"T-0004.M-0009";
    cycling.available = avalable;
    DifferenceSet *cyclingA = [DifferenceSet createDifferenceFoto:@"cyclingA" forMaze:cycling inManagedObjectContext:context];
   
    [Seed insertDiffs:4 topY:41 downX:18 downY:52  diffFotos:cyclingA inContext:context];
    [Seed insertDiffs:25 topY:44 downX:39 downY:55  diffFotos:cyclingA inContext:context];
    [Seed insertDiffs:41 topY:56 downX:55 downY:66  diffFotos:cyclingA inContext:context];
    [Seed insertDiffs:48 topY:37 downX:61 downY:48  diffFotos:cyclingA inContext:context];
    [Seed insertDiffs:64 topY:47 downX:77 downY:58  diffFotos:cyclingA inContext:context];
    
    Maze *diver = [Maze createMaze:@"diver" forTheme:desporto inManagedObjectContext:context];
    diver.dificulty = expert;
    diver.state = normalState;
    diver.uniqueID = @"T-0004.M-0008";
    diver.available = avalable;
    DifferenceSet *diverA = [DifferenceSet createDifferenceFoto:@"diverA" forMaze:diver inManagedObjectContext:context];
    
    [Seed insertDiffs:60 topY:5 downX:75 downY:17  diffFotos:diverA inContext:context];
    [Seed insertDiffs:37 topY:24 downX:52 downY:36  diffFotos:diverA inContext:context];
    [Seed insertDiffs:8 topY:29 downX:24 downY:41  diffFotos:diverA inContext:context];
    [Seed insertDiffs:9 topY:55 downX:24 downY:67  diffFotos:diverA inContext:context];
    [Seed insertDiffs:68 topY:57 downX:84 downY:69  diffFotos:diverA inContext:context];

    
    Maze *football = [Maze createMaze:@"football" forTheme:desporto inManagedObjectContext:context];
    football.dificulty = beginner;
    football.state = normalState;
    football.uniqueID = @"T-0004.M-0003";
    football.available = avalable;
    DifferenceSet *footballA = [DifferenceSet createDifferenceFoto:@"footballA" forMaze:football inManagedObjectContext:context];

    [Seed insertDiffs:15 topY:27 downX:30 downY:39  diffFotos:footballA inContext:context];
    [Seed insertDiffs:36 topY:19 downX:51 downY:31  diffFotos:footballA inContext:context];
    [Seed insertDiffs:53 topY:39 downX:68 downY:51  diffFotos:footballA inContext:context];
    [Seed insertDiffs:79 topY:23 downX:94 downY:35  diffFotos:footballA inContext:context];
    [Seed insertDiffs:71 topY:85 downX:86 downY:97  diffFotos:footballA inContext:context];
    
    Maze *golfer = [Maze createMaze:@"golfer" forTheme:desporto inManagedObjectContext:context];
    golfer.dificulty = intermediate;
    golfer.state = normalState;
    golfer.uniqueID = @"T-0004.M-0006";
    golfer.available = avalable;
    DifferenceSet *golferA = [DifferenceSet createDifferenceFoto:@"golferA" forMaze:golfer inManagedObjectContext:context];
  
    [Seed insertDiffs:6 topY:2 downX:17 downY:18  diffFotos:golferA inContext:context];
    [Seed insertDiffs:70 topY:31 downX:83 downY:42  diffFotos:golferA inContext:context];
    [Seed insertDiffs:54 topY:50 downX:67 downY:61  diffFotos:golferA inContext:context];
    [Seed insertDiffs:76 topY:80 downX:89 downY:91  diffFotos:golferA inContext:context];
    [Seed insertDiffs:20 topY:77 downX:33 downY:88  diffFotos:golferA inContext:context];
    
    Maze *rider = [Maze createMaze:@"rider" forTheme:desporto inManagedObjectContext:context];
    rider.dificulty = intermediate;
    rider.state = normalState;
    rider.uniqueID = @"T-0004.M-0005";
    rider.available = avalable;
    DifferenceSet *riderA = [DifferenceSet createDifferenceFoto:@"riderA" forMaze:rider inManagedObjectContext:context];
 
    [Seed insertDiffs:2 topY:43 downX:15 downY:54  diffFotos:riderA inContext:context];
    [Seed insertDiffs:19 topY:17 downX:32 downY:28  diffFotos:riderA inContext:context];
    [Seed insertDiffs:80 topY:45 downX:94 downY:60  diffFotos:riderA inContext:context];
    [Seed insertDiffs:3 topY:87 downX:17 downY:97  diffFotos:riderA inContext:context];
    [Seed insertDiffs:68 topY:79 downX:81 downY:90  diffFotos:riderA inContext:context];

    
    Maze *skating = [Maze createMaze:@"skating" forTheme:desporto inManagedObjectContext:context];
    skating.dificulty = detective;
    skating.state = normalState;
    skating.uniqueID = @"T-0004.M-0012";
    skating.available = avalable;
    DifferenceSet *skatingA = [DifferenceSet createDifferenceFoto:@"skatingA" forMaze:skating inManagedObjectContext:context];
    
    [Seed insertDiffs:58 topY:65 downX:73 downY:77  diffFotos:skatingA inContext:context];
    [Seed insertDiffs:30 topY:54 downX:45 downY:67  diffFotos:skatingA inContext:context];
    [Seed insertDiffs:74 topY:50 downX:89 downY:62  diffFotos:skatingA inContext:context];
    [Seed insertDiffs:53 topY:49 downX:69 downY:61  diffFotos:skatingA inContext:context];
    [Seed insertDiffs:25 topY:13 downX:40 downY:25  diffFotos:skatingA inContext:context];

    
    Maze *soccer = [Maze createMaze:@"soccer" forTheme:desporto inManagedObjectContext:context];
    soccer.dificulty = detective;
    soccer.state = normalState;
    soccer.uniqueID = @"T-0004.M-0010";
    soccer.available = avalable;
    DifferenceSet *soccerA = [DifferenceSet createDifferenceFoto:@"soccerA" forMaze:soccer inManagedObjectContext:context];
    
    [Seed insertDiffs:84 topY:20 downX:97 downY:30  diffFotos:soccerA inContext:context];
    [Seed insertDiffs:57 topY:23 downX:70 downY:34  diffFotos:soccerA inContext:context];
    [Seed insertDiffs:15 topY:34 downX:28 downY:44  diffFotos:soccerA inContext:context];
    [Seed insertDiffs:24 topY:62 downX:37 downY:73  diffFotos:soccerA inContext:context];
    [Seed insertDiffs:75 topY:80 downX:88 downY:90  diffFotos:soccerA inContext:context];

    Maze *stadium = [Maze createMaze:@"stadium" forTheme:desporto inManagedObjectContext:context];
    stadium.dificulty = beginner;
    stadium.state = normalState;
    stadium.uniqueID = @"T-0004.M-0002";
    stadium.available = avalable;
    DifferenceSet *stadiumA = [DifferenceSet createDifferenceFoto:@"stadiumA" forMaze:stadium inManagedObjectContext:context];
    
    [Seed insertDiffs:32 topY:27 downX:48 downY:40  diffFotos:stadiumA inContext:context];
    [Seed insertDiffs:65 topY:20 downX:80 downY:32  diffFotos:stadiumA inContext:context];
    [Seed insertDiffs:19 topY:47 downX:34 downY:59  diffFotos:stadiumA inContext:context];
    [Seed insertDiffs:51 topY:70 downX:66 downY:82  diffFotos:stadiumA inContext:context];
    [Seed insertDiffs:76 topY:81 downX:92 downY:94  diffFotos:stadiumA inContext:context];
    
    Maze *surfer = [Maze createMaze:@"surfer" forTheme:desporto inManagedObjectContext:context];
    surfer.dificulty = expert;
    surfer.state = normalState;
    surfer.uniqueID = @"T-0004.M-0007";
    surfer.available = avalable;
    DifferenceSet *surferA = [DifferenceSet createDifferenceFoto:@"surferA" forMaze:surfer inManagedObjectContext:context];
    
    [Seed insertDiffs:38.461536 topY:35.546448 downX:53.418804 downY:45.899784  diffFotos:surferA inContext:context];
    [Seed insertDiffs:62.820511 topY:38.307339 downX:76.495728 downY:46.935116  diffFotos:surferA inContext:context];
    [Seed insertDiffs:82.478630 topY:38.997562 downX:98.290596 downY:50.386230  diffFotos:surferA inContext:context];
    [Seed insertDiffs:64.529915 topY:60.739563 downX:87.606834 downY:76.959785  diffFotos:surferA inContext:context];
    [Seed insertDiffs:21.367519 topY:49.696011 downX:44.017094 downY:63.500450  diffFotos:surferA inContext:context];  
    
    Maze *swimming = [Maze createMaze:@"swimming" forTheme:desporto inManagedObjectContext:context];
    swimming.dificulty = intermediate;
    swimming.state = normalState;
    swimming.uniqueID = @"T-0004.M-0004";
    swimming.available = avalable;
    DifferenceSet *swimmingA = [DifferenceSet createDifferenceFoto:@"swimmingA" forMaze:swimming inManagedObjectContext:context];
    
    [Seed insertDiffs:3 topY:24 downX:16 downY:35  diffFotos:swimmingA inContext:context];
    [Seed insertDiffs:29 topY:51 downX:43 downY:62  diffFotos:swimmingA inContext:context];
    [Seed insertDiffs:40 topY:16 downX:53 downY:27  diffFotos:swimmingA inContext:context];
    [Seed insertDiffs:68 topY:35 downX:81 downY:46  diffFotos:swimmingA inContext:context];
    [Seed insertDiffs:78 topY:54 downX:91 downY:65  diffFotos:swimmingA inContext:context];
    
    /***********************************************************************************************************************************************************************
     *
     *
     *                                               THEME - NATURE
     *
     *
     **********************************************************************************************************************************************************************/
    Maze *deepwoods = [Maze createMaze:@"deepwoods" forTheme:natureza inManagedObjectContext:context];
    deepwoods.dificulty = intermediate;
    deepwoods.state = normalState;
    deepwoods.uniqueID = @"T-0005.M-0005";
    deepwoods.available = avalable;
    DifferenceSet *deepwoodsA = [DifferenceSet createDifferenceFoto:@"deepwoodsA" forMaze:deepwoods inManagedObjectContext:context];
    
    [Seed insertDiffs:2.136752 topY:13.804446 downX:13.675215 downY:31.750225  diffFotos:deepwoodsA inContext:context];
    [Seed insertDiffs:22.649570 topY:31.060005 downX:39.316238 downY:49.350899  diffFotos:deepwoodsA inContext:context];
    [Seed insertDiffs:44.017094 topY:23.467558 downX:59.829056 downY:42.448673  diffFotos:deepwoodsA inContext:context];
    [Seed insertDiffs:32.905979 topY:62.465118 downX:49.145298 downY:74.544006  diffFotos:deepwoodsA inContext:context];
    [Seed insertDiffs:53.846149 topY:76.269569 downX:75.641022 downY:84.897346  diffFotos:deepwoodsA inContext:context]; 
    
    Maze *forest = [Maze createMaze:@"forest" forTheme:natureza inManagedObjectContext:context];
    forest.dificulty = beginner;
    forest.state = normalState;
    forest.uniqueID = @"T-0005.M-0001";
    forest.available = avalable;
    DifferenceSet *forestA = [DifferenceSet createDifferenceFoto:@"forestA" forMaze:forest inManagedObjectContext:context];
        
    [Seed insertDiffs:66 topY:75 downX:81 downY:87  diffFotos:forestA inContext:context];
    [Seed insertDiffs:26 topY:77 downX:40 downY:89  diffFotos:forestA inContext:context];
    [Seed insertDiffs:36 topY:60 downX:51 downY:72  diffFotos:forestA inContext:context];
    [Seed insertDiffs:67 topY:57 downX:82 downY:69  diffFotos:forestA inContext:context];
    [Seed insertDiffs:10 topY:21 downX:25 downY:34  diffFotos:forestA inContext:context];
    
    Maze *lighthouse = [Maze createMaze:@"lighthouse" forTheme:natureza inManagedObjectContext:context];
    lighthouse.dificulty = detective;
    lighthouse.state = normalState;
    lighthouse.uniqueID = @"T-0005.M-0012";
    lighthouse.available = avalable;
    DifferenceSet *lighthouseA = [DifferenceSet createDifferenceFoto:@"lighthouseA" forMaze:lighthouse inManagedObjectContext:context];
        
    [Seed insertDiffs:43 topY:37 downX:59 downY:49  diffFotos:lighthouseA inContext:context];
    [Seed insertDiffs:67 topY:52 downX:82 downY:65  diffFotos:lighthouseA inContext:context];
    [Seed insertDiffs:9 topY:37 downX:24 downY:50  diffFotos:lighthouseA inContext:context];
    [Seed insertDiffs:6 topY:57 downX:21 downY:69  diffFotos:lighthouseA inContext:context];
    [Seed insertDiffs:49 topY:72 downX:65 downY:85  diffFotos:lighthouseA inContext:context];
    
    Maze *longbeach = [Maze createMaze:@"longbeach" forTheme:natureza inManagedObjectContext:context];
    longbeach.dificulty = expert;
    longbeach.state = normalState;
    longbeach.uniqueID = @"T-0005.M-0008";
    longbeach.available = avalable;
    DifferenceSet *longbeachA = [DifferenceSet createDifferenceFoto:@"longbeachA" forMaze:longbeach inManagedObjectContext:context];
        
    [Seed insertDiffs:27 topY:84 downX:40 downY:95  diffFotos:longbeachA inContext:context];
    [Seed insertDiffs:49 topY:64 downX:62 downY:75  diffFotos:longbeachA inContext:context];
    [Seed insertDiffs:18 topY:19 downX:38 downY:30  diffFotos:longbeachA inContext:context];
    [Seed insertDiffs:46 topY:29 downX:62 downY:40  diffFotos:longbeachA inContext:context];
    [Seed insertDiffs:69 topY:44 downX:88 downY:57  diffFotos:longbeachA inContext:context];
    
    Maze *pathforest = [Maze createMaze:@"pathforest" forTheme:natureza inManagedObjectContext:context];
    pathforest.dificulty = expert;
    pathforest.state = normalState;
    pathforest.uniqueID = @"T-0005.M-0009";
    pathforest.available = avalable;
    DifferenceSet *pathforestA = [DifferenceSet createDifferenceFoto:@"pathforestA" forMaze:pathforest inManagedObjectContext:context];
        
    [Seed insertDiffs:4.273504 topY:35.546448 downX:22.649570 downY:43.484005  diffFotos:pathforestA inContext:context];
    [Seed insertDiffs:29.487177 topY:26.918671 downX:42.735039 downY:39.342670  diffFotos:pathforestA inContext:context];
    [Seed insertDiffs:44.444447 topY:44.519341 downX:60.256405 downY:53.147118  diffFotos:pathforestA inContext:context];
    [Seed insertDiffs:77.350426 topY:15.184891 downX:88.888893 downY:24.848005  diffFotos:pathforestA inContext:context];
    [Seed insertDiffs:23.931623 topY:68.677124 downX:51.282047 downY:77.995125  diffFotos:pathforestA inContext:context];
    
    Maze *smallhouses = [Maze createMaze:@"smallhouses" forTheme:natureza inManagedObjectContext:context];
    smallhouses.dificulty = detective;
    smallhouses.state = normalState;
    smallhouses.uniqueID = @"T-0005.M-0011";
    smallhouses.available = avalable;
    DifferenceSet *smallhousesA = [DifferenceSet createDifferenceFoto:@"smallhousesA" forMaze:smallhouses inManagedObjectContext:context];
    
    [Seed insertDiffs:76 topY:7 downX:89 downY:17  diffFotos:smallhousesA inContext:context];
    [Seed insertDiffs:47 topY:60 downX:60 downY:71  diffFotos:smallhousesA inContext:context];
    [Seed insertDiffs:83 topY:65 downX:96 downY:75  diffFotos:smallhousesA inContext:context];
    [Seed insertDiffs:37 topY:83 downX:50 downY:94  diffFotos:smallhousesA inContext:context];
    [Seed insertDiffs:73 topY:81 downX:87 downY:92  diffFotos:smallhousesA inContext:context];
    
    Maze *smallriver = [Maze createMaze:@"smallriver" forTheme:natureza inManagedObjectContext:context];
    smallriver.dificulty = beginner;
    smallriver.state = normalState;
    smallriver.uniqueID = @"T-0005.M-0002";
    smallriver.available = avalable;
    DifferenceSet *smallriverA = [DifferenceSet createDifferenceFoto:@"smallriverA" forMaze:smallriver inManagedObjectContext:context];
    
    [Seed insertDiffs:61 topY:81 downX:76 downY:93  diffFotos:smallriverA inContext:context];
    [Seed insertDiffs:27 topY:36 downX:42 downY:48  diffFotos:smallriverA inContext:context];
    [Seed insertDiffs:74 topY:13 downX:89 downY:25  diffFotos:smallriverA inContext:context];
    [Seed insertDiffs:49 topY:4 downX:65 downY:16  diffFotos:smallriverA inContext:context];
    [Seed insertDiffs:51 topY:40 downX:66 downY:53  diffFotos:smallriverA inContext:context];
    
    Maze *snowymountains = [Maze createMaze:@"mountains" forTheme:natureza inManagedObjectContext:context];
    snowymountains.dificulty = expert;
    snowymountains.state = normalState;
    snowymountains.uniqueID = @"T-0005.M-0007";
    snowymountains.available = avalable;
    DifferenceSet *snowymountainsA = [DifferenceSet createDifferenceFoto:@"mountainsA" forMaze:snowymountains inManagedObjectContext:context];
    
    [Seed insertDiffs:69 topY:51 downX:84 downY:63  diffFotos:snowymountainsA inContext:context];
    [Seed insertDiffs:8 topY:55 downX:23 downY:68  diffFotos:snowymountainsA inContext:context];
    [Seed insertDiffs:42 topY:67 downX:57 downY:79  diffFotos:snowymountainsA inContext:context];
    [Seed insertDiffs:23 topY:85 downX:39 downY:97  diffFotos:snowymountainsA inContext:context];
    [Seed insertDiffs:62 topY:25 downX:77 downY:37  diffFotos:snowymountainsA inContext:context];
    
    Maze *sunflowers = [Maze createMaze:@"sunflowers" forTheme:natureza inManagedObjectContext:context];
    sunflowers.dificulty = detective;
    sunflowers.state = normalState;
    sunflowers.uniqueID = @"T-0005.M-0010";
    sunflowers.available = avalable;
    DifferenceSet *sunflowersA = [DifferenceSet createDifferenceFoto:@"sunflowersA" forMaze:sunflowers inManagedObjectContext:context];
    
    [Seed insertDiffs:70 topY:27 downX:85 downY:40  diffFotos:sunflowersA inContext:context];
    [Seed insertDiffs:42 topY:29 downX:58 downY:41  diffFotos:sunflowersA inContext:context];
    [Seed insertDiffs:41 topY:60 downX:56 downY:72  diffFotos:sunflowersA inContext:context];
    [Seed insertDiffs:15 topY:65 downX:30 downY:77  diffFotos:sunflowersA inContext:context];
    [Seed insertDiffs:11 topY:3 downX:27 downY:15  diffFotos:sunflowersA inContext:context];
    
    Maze *sunsetshore = [Maze createMaze:@"sunsetshore" forTheme:natureza inManagedObjectContext:context];
    sunsetshore.dificulty = beginner;
    sunsetshore.state = normalState;
    sunsetshore.uniqueID = @"T-0005.M-0003";
    sunsetshore.available = avalable;
    DifferenceSet *sunsetshoreA = [DifferenceSet createDifferenceFoto:@"sunsetshoreA" forMaze:sunsetshore inManagedObjectContext:context];
    
    [Seed insertDiffs:10.683760 topY:14.494668 downX:28.205130 downY:24.502892  diffFotos:sunsetshoreA inContext:context];
    [Seed insertDiffs:46.153843 topY:28.989336 downX:58.547009 downY:39.342670  diffFotos:sunsetshoreA inContext:context];
    [Seed insertDiffs:60.683758 topY:39.687782 downX:79.059830 downY:48.660671  diffFotos:sunsetshoreA inContext:context];
    [Seed insertDiffs:29.914528 topY:59.014004 downX:49.572647 downY:70.057571  diffFotos:sunsetshoreA inContext:context];
    [Seed insertDiffs:64.102562 topY:80.065788 downX:83.760681 downY:92.489792  diffFotos:sunsetshoreA inContext:context];
    
    Maze *urbanpark = [Maze createMaze:@"urbanpark" forTheme:natureza inManagedObjectContext:context];
    urbanpark.dificulty = intermediate;
    urbanpark.state = normalState;
    urbanpark.uniqueID = @"T-0005.M-0006";
    urbanpark.available = avalable;
    DifferenceSet *urbanparkA = [DifferenceSet createDifferenceFoto:@"urbanparkA" forMaze:urbanpark inManagedObjectContext:context];
    
    [Seed insertDiffs:23 topY:22 downX:36 downY:33  diffFotos:urbanparkA inContext:context];
    [Seed insertDiffs:45 topY:21 downX:58 downY:32  diffFotos:urbanparkA inContext:context];
    [Seed insertDiffs:70 topY:23 downX:84 downY:34  diffFotos:urbanparkA inContext:context];
    [Seed insertDiffs:22 topY:58 downX:36 downY:69  diffFotos:urbanparkA inContext:context];
    [Seed insertDiffs:19 topY:87 downX:36 downY:99  diffFotos:urbanparkA inContext:context];
    
    Maze *waterfalls = [Maze createMaze:@"waterfalls" forTheme:natureza inManagedObjectContext:context];
    waterfalls.dificulty = intermediate;
    waterfalls.state = normalState;
    waterfalls.uniqueID = @"T-0005.M-0004";
    waterfalls.available = avalable;
    DifferenceSet *waterfallsA = [DifferenceSet createDifferenceFoto:@"waterfallsA" forMaze:waterfalls inManagedObjectContext:context];
    
    [Seed insertDiffs:8.974359 topY:35.891560 downX:22.649570 downY:47.625340  diffFotos:waterfallsA inContext:context];
    [Seed insertDiffs:8.974359 topY:73.163567 downX:27.777779 downY:85.242455  diffFotos:waterfallsA inContext:context];
    [Seed insertDiffs:44.017094 topY:73.163567 downX:67.094009 downY:86.622910  diffFotos:waterfallsA inContext:context];
    [Seed insertDiffs:66.666664 topY:44.519341 downX:86.752136 downY:59.704231  diffFotos:waterfallsA inContext:context];
    [Seed insertDiffs:79.059830 topY:25.538227 downX:97.008545 downY:37.962227  diffFotos:waterfallsA inContext:context];
    
    /***********************************************************************************************************************************************************************
     *
     *
     *                                               THEME - ANIMAL
     *
     *
     **********************************************************************************************************************************************************************/
    Maze *birds = [Maze createMaze:@"birds" forTheme:animal inManagedObjectContext:context];
    birds.dificulty = beginner;
    birds.state = normalState;
    birds.uniqueID = @"T-0001.M-0001";
    birds.available = avalable;
    DifferenceSet *birdsA = [DifferenceSet createDifferenceFoto:@"birdsA" forMaze:birds inManagedObjectContext:context];
    [Seed insertDiffs:10 topY:21 downX:24 downY:32  diffFotos:birdsA inContext:context];
    [Seed insertDiffs:29 topY:41 downX:42 downY:52  diffFotos:birdsA inContext:context];
    [Seed insertDiffs:52 topY:32 downX:65 downY:42  diffFotos:birdsA inContext:context];
    [Seed insertDiffs:84 topY:46 downX:98 downY:57  diffFotos:birdsA inContext:context];
    [Seed insertDiffs:36 topY:70 downX:49 downY:81  diffFotos:birdsA inContext:context];
    
    Maze *butterfly = [Maze createMaze:@"butterfly" forTheme:animal inManagedObjectContext:context];
    butterfly.dificulty = detective;
    butterfly.state = normalState;
    butterfly.uniqueID = @"T-0001.M-0010";
    butterfly.available = avalable;
    DifferenceSet *butterflyA = [DifferenceSet createDifferenceFoto:@"butterflyA" forMaze:butterfly inManagedObjectContext:context];
    
    [Seed insertDiffs:54.700859 topY:14.494668 downX:67.094009 downY:25.193115  diffFotos:butterflyA inContext:context];
    [Seed insertDiffs:56.410259 topY:35.201340 downX:73.504272 downY:50.041122  diffFotos:butterflyA inContext:context];
    [Seed insertDiffs:26.068375 topY:44.519341 downX:44.017094 downY:61.084675  diffFotos:butterflyA inContext:context];
    [Seed insertDiffs:31.196583 topY:73.163567 downX:54.273502 downY:89.728905  diffFotos:butterflyA inContext:context];
    [Seed insertDiffs:72.649567 topY:80.410904 downX:88.034187 downY:93.870232  diffFotos:butterflyA inContext:context];

    
    
    Maze *Elephant = [Maze createMaze:@"elephant" forTheme:animal inManagedObjectContext:context];
    Elephant.dificulty = beginner;
    Elephant.state = normalState;
    Elephant.uniqueID = @"T-0001.M-0003";
    Elephant.available = avalable;
    DifferenceSet *ElephantA = [DifferenceSet createDifferenceFoto:@"elephantA" forMaze:Elephant inManagedObjectContext:context];
       
    [Seed insertDiffs:38.461536 topY:35.891560 downX:62.393166 downY:46.244896  diffFotos:ElephantA inContext:context];
    [Seed insertDiffs:41.025642 topY:55.562897 downX:58.974354 downY:66.606453  diffFotos:ElephantA inContext:context];
    [Seed insertDiffs:33.333332 topY:77.995125 downX:53.846149 downY:90.764236  diffFotos:ElephantA inContext:context];
    [Seed insertDiffs:58.119656 topY:67.641792 downX:75.641022 downY:80.756012  diffFotos:ElephantA inContext:context];
    [Seed insertDiffs:78.205124 topY:55.562897 downX:92.307686 downY:65.226013  diffFotos:ElephantA inContext:context];
    
    Maze *fishschool = [Maze createMaze:@"fishschool" forTheme:animal inManagedObjectContext:context];
    fishschool.dificulty = intermediate;
    fishschool.state = normalState;
    fishschool.uniqueID = @"T-0001.M-0005";
    fishschool.available = avalable;
    DifferenceSet *fishschoolA = [DifferenceSet createDifferenceFoto:@"fishschoolA" forMaze:fishschool inManagedObjectContext:context];
    
    [Seed insertDiffs:32.478630 topY:10.353335 downX:49.572647 downY:21.396893  diffFotos:fishschoolA inContext:context];
    [Seed insertDiffs:59.401711 topY:10.008224 downX:75.213676 downY:23.812670  diffFotos:fishschoolA inContext:context];
    [Seed insertDiffs:60.683758 topY:31.060005 downX:77.350426 downY:42.448673  diffFotos:fishschoolA inContext:context];
    [Seed insertDiffs:29.914528 topY:41.758450 downX:47.435898 downY:55.908005  diffFotos:fishschoolA inContext:context];
    [Seed insertDiffs:28.205130 topY:79.030457 downX:48.290596 downY:93.870232  diffFotos:fishschoolA inContext:context];
    
    Maze *Leopard = [Maze createMaze:@"leopard" forTheme:animal inManagedObjectContext:context];
    Leopard.dificulty = intermediate;
    Leopard.state = normalState;
    Leopard.uniqueID = @"T-0001.M-0006";
    Leopard.available = avalable;
    DifferenceSet *leopardA = [DifferenceSet createDifferenceFoto:@"leopardA" forMaze:Leopard inManagedObjectContext:context];
    
    [Seed insertDiffs:32 topY:27 downX:47 downY:40  diffFotos:leopardA inContext:context];
    [Seed insertDiffs:39 topY:8 downX:55 downY:20  diffFotos:leopardA inContext:context];
    [Seed insertDiffs:72 topY:6 downX:87 downY:19  diffFotos:leopardA inContext:context];
    [Seed insertDiffs:27 topY:42 downX:42 downY:54  diffFotos:leopardA inContext:context];
    [Seed insertDiffs:10 topY:74 downX:25 downY:86  diffFotos:leopardA inContext:context];
    
    Maze *Lion = [Maze createMaze:@"lion" forTheme:animal inManagedObjectContext:context];
    Lion.dificulty = expert;
    Lion.state = normalState;
    Lion.uniqueID = @"T-0001.M-0007";
    Lion.available = avalable;
    DifferenceSet *lionA = [DifferenceSet createDifferenceFoto:@"lionA" forMaze:Lion inManagedObjectContext:context];
    
    [Seed insertDiffs:3.418804 topY:62.120010 downX:18.376068 downY:74.198898  diffFotos:lionA inContext:context];
    [Seed insertDiffs:57.692307 topY:86.622910 downX:74.786324 downY:96.286011  diffFotos:lionA inContext:context];
    [Seed insertDiffs:75.213676 topY:55.562897 downX:88.888893 downY:69.367340  diffFotos:lionA inContext:context];
    [Seed insertDiffs:73.504272 topY:32.785561 downX:85.897430 downY:42.793785  diffFotos:lionA inContext:context];
    [Seed insertDiffs:42.307690 topY:73.853783 downX:57.264954 downY:81.791344  diffFotos:lionA inContext:context];
    
    Maze *Monkey = [Maze createMaze:@"monkey" forTheme:animal inManagedObjectContext:context];
    Monkey.dificulty = expert;
    Monkey.state = normalState;
    Monkey.uniqueID = @"T-0001.M-0008";
    Monkey.available = avalable;
    DifferenceSet *monkeyA = [DifferenceSet createDifferenceFoto:@"monkeyA" forMaze:Monkey inManagedObjectContext:context];
    
    [Seed insertDiffs:8.974359 topY:8.627779 downX:26.923075 downY:18.290892  diffFotos:monkeyA inContext:context];
    [Seed insertDiffs:32.051281 topY:29.679558 downX:48.290596 downY:40.032894  diffFotos:monkeyA inContext:context];
    [Seed insertDiffs:84.188034 topY:30.024672 downX:97.863243 downY:42.448673  diffFotos:monkeyA inContext:context];
    [Seed insertDiffs:52.564102 topY:59.704231 downX:70.512817 downY:71.438011  diffFotos:monkeyA inContext:context];
    [Seed insertDiffs:29.059828 topY:78.685341 downX:44.871796 downY:88.693573  diffFotos:monkeyA inContext:context];
    
    Maze *Pidgeons = [Maze createMaze:@"pigeons" forTheme:animal inManagedObjectContext:context];
    Pidgeons.dificulty = expert;
    Pidgeons.state = normalState;
    Pidgeons.uniqueID = @"T-0001.M-0009";
    Pidgeons.available = avalable;
    DifferenceSet *pigeonsA = [DifferenceSet createDifferenceFoto:@"pigeonsA" forMaze:Pidgeons inManagedObjectContext:context];
    
    [Seed insertDiffs:28.205130 topY:7.937556 downX:48.290596 downY:22.777336  diffFotos:pigeonsA inContext:context];
    [Seed insertDiffs:38.034187 topY:31.750225 downX:56.410259 downY:43.829117  diffFotos:pigeonsA inContext:context];
    [Seed insertDiffs:0.854701 topY:70.057571 downX:20.085470 downY:81.101128  diffFotos:pigeonsA inContext:context];
    [Seed insertDiffs:33.333332 topY:62.465118 downX:47.863247 downY:74.198898  diffFotos:pigeonsA inContext:context];
    [Seed insertDiffs:65.384613 topY:79.375565 downX:83.760681 downY:90.074013  diffFotos:pigeonsA inContext:context];
    
    Maze *scorpionfish = [Maze createMaze:@"scorpionfish" forTheme:animal inManagedObjectContext:context];
    scorpionfish.dificulty = beginner;
    scorpionfish.state = normalState;
    scorpionfish.uniqueID = @"T-0001.M-0002";
    scorpionfish.available = avalable;
    DifferenceSet *scorpionfishA = [DifferenceSet createDifferenceFoto:@"scorpionfishA" forMaze:scorpionfish inManagedObjectContext:context];
    
    [Seed insertDiffs:15.811966 topY:41.413342 downX:32.478630 downY:53.492229  diffFotos:scorpionfishA inContext:context];
    [Seed insertDiffs:30.341879 topY:60.049343 downX:45.299141 downY:69.712456  diffFotos:scorpionfishA inContext:context];
    [Seed insertDiffs:61.965813 topY:51.766674 downX:76.923073 downY:64.190674  diffFotos:scorpionfishA inContext:context];
    [Seed insertDiffs:44.871796 topY:30.024672 downX:63.247864 downY:46.244896  diffFotos:scorpionfishA inContext:context];
    [Seed insertDiffs:76.923073 topY:6.557112 downX:92.735039 downY:24.157780  diffFotos:scorpionfishA inContext:context];
    
    Maze *seabirds = [Maze createMaze:@"seabirds" forTheme:animal inManagedObjectContext:context];
    seabirds.dificulty = detective;
    seabirds.state = normalState;
    seabirds.uniqueID = @"T-0001.M-0012";
    seabirds.available = avalable;
    DifferenceSet *seabirdsA = [DifferenceSet createDifferenceFoto:@"seabirdsA" forMaze:seabirds inManagedObjectContext:context];
    
    [Seed insertDiffs:6.410256 topY:43.484009 downX:20.940170 downY:53.492229  diffFotos:seabirdsA inContext:context];
    [Seed insertDiffs:17.521366 topY:67.986900 downX:33.760685 downY:77.650009  diffFotos:seabirdsA inContext:context];
    [Seed insertDiffs:80.341873 topY:52.802010 downX:93.162392 downY:64.190674  diffFotos:seabirdsA inContext:context];
    [Seed insertDiffs:19.230768 topY:54.527561 downX:32.051281 downY:62.120010  diffFotos:seabirdsA inContext:context];
    [Seed insertDiffs:50.854702 topY:67.296677 downX:69.658119 downY:81.101128  diffFotos:seabirdsA inContext:context];
    
    Maze *turtle = [Maze createMaze:@"turtle" forTheme:animal inManagedObjectContext:context];
    turtle.dificulty = detective;
    turtle.state = normalState;
    turtle.uniqueID = @"T-0001.M-0011";
    turtle.available = avalable;
    DifferenceSet *turtleA = [DifferenceSet createDifferenceFoto:@"turtleA" forMaze:turtle inManagedObjectContext:context];
    
    [Seed insertDiffs:51.709400 topY:13.114224 downX:67.948715 downY:23.467560  diffFotos:turtleA inContext:context];
    [Seed insertDiffs:20.940170 topY:41.068230 downX:38.888885 downY:52.111786  diffFotos:turtleA inContext:context];
    [Seed insertDiffs:45.299145 topY:40.032898 downX:62.393166 downY:48.660675  diffFotos:turtleA inContext:context];
    [Seed insertDiffs:33.760685 topY:55.217785 downX:54.273502 downY:67.641792  diffFotos:turtleA inContext:context];
    [Seed insertDiffs:18.376068 topY:71.783119 downX:37.606838 downY:86.277794  diffFotos:turtleA inContext:context];
    
    Maze *Spiderweb = [Maze createMaze:@"spiderweb" forTheme:animal inManagedObjectContext:context];
    Spiderweb.dificulty = intermediate;
    Spiderweb.state = normalState;
    Spiderweb.uniqueID = @"T-0001.M-0004";
    Spiderweb.available = avalable;
    DifferenceSet *spiderwebA = [DifferenceSet createDifferenceFoto:@"spiderwebA" forMaze:Spiderweb inManagedObjectContext:context];
    
    [Seed insertDiffs:27 topY:43 downX:40 downY:55  diffFotos:spiderwebA inContext:context];
    [Seed insertDiffs:3 topY:50 downX:16 downY:61  diffFotos:spiderwebA inContext:context];
    [Seed insertDiffs:38 topY:63 downX:52 downY:73  diffFotos:spiderwebA inContext:context];
    [Seed insertDiffs:81 topY:29 downX:94 downY:39  diffFotos:spiderwebA inContext:context];
    [Seed insertDiffs:18 topY:75 downX:33 downY:87  diffFotos:spiderwebA inContext:context];    
    
    /***********************************************************************************************************************************************************************
     *
     *
     *                                               THEME - FOOD
     *
     *
     **********************************************************************************************************************************************************************/
    Maze *bbq = [Maze createMaze:@"bbq" forTheme:comida inManagedObjectContext:context];
    bbq.dificulty = intermediate;
    bbq.state = normalState;
    bbq.uniqueID = @"T-0003.M-0005";
    bbq.available = avalable;
    DifferenceSet *bbqA = [DifferenceSet createDifferenceFoto:@"bbqA" forMaze:bbq inManagedObjectContext:context];
    
    [Seed insertDiffs:7.692308 topY:80.065788 downX:18.803419 downY:92.144684  diffFotos:bbqA inContext:context];
    [Seed insertDiffs:41.452991 topY:58.668892 downX:55.982906 downY:69.712456  diffFotos:bbqA inContext:context];
    [Seed insertDiffs:69.658119 topY:73.853783 downX:83.333328 downY:84.552231  diffFotos:bbqA inContext:context];
    [Seed insertDiffs:49.572647 topY:14.494668 downX:65.384613 downY:25.193115  diffFotos:bbqA inContext:context];
    [Seed insertDiffs:26.923075 topY:9.663113 downX:42.735039 downY:19.326225  diffFotos:bbqA inContext:context];
    
    Maze *berries = [Maze createMaze:@"berries" forTheme:comida inManagedObjectContext:context];
    berries.dificulty = beginner;
    berries.state = normalState;
    berries.uniqueID = @"T-0003.M-0001";
    berries.available = avalable;
    DifferenceSet *berriesA = [DifferenceSet createDifferenceFoto:@"berriesA" forMaze:berries inManagedObjectContext:context];
        
    [Seed insertDiffs:26.495728 topY:50.731342 downX:44.017094 downY:63.155342  diffFotos:berriesA inContext:context];
    [Seed insertDiffs:39.316238 topY:37.962227 downX:52.991455 downY:49.696011  diffFotos:berriesA inContext:context];
    [Seed insertDiffs:55.555557 topY:82.136459 downX:70.512817 downY:92.489792  diffFotos:berriesA inContext:context];
    [Seed insertDiffs:74.786324 topY:9.663113 downX:92.307686 downY:23.812670  diffFotos:berriesA inContext:context];
    [Seed insertDiffs:80.341881 topY:62.810230 downX:97.008545 downY:75.234238  diffFotos:berriesA inContext:context]; 
    
    Maze *fakeshop = [Maze createMaze:@"fakeshop" forTheme:comida inManagedObjectContext:context];
    fakeshop.dificulty = beginner;
    fakeshop.state = normalState;
    fakeshop.uniqueID = @"T-0003.M-0003";
    fakeshop.available = avalable;
    DifferenceSet *fakeshopA = [DifferenceSet createDifferenceFoto:@"fakeshopA" forMaze:fakeshop inManagedObjectContext:context];
        
    [Seed insertDiffs:26.495728 topY:7.937556 downX:38.888885 downY:16.910448  diffFotos:fakeshopA inContext:context];
    [Seed insertDiffs:64.529915 topY:44.864452 downX:80.341881 downY:56.253117  diffFotos:fakeshopA inContext:context];
    [Seed insertDiffs:27.777779 topY:75.234238 downX:45.726494 downY:85.587570  diffFotos:fakeshopA inContext:context];
    [Seed insertDiffs:35.042732 topY:57.288448 downX:55.982906 downY:66.261345  diffFotos:fakeshopA inContext:context];
    [Seed insertDiffs:72.649567 topY:61.084675 downX:90.170937 downY:72.473343  diffFotos:fakeshopA inContext:context]; 
    
    Maze *fishes = [Maze createMaze:@"fishes" forTheme:comida inManagedObjectContext:context];
    fishes.dificulty = expert;
    fishes.state = normalState;
    fishes.uniqueID = @"T-0003.M-0008";
    fishes.available = avalable;
    DifferenceSet *fishesA = [DifferenceSet createDifferenceFoto:@"fishesA" forMaze:fishes inManagedObjectContext:context];
    
    [Seed insertDiffs:29.059828 topY:17.945780 downX:48.717945 downY:30.714893  diffFotos:fishesA inContext:context];
    [Seed insertDiffs:79.914520 topY:28.644224 downX:93.162392 downY:38.307339  diffFotos:fishesA inContext:context];
    [Seed insertDiffs:70.085464 topY:52.802010 downX:89.316238 downY:65.916237  diffFotos:fishesA inContext:context];
    [Seed insertDiffs:45.726494 topY:79.720673 downX:64.957260 downY:92.144684  diffFotos:fishesA inContext:context];
    [Seed insertDiffs:38.461536 topY:47.970451 downX:53.846149 downY:57.978672  diffFotos:fishesA inContext:context];
    
    Maze *fruitsalad = [Maze createMaze:@"fruitsalad" forTheme:comida inManagedObjectContext:context];
    fruitsalad.dificulty = intermediate;
    fruitsalad.state = normalState;
    fruitsalad.uniqueID = @"T-0003.M-0004";
    fruitsalad.available = avalable;
    DifferenceSet *fruitsaladA = [DifferenceSet createDifferenceFoto:@"fruitsaladA" forMaze:fruitsalad inManagedObjectContext:context];
    
    [Seed insertDiffs:70.940170 topY:6.902223 downX:87.179489 downY:19.671335  diffFotos:fruitsaladA inContext:context];
    [Seed insertDiffs:67.948715 topY:32.785561 downX:82.905983 downY:43.829117  diffFotos:fruitsaladA inContext:context];
    [Seed insertDiffs:4.700855 topY:65.571121 downX:20.940170 downY:79.720673  diffFotos:fruitsaladA inContext:context];
    [Seed insertDiffs:5.555556 topY:17.600670 downX:22.649570 downY:29.334446  diffFotos:fruitsaladA inContext:context];
    [Seed insertDiffs:29.059828 topY:35.891560 downX:45.299141 downY:46.244896  diffFotos:fruitsaladA inContext:context];    
    
    Maze *gummies = [Maze createMaze:@"gummies" forTheme:comida inManagedObjectContext:context];
    gummies.dificulty = intermediate;
    gummies.state = normalState;
    gummies.uniqueID = @"T-0003.M-0006";
    gummies.available = avalable;
    DifferenceSet *gummiesA = [DifferenceSet createDifferenceFoto:@"gummiesA" forMaze:gummies inManagedObjectContext:context];
    
    [Seed insertDiffs:21 topY:31 downX:36 downY:43  diffFotos:gummiesA inContext:context];
    [Seed insertDiffs:45 topY:29 downX:61 downY:41  diffFotos:gummiesA inContext:context];
    [Seed insertDiffs:72 topY:27 downX:87 downY:39  diffFotos:gummiesA inContext:context];
    [Seed insertDiffs:26 topY:48 downX:41 downY:60  diffFotos:gummiesA inContext:context];
    [Seed insertDiffs:69 topY:60 downX:84 downY:73  diffFotos:gummiesA inContext:context];    
    
    Maze *lobsters = [Maze createMaze:@"lobsters" forTheme:comida inManagedObjectContext:context];
    lobsters.dificulty = beginner;
    lobsters.state = normalState;
    lobsters.uniqueID = @"T-0003.M-0002";
    lobsters.available = avalable;
    DifferenceSet *lobstersA = [DifferenceSet createDifferenceFoto:@"lobstersA" forMaze:lobsters inManagedObjectContext:context];
        
    [Seed insertDiffs:2.136752 topY:26.918671 downX:14.102565 downY:36.236671  diffFotos:lobstersA inContext:context];
    [Seed insertDiffs:74.358978 topY:16.565336 downX:85.470078 downY:26.918671  diffFotos:lobstersA inContext:context];
    [Seed insertDiffs:47.008549 topY:71.783119 downX:64.102562 downY:81.446236  diffFotos:lobstersA inContext:context];
    [Seed insertDiffs:69.230774 topY:50.386230 downX:84.615379 downY:61.084675  diffFotos:lobstersA inContext:context];
    [Seed insertDiffs:31.623932 topY:50.041122 downX:47.863247 downY:59.359116  diffFotos:lobstersA inContext:context];
    
    Maze *parsley = [Maze createMaze:@"parsley" forTheme:comida inManagedObjectContext:context];
    parsley.dificulty = expert;
    parsley.state = normalState;
    parsley.uniqueID = @"T-0003.M-0007";
    parsley.available = avalable;
    DifferenceSet *parsleyA = [DifferenceSet createDifferenceFoto:@"parsleyA" forMaze:parsley inManagedObjectContext:context];
        
    [Seed insertDiffs:59.829056 topY:27.263784 downX:76.923073 downY:37.617119  diffFotos:parsleyA inContext:context];
    [Seed insertDiffs:37.179489 topY:30.369781 downX:53.418804 downY:42.448673  diffFotos:parsleyA inContext:context];
    [Seed insertDiffs:16.239315 topY:20.706671 downX:33.333332 downY:33.475784  diffFotos:parsleyA inContext:context];
    [Seed insertDiffs:23.931623 topY:52.111786 downX:40.170940 downY:61.429787  diffFotos:parsleyA inContext:context];
    [Seed insertDiffs:54.700859 topY:82.136459 downX:70.512817 downY:95.250679  diffFotos:parsleyA inContext:context]; 
    
    Maze *pumpkins = [Maze createMaze:@"pumpkins" forTheme:comida inManagedObjectContext:context];
    pumpkins.dificulty = detective;
    pumpkins.state = normalState;
    pumpkins.uniqueID = @"T-0003.M-0012";
    pumpkins.available = avalable;
    DifferenceSet *pumpkinsA = [DifferenceSet createDifferenceFoto:@"pumpkinsA" forMaze:pumpkins inManagedObjectContext:context];

    [Seed insertDiffs:5.982905 topY:42.448673 downX:22.649572 downY:52.111786  diffFotos:pumpkinsA inContext:context];
    [Seed insertDiffs:78.205124 topY:23.812672 downX:93.162392 downY:34.166004  diffFotos:pumpkinsA inContext:context];
    [Seed insertDiffs:32.478630 topY:83.862015 downX:55.128204 downY:96.286018  diffFotos:pumpkinsA inContext:context];
    [Seed insertDiffs:76.068375 topY:73.853790 downX:90.170944 downY:83.171791  diffFotos:pumpkinsA inContext:context];
    [Seed insertDiffs:59.401711 topY:36.236675 downX:76.923073 downY:48.315563  diffFotos:pumpkinsA inContext:context];   
    
    Maze *salmondish = [Maze createMaze:@"salmondish" forTheme:comida inManagedObjectContext:context];
    salmondish.dificulty = expert;
    salmondish.state = normalState;
    salmondish.uniqueID = @"T-0003.M-0009";
    salmondish.available = avalable;
    DifferenceSet *salmondishA = [DifferenceSet createDifferenceFoto:@"salmondishA" forMaze:salmondish inManagedObjectContext:context];
    
    [Seed insertDiffs:52.991455 topY:25.883337 downX:73.076920 downY:39.687782  diffFotos:salmondishA inContext:context];
    [Seed insertDiffs:12.393162 topY:57.978672 downX:33.760685 downY:70.747787  diffFotos:salmondishA inContext:context];
    [Seed insertDiffs:44.871796 topY:52.456898 downX:63.675213 downY:64.880905  diffFotos:salmondishA inContext:context];
    [Seed insertDiffs:75.213676 topY:75.579346 downX:91.880341 downY:87.313118  diffFotos:salmondishA inContext:context];
    [Seed insertDiffs:76.068375 topY:38.652451 downX:92.735039 downY:52.111786  diffFotos:salmondishA inContext:context];
    
    Maze *sushimeal = [Maze createMaze:@"sushimeal" forTheme:comida inManagedObjectContext:context];
    sushimeal.dificulty = detective;
    sushimeal.state = normalState;
    sushimeal.uniqueID = @"T-0003.M-0011";
    sushimeal.available = avalable;
    DifferenceSet *sushimealA = [DifferenceSet createDifferenceFoto:@"sushimealA" forMaze:sushimeal inManagedObjectContext:context];
    
    [Seed insertDiffs:40.598289 topY:12.424001 downX:57.692307 downY:24.502893  diffFotos:sushimealA inContext:context];
    [Seed insertDiffs:85.042732 topY:48.315563 downX:98.717949 downY:58.323788  diffFotos:sushimealA inContext:context];
    [Seed insertDiffs:41.452991 topY:73.508682 downX:55.982906 downY:85.242455  diffFotos:sushimealA inContext:context];
    [Seed insertDiffs:7.264957 topY:55.908005 downX:20.940170 downY:67.296677  diffFotos:sushimealA inContext:context];
    [Seed insertDiffs:81.623932 topY:67.986900 downX:95.726486 downY:77.650009  diffFotos:sushimealA inContext:context];
    
    Maze *vegetables = [Maze createMaze:@"vegetables" forTheme:comida inManagedObjectContext:context];
    vegetables.dificulty = detective;
    vegetables.state = normalState;
    vegetables.uniqueID = @"T-0003.M-0010";
    vegetables.available = avalable;
    DifferenceSet *vegetablesA = [DifferenceSet createDifferenceFoto:@"vegetablesA" forMaze:vegetables inManagedObjectContext:context];
    
    [Seed insertDiffs:76.495728 topY:77.304901 downX:91.880341 downY:90.764236  diffFotos:vegetablesA inContext:context];
    [Seed insertDiffs:63.247864 topY:10.698446 downX:82.051285 downY:24.502893  diffFotos:vegetablesA inContext:context];
    [Seed insertDiffs:26.923079 topY:20.361559 downX:42.735039 downY:31.405115  diffFotos:vegetablesA inContext:context];
    [Seed insertDiffs:22.222221 topY:32.440449 downX:35.470085 downY:41.758450  diffFotos:vegetablesA inContext:context];
    [Seed insertDiffs:3.418803 topY:45.209564 downX:17.094017 downY:54.527561  diffFotos:vegetablesA inContext:context];}




@end
