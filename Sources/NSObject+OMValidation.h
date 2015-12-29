//
// NSObject+OMValidation.h
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

@interface NSObject (OMValidation)

/// @name Generic type tests

/// Ensures that the receiver is of the supplied type `cls`.
- (id)v_inheritsClass:(Class)cls;

/// Ensures that the receiver conforms to the supplied `protocol`.
- (id)v_supportsProtocol:(Protocol *)protocol;


/// @name Value extraction

/// Uses `KVC` to retrieve the _mandatory_ value for `keyPath`.
///
/// If the the receiver doesn't provide a _nonnull_ value for the supplied `keyPath`,
/// an validation exception is thrown.
- (id)v_has:(NSString *)keyPath;

/// Uses `KVC` to retrieve the _optional_ value for `keyPath`.
///
/// If the the receiver doesn't provide a value for the supplied `keyPath`,
/// @p nil is returned instead of throwing an error.
- (nullable id)v_mightHave:(NSString *)keyPath;


/// @name Primitive types

/// Ensures that the receiver is of type @p NSNumber and contains a
/// `BOOL` value.
- (BOOL)v_isBool;

/// Ensures that the receiver is of type @p NSNumber and contains an
/// integer value, e.g., short, integer, long, etc.
- (NSNumber *)v_isInteger;

/// Ensures that the receiver is of type @p NSNumber and contains a
/// floating point value, i.e., float or double.
///
/// **Beware**, special values like `NaN` or `INFINITY` result in a
/// validation error as well.
- (NSNumber *)v_isFloat;

/// Ensures that the receiver is of type @p NSString, might be empty though.
///
/// If you want to validate that the string contains visibile characters, you
/// should use @p v_isText instead.
- (NSString *)v_isString;

/// Ensures that the receiver is of type @p NSString and contains visible
/// characters.
- (NSString *)v_isText;


/// @name Collection types

/// Ensures that the receiver is iterable using a `for` loop, i.e., if it
/// adheres to the @p NSFastEnumeration protocol.
- (id<NSFastEnumeration>)v_isIterable;

/// Ensures that the receiver inherits @p NSArray.
- (NSArray *)v_isArray;

/// Ensures that the receiver inherits @p NSDictionary.
- (NSDictionary *)v_isDictionary;

/// Ensures that the receiver is contained in the supplied @p NSArray.
- (instancetype)v_isOneOf:(NSArray *)others;


/// @name Transformation

/// Maps the current value given the transforming block `f`.
- (nullable id)v_map:(id(^)(id))f;

@end

NS_ASSUME_NONNULL_END
