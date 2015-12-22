#import "NSString+OMValidation.h"

#import "OMValidationFailure.h"

@implementation NSString (OMValidation)

- (instancetype)v_isLongerThan:(NSUInteger)length {
    if (self.length <= length) {
        OMValidationFailed(@"'%@' is not longer than %lu characters", self,
                           (unsigned long)length);
    }
    
    return self;
}

- (instancetype)v_isShorterThan:(NSUInteger)length {
    NSParameterAssert(length > 0);

    if (self.length >= length) {
        OMValidationFailed(@"'%@' is not shorter than %lu characters", self,
                           (unsigned long)length);
    }

    return self;
}

- (instancetype)v_startsWith:(NSString *)prefix {
    NSParameterAssert(prefix.length > 0);

    if (![self hasPrefix:prefix]) {
        OMValidationFailed(@"'%@' doesn't start with '%@'", self, prefix);
    }

    return self;
}

- (instancetype)v_endsWith:(NSString *)suffix {
    NSParameterAssert(suffix.length > 0);

    if (![self hasSuffix:suffix]) {
        OMValidationFailed(@"'%@' doesn't end with '%@'", self, suffix);
    }

    return self;
}

- (instancetype)v_contains:(NSString *)substring {
    NSParameterAssert(substring.length > 0);

    if (![self containsString:substring]) {
        OMValidationFailed(@"'%@' doesn't contain '%@'", self, substring);
    }

    return self;
}

- (instancetype)v_isEmail {
    @try {
        return [self v_matchesRegex:@"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"];
    }
    @catch (NSException *exception) {
        if ([exception.name isEqualToString:OMValidationException]) {
            OMValidationFailed(@"'%@' is not a valid e-mail address", self);
        } else {
            @throw;
        }
    }
}

- (instancetype)v_matchesRegex:(NSString *)regex {
    NSParameterAssert(regex.length > 0);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (![predicate evaluateWithObject:self]) {
        OMValidationFailed(@"'%@' doesn't match regex '%@'", self, regex);
    }
    
    return self;
}

@end
