//
//  Prompt.m
//  swift-libedit
//
//  Created by Neil Pankey on 6/10/14.
//  Copyright (c) 2014 Neil Pankey. All rights reserved.
//

#import "Prompt.h"

#import <histedit.h>

const char* prompt(EditLine *e) {
	void *data;
	el_get(e, EL_CLIENTDATA, &data);
	return ((__bridge Prompt *)data).prompt.UTF8String;
}

@implementation Prompt

EditLine* _el;
History* _hist;
HistEvent _ev;

- (instancetype) initWithPrompt:(NSString *)promptText history:(int)count {
	if (self = [super init]) {
		self.prompt = promptText;
		
		// Setup the editor
		const char *argv0 = NSProcessInfo.processInfo.arguments[0].UTF8String;
		_el = el_init(argv0, stdin, stdout, stderr);
		el_set(_el, EL_PROMPT, &prompt);
		el_set(_el, EL_EDITOR, "emacs");
		el_set(_el, EL_CLIENTDATA, (__bridge void *)self);
		
		// With support for history
		if (count > 0) {
			_hist = history_init();
			history(_hist, &_ev, H_SETSIZE, count);
			el_set(_el, EL_HIST, history, _hist);
		}
	}
	
	return self;
}

- (instancetype)init {
	return [self initWithPrompt:@"> " history:800];
}

- (void) dealloc {
    if (_hist != NULL) {
        history_end(_hist);
        _hist = NULL;
    }
    
    if (_el != NULL) {
        el_end(_el);
        _el = NULL;
    }
}

- (NSString*) gets {
    
    // line includes the trailing newline
    int count;
    const char* line = el_gets(_el, &count);
    
    if (count > 0) {
		if (_hist != NULL) {
			history(_hist, &_ev, H_ENTER, line);
		}
        
        return [NSString stringWithCString:line encoding:NSUTF8StringEncoding];
    }

    return nil;
}

@end
