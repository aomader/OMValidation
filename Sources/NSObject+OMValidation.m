//
// NSObject+OMValidation.m
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

#import "NSObject+OMValidation.h"

#import "OMValidationFailure.h"

@implementation NSObject (OMValidation)

- (id)v_inheritsClass:(Class)cls {
    NSParameterAssert(cls != nil);
    
    if (![self isKindOfClass:cls]) {
        OMValidationFailed(@"'%@' is of type %@ instead of %@", self, self.class, cls);
    }
    
    return self;
}

- (id)v_supportsProtocol:(Protocol *)protocol {
    NSParameterAssert(protocol != nil);
    
    if (![self conformsToProtocol:protocol]) {
        OMValidationFailed(@"'%@' is of type %@ and doesn't conform to protocol %@",
                           self, self.class, protocol);
    }
    
    return self;
}

- (id)v_has:(NSString *)keyPath {
    NSParameterAssert(keyPath.length > 0);

    id value = nil;
    
    @try {
        value = [self valueForKeyPath:keyPath];
    } @catch (NSException *exception) {
        if (![exception.name isEqualToString:NSUndefinedKeyException]) {
            @throw;
        }
    }
    
    if (value == nil) {
        OMValidationFailed(@"found no value for required property '%@'", keyPath);
    }
    
    return value;
}

- (id)v_mightHave:(NSString *)keyPath {
    NSParameterAssert(keyPath.length > 0);

    @try {
        return [self valueForKeyPath:keyPath];
    } @catch (NSException *exception) {
        if ([exception.name isEqualToString:NSUndefinedKeyException]) {
            return nil;
        }
        @throw;
    }
}

- (BOOL)v_isBool {
    if (![self isKindOfClass:NSNumber.class] || (
        strcmp(((NSNumber *)self).objCType, @encode(BOOL)) != 0 &&
        strcmp(((NSNumber *)self).objCType, (@YES).objCType) != 0))
    {
        OMValidationFailed(@"%@ is not a bool", self);
    }
    
    return [((NSNumber *) self) boolValue];
}

- (NSNumber *)v_isInteger {
    if (![self isKindOfClass:NSNumber.class] || (
        strcmp(((NSNumber *)self).objCType, @encode(short)) != 0 &&
        strcmp(((NSNumber *)self).objCType, @encode(int)) != 0 &&
        strcmp(((NSNumber *)self).objCType, @encode(long)) != 0 &&
        strcmp(((NSNumber *)self).objCType, @encode(long long)) != 0 &&
        strcmp(((NSNumber *)self).objCType, @encode(unsigned short)) != 0 &&
        strcmp(((NSNumber *)self).objCType, @encode(unsigned int)) != 0 &&
        strcmp(((NSNumber *)self).objCType, @encode(unsigned long)) != 0 &&
        strcmp(((NSNumber *)self).objCType, @encode(unsigned long long)) != 0))
    {
        OMValidationFailed(@"%@ is not an integer", self);
    }

    return (NSNumber *) self;
}

- (NSNumber *)v_isFloat {
    if (![self isKindOfClass:NSNumber.class] || (
        strcmp(((NSNumber *)self).objCType, @encode(float)) != 0 &&
        strcmp(((NSNumber *)self).objCType, @encode(double)) != 0) ||
        !isnormal(((NSNumber *)self).doubleValue))
    {
        OMValidationFailed(@"%@ is not a floating point number", self);
    }

    return (NSNumber *) self;
}

- (NSString *)v_isString {
    return [self v_inheritsClass:NSString.class];
}

- (NSString *)v_isText {
    [self v_inheritsClass:NSString.class];
    
    if ([(NSString *)self length] == 0) {
        OMValidationFailed(@"string is empty");
    }
    
    NSCharacterSet *noneWhitespaceCharacters = [[NSCharacterSet whitespaceAndNewlineCharacterSet]
                                                invertedSet];
    NSRange characters = [(NSString *)self rangeOfCharacterFromSet:noneWhitespaceCharacters];
    
    if (characters.location == NSNotFound) {
        OMValidationFailed(@"string contains only whitespace characters");
    }
    
    return (NSString *) self;
}

- (id<NSFastEnumeration>)v_isIterable {
    return [self v_supportsProtocol:@protocol(NSFastEnumeration)];
}

- (NSArray *)v_isArray {
    return [self v_inheritsClass:NSArray.class];
}

- (NSDictionary *)v_isDictionary {
    return [self v_inheritsClass:NSDictionary.class];
}

- (instancetype)v_isOneOf:(NSArray *)others {
    NSParameterAssert(others.count > 0);

    if (![others containsObject:self]) {
        OMValidationFailed(@"%@ is not one of %@", self, others);
    }

    return self;
}

- (nullable id)v_map:(id(^)(id))f {
    NSParameterAssert(f != nil);

    return f(self);
}

@end
