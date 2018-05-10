//
//  NSAttributedString+TSText.m
//  TTLoveCar
//
//  Created by Gary on 17/11/2017.
//  Copyright © 2017 王洋. All rights reserved.
//

#import "NSAttributedString+TSText.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (TSText)

- (UIFont *)font {
    return [self fontAtIndex:0];
}

- (UIFont *)fontAtIndex:(NSUInteger)index {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.
     
     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.
     
     We use UIFont for both CoreText and UIKit.
     */
    UIFont *font = [self attribute:NSFontAttributeName atIndex:index];
    return font;
}

- (id)attribute:(NSString *)attributeName atIndex:(NSUInteger)index {
    if (!attributeName) return nil;
    if (index > self.length || self.length == 0) return nil;
    if (self.length > 0 && index == self.length) index--;
    return [self attribute:attributeName atIndex:index effectiveRange:NULL];
}

@end

@implementation NSMutableAttributedString (TSText)

- (void)appendString:(NSString *)string {
    NSUInteger length = self.length;
    [self replaceCharactersInRange:NSMakeRange(length, 0) withString:string];
    [self removeDiscontinuousAttributesInRange:NSMakeRange(length, string.length)];
}

- (void)removeDiscontinuousAttributesInRange:(NSRange)range {
    NSArray *keys = [NSMutableAttributedString allDiscontinuousAttributeKeys];
    for (NSString *key in keys) {
        [self removeAttribute:key range:range];
    }
}

+ (NSArray *)allDiscontinuousAttributeKeys {
    static NSMutableArray *keys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keys = @[(id)kCTSuperscriptAttributeName,
                 (id)kCTRunDelegateAttributeName,
                 ].mutableCopy;
        
        [keys addObject:(id)kCTRubyAnnotationAttributeName];
        
        
    });
    return keys;
}

- (UIFont *)font {
    return [self fontAtIndex:0];
}

- (UIFont *)fontAtIndex:(NSUInteger)index {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.
     
     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.
     
     We use UIFont for both CoreText and UIKit.
     */
    UIFont *font = [self attribute:NSFontAttributeName atIndex:index];
    return font;
}

- (id)attribute:(NSString *)attributeName atIndex:(NSUInteger)index {
    if (!attributeName) return nil;
    if (index > self.length || self.length == 0) return nil;
    if (self.length > 0 && index == self.length) index--;
    return [self attribute:attributeName atIndex:index effectiveRange:NULL];
}

@end
