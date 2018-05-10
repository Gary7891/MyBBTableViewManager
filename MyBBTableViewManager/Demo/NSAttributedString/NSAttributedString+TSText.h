//
//  NSAttributedString+TSText.h
//  TTLoveCar
//
//  Created by Gary on 17/11/2017.
//  Copyright © 2017 王洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (TSText)


/**
 The font of the text. (read-only)
 
 @discussion Default is Helvetica (Neue) 12.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:6.0  YYKit:6.0
 */
@property (nullable, nonatomic, strong, readonly) UIFont *font;

@end

@interface NSMutableAttributedString (TSText)

/**
 The font of the text. (read-only)
 
 @discussion Default is Helvetica (Neue) 12.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:6.0  YYKit:6.0
 */
@property (nullable, nonatomic, strong, readonly) UIFont *font;


/**
 Adds to the end of the receiver the characters of a given string.
 The new string inherit the attributes of the receiver's tail.
 
 @param string  The string to append to the receiver, must not be nil.
 */
- (void)appendString:(NSString * __nonnull)string;


@end
