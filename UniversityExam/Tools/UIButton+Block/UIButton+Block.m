//
//  UIButton+Block.m
//  BoothTag
//
//  Created by Josh Holtz on 4/22/12.
//  Copyright (c) 2012 Josh Holtz. All rights reserved.
//

#import "UIButton+Block.h"

//#import "/usr/include/objc/runtime.h"
#import <objc/runtime.h>

@implementation UIButton (Block)

static char overviewKey;

@dynamic actions;

- (void) BlockAction:(NSString*)action withBlock:(void(^)(void))block {
    
    if ([self actions] == nil) {
        [self BlockActions:[[NSMutableDictionary alloc] init]];
    }
    
    [[self actions] setObject:block forKey:action];
    
    if ([kUIButtonBlockTouchUpInside isEqualToString:action]) {
        [self addTarget:self action:@selector(doTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)BlockActions:(NSMutableDictionary*)actions {
    objc_setAssociatedObject (self, &overviewKey,actions,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary*)actions {
    return objc_getAssociatedObject(self, &overviewKey);
}

- (void)doTouchUpInside:(id)sender {
    void(^block)(void);
    block = [[self actions] objectForKey:kUIButtonBlockTouchUpInside];
    block();
}

@end
