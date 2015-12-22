//
// NSNumber+OMValidationTests.m
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
#import <XCTest/XCTest.h>

#import "NSNumber+OMValidation.h"
#import "OMValidationTests.h"

@interface NSNumberOMValidationTests : XCTestCase
@end

@implementation NSNumberOMValidationTests

- (void)testIsInRange {
    OMThrowsValidationException([@1 v_isInRange:@2 to:@3]);
    OMThrowsValidationException([@1.5 v_isInRange:@2 to:@3]);
    OMThrowsValidationException([@3.5 v_isInRange:@2 to:@3]);
    OMThrowsValidationException([@(INFINITY) v_isInRange:nil to:@0]);
    OMThrowsValidationException([@(0./0.) v_isInRange:nil to:@0]);
    
    XCTAssertNotNil([@2.5 v_isInRange:@2 to:@3]);
    XCTAssertNotNil([@3.5 v_isInRange:@2 to:@3.5]);
    XCTAssertNotNil([@-1 v_isInRange:@-1 to:nil]);
    XCTAssertNotNil([@-1 v_isInRange:nil to:@0]);
}

- (void)testIsLargerThan {
    OMThrowsValidationException([@3.5 v_isLargerThan:@4]);
    OMThrowsValidationException([@4 v_isLargerThan:@4.5]);
    OMThrowsValidationException([@(-INFINITY) v_isLargerThan:@0]);
    OMThrowsValidationException([@(0./0.) v_isLargerThan:@10]);

    XCTAssertEqualObjects([@0 v_isLargerThan:@-0.1], @0);
    XCTAssertEqualObjects([@10.1 v_isLargerThan:@10], @10.1);
}

- (void)testIsSmallerThan {
    OMThrowsValidationException([@4 v_isSmallerThan:@3.5]);
    OMThrowsValidationException([@4.5 v_isSmallerThan:@4]);
    OMThrowsValidationException([@(-INFINITY) v_isSmallerThan:@0]);
    OMThrowsValidationException([@(0./0.) v_isSmallerThan:@10]);

    XCTAssertEqualObjects([@-0.1 v_isSmallerThan:@1], @-0.1);
    XCTAssertEqualObjects([@10 v_isSmallerThan:@10.1], @10);
}

@end
