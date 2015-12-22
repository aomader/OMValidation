//
// NSString+OMValidationTests.m
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

#import "NSString+OMValidation.h"
#import "OMValidationTests.h"

@interface NSStringOMValidationTests : XCTestCase
@end

@implementation NSStringOMValidationTests

- (void)testIsLongerThan {
    OMThrowsValidationException([@"123" v_isLongerThan:3]);
    OMThrowsValidationException([@"123" v_isLongerThan:5]);

    XCTAssertEqualObjects([@"123" v_isLongerThan:2], @"123");
    XCTAssertEqualObjects([@"123" v_isLongerThan:0], @"123");
}

- (void)testIsShorterThan {
    OMThrowsValidationException([@"123" v_isShorterThan:3]);
    OMThrowsValidationException([@"123" v_isShorterThan:1]);

    XCTAssertEqualObjects([@"123" v_isShorterThan:4], @"123");
}

- (void)testStartsWith {
    OMThrowsValidationException([@"123" v_startsWith:@"23"]);
    OMThrowsValidationException([@"123" v_startsWith:@"13"]);
    OMThrowsValidationException([@"123" v_startsWith:@"1234"]);

    XCTAssertEqualObjects([@"123" v_startsWith:@"1"], @"123");
    XCTAssertEqualObjects([@"123" v_startsWith:@"123"], @"123");
}

- (void)testEndsWith {
    OMThrowsValidationException([@"123" v_endsWith:@"12"]);
    OMThrowsValidationException([@"123" v_endsWith:@"13"]);
    OMThrowsValidationException([@"123" v_endsWith:@"0123"]);

    XCTAssertEqualObjects([@"123" v_endsWith:@"3"], @"123");
    XCTAssertEqualObjects([@"123" v_endsWith:@"123"], @"123");
}

- (void)testContains {
    OMThrowsValidationException([@"123" v_contains:@"13"]);
    OMThrowsValidationException([@"123" v_contains:@"4"]);
    OMThrowsValidationException([@"123" v_contains:@"0123"]);

    XCTAssertEqualObjects([@"123" v_contains:@"3"], @"123");
    XCTAssertEqualObjects([@"123" v_contains:@"23"], @"123");
    XCTAssertEqualObjects([@"123" v_contains:@"123"], @"123");
}

- (void)testIsUrl {
    OMThrowsValidationException(@":\\asd.com".v_isUrl)

    XCTAssertEqualObjects(@"http://lal".v_isUrl, [NSURL URLWithString:@"http://lal"]);
}

- (void)testIsEmail {
    OMThrowsValidationException(@"a@b.c".v_isEmail);
    OMThrowsValidationException(@"a@.cc".v_isEmail);
    OMThrowsValidationException(@"@b.cc".v_isEmail);
    OMThrowsValidationException(@"b.cc".v_isEmail);

    XCTAssertEqualObjects(@"a@b.cc".v_isEmail, @"a@b.cc");
    XCTAssertEqualObjects(@"a@a@b.cc".v_isEmail, @"a@a@b.cc");
}

@end
