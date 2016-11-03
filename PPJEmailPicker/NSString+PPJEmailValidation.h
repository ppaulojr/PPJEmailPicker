//
//  NSString+PPJEmailValidation.h
//  Pods
//
//  Created by Nacho on 2/8/16.
//
//

#import <Foundation/Foundation.h>

@interface NSString (PPJEmailValidation)
- (BOOL) isValidEmail;
- (NSString *) sanitizeString;
@end
