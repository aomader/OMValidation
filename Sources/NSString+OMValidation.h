//
// NSNumber+OMValidation.h
// OMValidation
//
// Copyright (C) 2015 Oliver Mader
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (OMValidation)

/// Ensures that the receiver has more than `length` characters.
- (instancetype)v_isLongerThan:(NSUInteger)length;

/// Ensures that the receiver has less than `length` characters.
- (instancetype)v_isShorterThan:(NSUInteger)length;

/// Ensures that the receiver has exact `length` characters.
- (instancetype)v_hasLength:(NSUInteger)length;

/// Ensures that the receiver starts with a certain `prefix`.
- (instancetype)v_startsWith:(NSString *)prefix;

/// Ensures that the receiver ends with a certain `suffix`.
- (instancetype)v_endsWith:(NSString *)suffix;

/// Ensures that the receiver contains a certain `substring`.
- (instancetype)v_contains:(NSString *)substring;

/// Ensures that the receiver is a valid URL.
- (NSURL *)v_isUrl;

/// Ensures that the receiver is a valid E-Mail address.
///
/// **Beware**: it just uses a not-so-strict RegEx to ensure that the string
/// is an email address. If you _HAVE TO_ be certain, you should ensure
/// the domain exists and takes emails for the address.
- (instancetype)v_isEmail;

/// Ensures that the receiver matches the supplied `regex`.
- (instancetype)v_matchesRegex:(NSString *)regex;

@end

NS_ASSUME_NONNULL_END
