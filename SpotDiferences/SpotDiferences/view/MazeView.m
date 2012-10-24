//
//  MazeView.m
//  SpotDiferences
//
//  Created by Miguel Cartó on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MazeView.h"

@interface MazeView() 
    @property (nonatomic,strong) NSMutableArray *markers;
@end

@implementation MazeView


@synthesize markers = _markers;



-(NSMutableArray *)markers{
    if (_markers == nil) _markers = [[NSMutableArray alloc] init];
    return _markers;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    return self;
}



- (void)setImage:(UIImage*)image {
    
    self.backgroundColor = [[UIColor alloc] initWithPatternImage:image];
}


- (void)addMarker:(CGRect)marker {
    
    [self.markers addObject:[NSValue valueWithCGRect:marker]];
    [self setNeedsDisplay];
}

- (void) reset {
    _markers = nil;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if ([self.markers count] > 0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetLineWidth(context, 3.0);
        [[UIColor redColor] setStroke];
        UIGraphicsPushContext(context);
        CGContextBeginPath(context);
        
                
        
        for(NSValue * marker in self.markers)
        {
            CGRect rectangle = [marker CGRectValue];
            CGContextAddRect(context, rectangle);
        }
        
        CGContextStrokePath(context);
        UIGraphicsPopContext();

    }
    
}



@end
