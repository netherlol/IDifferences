//
//  Maze.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 10/17/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DifferenceSet, Difficulty, Pack, Theme;

@interface Maze : NSManagedObject

@property (nonatomic, retain) NSString * available;
@property (nonatomic, retain) NSNumber * besttimeminute;
@property (nonatomic, retain) NSNumber * besttimesecund;
@property (nonatomic, retain) NSNumber * differencesMissed;
@property (nonatomic, retain) NSNumber * expectedtimeminute;
@property (nonatomic, retain) NSNumber * expectedtimesecund;
@property (nonatomic, retain) NSString * extendedAtLeastOneTime;
@property (nonatomic, retain) NSNumber * firstScore;
@property (nonatomic, retain) NSNumber * firstTime;
@property (nonatomic, retain) NSNumber * highestscore;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * missedAtLeastOneTime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * newColection;
@property (nonatomic, retain) NSNumber * personalscore;
@property (nonatomic, retain) NSNumber * personalTime;
@property (nonatomic, retain) NSString * showLabel;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * timeRemaining;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSString * scoreSubmeted;
@property (nonatomic, retain) NSSet *differenceSet;
@property (nonatomic, retain) Difficulty *dificulty;
@property (nonatomic, retain) Pack *pack;
@property (nonatomic, retain) Theme *theme;
@end

@interface Maze (CoreDataGeneratedAccessors)

- (void)addDifferenceSetObject:(DifferenceSet *)value;
- (void)removeDifferenceSetObject:(DifferenceSet *)value;
- (void)addDifferenceSet:(NSSet *)values;
- (void)removeDifferenceSet:(NSSet *)values;

@end
