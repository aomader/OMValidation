//
// NSObject+OMValidationTests.m
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

#import "NSObject+OMValidation.h"
#import "OMValidationTests.h"

@interface TestObject : NSObject
@property NSString *aValue;
@end

@implementation TestObject
@end

@interface NSObjectOMValidationTests : XCTestCase
@end

@implementation NSObjectOMValidationTests

- (void)testInheritsClass {
    NSMutableArray *mutableArray = @[@1337].mutableCopy;
    
    OMThrowsValidationException([mutableArray v_inheritsClass:NSNumber.class]);
    XCTAssertEqual([mutableArray v_inheritsClass:NSArray.class], mutableArray);
}

- (void)testSupportsProtocol {
    NSArray *array = @[@1337];
    //TODO: What is a platform agnostici deault protocol?
    //XCTAssertThrowsSpecificNamed([array v_supportsProtocol:@protocol(NSNumber)], NSException, OMValidationException);
    XCTAssertEqual([array v_supportsProtocol:@protocol(NSFastEnumeration)], array);
}

- (void)testHas {
    NSDictionary *dictionary = @{@"foo": @"bar"};
    
    OMThrowsValidationException([dictionary v_has:@"nope"]);
    XCTAssertEqualObjects([dictionary v_has:@"foo"], @"bar");
    
    TestObject *testObject = [[TestObject alloc] init];
    OMThrowsValidationException([testObject v_has:@"aValue"]);
    OMThrowsValidationException([testObject v_has:@"notAValue"]);
    
    testObject.aValue = @"123";
    XCTAssertEqualObjects([testObject v_has:@"aValue"], testObject.aValue);
}

- (void)testMightHave {
    NSDictionary *dictionary = @{@"foo": @"bar"};
    
    XCTAssertNil([dictionary v_mightHave:@"nope"]);
    XCTAssertEqualObjects([dictionary v_mightHave:@"foo"], @"bar");
    
    TestObject *testObject = [[TestObject alloc] init];
    XCTAssertNil([testObject v_mightHave:@"aValue"]);
    XCTAssertNil([testObject v_mightHave:@"notAValue"]);
    
    testObject.aValue = @"123";
    XCTAssertEqualObjects([testObject v_mightHave:@"aValue"], testObject.aValue);
}

- (void)testIsBool {
    OMThrowsValidationException([@1 v_isBool]);
    OMThrowsValidationException([@"YES" v_isBool]);
    
    XCTAssertEqual([@YES v_isBool], YES);
    XCTAssertEqual([@NO v_isBool], NO);
}

- (void)testIsInteger {
    // tODO
}

- (void)testIsFloat {
    OMThrowsValidationException([@1 v_isFloat]);
    OMThrowsValidationException([@"123" v_isFloat]);
    OMThrowsValidationException([@(INFINITY) v_isFloat]);
    OMThrowsValidationException([@(0. / 0.) v_isFloat]);
    
    XCTAssertEqualWithAccuracy([@0.1337f v_isFloat].floatValue, 0.1337, 1.0e-8);
    XCTAssertEqualWithAccuracy([[NSNumber numberWithDouble:.1337] v_isFloat].doubleValue, 0.1337, 1.0e-8);
}

- (void)testIsText {
    OMThrowsValidationException([@1 v_isText]);
    OMThrowsValidationException([@"" v_isText]);
    OMThrowsValidationException([@" \t\n\r" v_isText]);
    
    XCTAssertEqualObjects([@" foo " v_isText], @" foo ");
}

- (void)testIsIterable {
    OMThrowsValidationException([@"123" v_isIterable]);
    
    NSArray *array = @[@1, @2, @3];
    XCTAssertEqual(array.v_isIterable, array);
    
    NSDictionary *dictionary = @{@"a": @"b"};
    XCTAssertEqual(dictionary.v_isIterable, dictionary);
}

@end
