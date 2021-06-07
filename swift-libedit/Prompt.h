//
//  Prompt.h
//  swift-libedit
//
//  Created by Neil Pankey on 6/10/14.
//  Copyright (c) 2014 Neil Pankey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Prompt : NSObject

- (instancetype) initWithPrompt:(NSString *)promptText history:(int)count NS_DESIGNATED_INITIALIZER;
- (NSString*) gets;

@property (nonatomic, copy) NSString *prompt;

@end
