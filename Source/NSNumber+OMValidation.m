//
// NSNumber+OMValidation.m
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

#import "NSNumber+OMValidation.h"

#import "OMValidationFailure.h"

// ensures that the number contains only normal values
BOOL OMNumberIsNormal(NSNumber *number);

@implementation NSNumber (OMValidation)

- (instancetype)v_isInRange:(nullable NSNumber *)lower to:(nullable NSNumber *)upper {
    NSParameterAssert(lower != nil || upper != nil);
    NSParameterAssert(lower == nil || OMNumberIsNormal(lower));
    NSParameterAssert(upper == nil || OMNumberIsNormal(upper));

    if (!OMNumberIsNormal(self) ||
        (lower != nil && [self compare:lower] == NSOrderedAscending) ||
        (upper != nil && [self compare:upper] == NSOrderedDescending))
    {
        OMValidationFailed(@"%@ doesn't fall in the range [%@, %@]", self, lower, upper);
    }

    return self;
}

- (instancetype)v_isLargerThan:(NSNumber *)threshold {
    NSParameterAssert(threshold != nil && OMNumberIsNormal(threshold));

    if (!OMNumberIsNormal(self) ||
        [self compare:threshold] != NSOrderedDescending)
    {
        OMValidationFailed(@"%@ is not larger than %@", self, threshold);
    }

    return self;
}

- (instancetype)v_isSmallerThan:(NSNumber *)threshold {
    NSParameterAssert(threshold != nil && OMNumberIsNormal(threshold));

    if (!OMNumberIsNormal(self) ||
        [self compare:threshold] != NSOrderedAscending)
    {
        OMValidationFailed(@"%@ is not smaller than %@", self, threshold);
    }

    return self;
}

@end

BOOL OMNumberIsNormal(NSNumber *number) {
    if ((strcmp(number.objCType, @encode(float)) == 0 && !isnormal(number.floatValue)) ||
        (strcmp(number.objCType, @encode(double)) == 0 && !isnormal(number.doubleValue)))
    {
        return FALSE;
    }

    return TRUE;
}
