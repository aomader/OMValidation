//
// OMValidationFailure.h
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

/// @name Errors

/// Global error domain of validation errors.
FOUNDATION_EXPORT NSString *const OMValidationErrorDomain;

/// The different possible errors.
typedef NS_ENUM(NSUInteger, OMValidationErrorCode) {
    /// The validation failed.
    OMValidationError
};

/// Key of the `userInfo` entry containing the reason for the validation error.
FOUNDATION_EXPORT NSString *const OMValidationErrorReasonKey;

/// Creates an @p NSError given an @p OMValidationException.
FOUNDATION_EXPORT NSError *OMValidationErrorForException(NSException *exception);


/// @name Exceptions

/// Name of the exception raised by all validation functions in case of failure.
FOUNDATION_EXPORT NSString *const OMValidationException;

/// Throws an @p OMValidationException with an appropriate reason.
///
/// The supplied `REASON` is considered to be a format string followed by
/// potentially multiple format arguments.
#define OMValidationFailed(REASON, ...) \
    do { \
        NSParameterAssert((REASON) != nil); \
        NSString *reason = [NSString stringWithFormat:(REASON), ##__VA_ARGS__]; \
        @throw [NSException exceptionWithName:OMValidationException \
                                       reason:reason \
                                     userInfo:nil]; \
    } while (0)
