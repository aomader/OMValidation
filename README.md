# OMValidation [![Supported Platforms](https://cocoapod-badges.herokuapp.com/p/OMValidation/badge.svg)](http://cocoadocs.org/docsets/OMValidation) [![Version](https://cocoapod-badges.herokuapp.com/v/OMValidation/badge.svg)](http://cocoadocs.org/docsets/OMPromises) [![Build Status](https://travis-ci.org/b52/OMValidation.png?branch=master)](https://travis-ci.org/b52/OMValidation)

A simple framework for data validation that tries to be as concise as possible while providing
maximum security and flexibility. The goal is to use **specifying validation methods** in a
**chaining fashion** to write the validation code as intuative as possible while being easy
to skim and maintain.

For example, consider the common use case to retrieve JSON data from an external REST API.
This involves (1) the retrieval of the JSON data, (2) validation of the de-serialized
structure and (3) mapping into a domain specific [data transfer object] for safe
usage in your business logic. The following snippet demonstrates the usage of this
library, in combination with [OMPromises], to achieve the above described.


```objc
// our DTO describing a post
@interface Post : NSObject

@property(nonatomic) NSUInteger id;
@property(nonatomic) NSUInteger userId;
@property(nonatomic) NSString *title;
@property(nonatomic) NSString *boby;

// validates and maps the data into our DTO
+ (instancetype)fromDictionary:(id)data {
    Post *post = [Post new];
    
    post.id = [[data v_has:@"id"] v_isInteger];
    post.userId = [[data v_has:@"userId"] v_isInteger];
    post.title = [[data v_has:@"title"] v_isText];
    post.body = [[data v_has:@"body"] v_isText];
    
    return post;
}

// performs the HTTP GET request and applies our mapping
+ (OMPromise<NSArray<Post *> *> *)loadAllPosts {
    return [[[OMHTTPRequest get:@"http://jsonplaceholder.typicode.com/posts"
                   parameters:nil
                      options:nil]
            httpParseJson]
            then:^(id data) {
                return OMValidationTask(^{
                    NSMutableArray *posts = [NSMutableArray new];
                    
                    for (id postData in [data v_isIterable]) {
                        [posts addObject:[Post fromDictionary:[postData v_isDictionary]]];
                    }
                    
                    return posts;
                });
            }];
}

@end
```

## Features

- [x] Fully tested and documented
- [x] Concise syntax with awesome auto-completion integration
- [x] Uses static compilation support as much as possible
- [ ] Might introduce a memory leak, see [caveats](#caveats) for more information when this
      applies and how to prevent it

## Installation

The recommended approach for installing OMPromises is to use [CocoaPods] package
manager.

```bash
pod 'OMValidation', '~> 0.1.0'
```

## Documentation

All public classes, methods, properties and types are documented, thus each
copy of OMPromises comes with a full documentation found in the corresponding
[header files](Sources).

There is also a [pre-rendered online documnation], for a more pleasent reading experience.

## Overview

The following list provides a concise overview of all available validation methods. They are
grouped by their receiver's type, listing the signature, the potentially more specific return
type, and a short description. If not return type is listed, `instancetype` is assumed, i.e.,
simply returning the receiver.

**Bonus:** All methods start with `v_` for awesome auto-completion magic.

**Hint:** If you feel that we missed an essential method, don't hesitate to open an issue
or even better directly a pull request providing the required method.

### [NSObject](Sources/NSObject+OMValidation.h)

| Signature | Return type | Description |
| --------- | ----------- | ----------- |
| `v_inherits:` |  | Ensures that the receiver inherits the given class. |
| `v_supports:` |  | Ensures that the receiver supports the given protocol. |
| `v_has:` | `id` | Uses [KVC] to extract a _mandatory non-null_ value, given a key path. |
| `v_mightHave:` | `nullable id` | Uses [KVC] to try to extract a value, given a key path. |
| `v_isNumber` | `NSNumber*` | Ensures that the receiver is a `NSNumber`. |
| `v_isBool` | `BOOL` | Ensures that the receiver is a `NSNumber` wrapping a boolean value. |
| `v_isInteger` | `NSNumber*` | Ensures that the receiver is a `NSNumber` wrapping an integer value. |
| `v_isFloat` | `NSNumber*`  | Ensures that the receiver is a `NSNumber` wrapping a _normal_ floating point number. |
| `v_isString` | `NSString*` | Ensures that the receiver is a `NSString`. |
| `v_isText` | `NSString*` | Ensures that the receiver is a `NSString` containing none-whitespace characters. |
| `v_isIterable` | `id<NSFastEnumeration>` | Ensures that the receiver supports the `NSFastEnumeration` protocol. |
| `v_isArray` | `NSArray*` | Ensures that the receiver is a `NSArray`. |
| `v_isDictionary` | `NSDictionary*` | Ensures that the receiver is a `NSDictionary`. |
| `v_isOneOf:` |  | Ensures that the receiver is contained in the supplied `NSArray`. |

### [NSNumber](Sources/NSNumber+OMValidation.h)

| Signature | Return type | Description |
| --------- | ----------- | ----------- |
| `v_isInRange:to:` |  | Ensures that the receiver falls into the range `[lower,upper]`. |
| `v_isLargerThan:` |  | Ensures that the receiver is larger than a supplied `threshold`. |
| `v_isSmallerThan:` |  | Ensures that the receiver is smaller than a supplied `threshold` |

### [NSString](Sources/NSString+OMValidation.h)

| Signature | Return type | Description |
| --------- | ----------- | ----------- |
| `v_isLongerThan:` |  | Ensures that the receiver has more than `length` characters. |
| `v_isShorterThan:` |  | Ensures that the receiver has less than `length` characters. |
| `v_startsWith:` |  | Ensures that the receiver starts with the supplied `prefix`. |
| `v_endsWith:` |  | Ensures that the receiver ends with the supplied `suffix`. |
| `v_contains:` |  | Ensures that the receiver contains the supplied `substring`. |
| `v_matchesRegex:` |  | Ensures that the receiver matches the supplied `regex`. |
| `v_isUrl` | `NSURL*` | Ensures that the receiver is a valid URL. |
| `v_isEmail` |  | Ensures that the receiver is a valid e-mail address. |

### [NSArray](Sources/NSArray+OMValidation.h)

| Signature | Return type | Description |
| --------- | ----------- | ----------- |
| `v_all:` |  | Applies the supplied block `f` to each item. Helper for concise validation chains. |

## Caveats

Due to the use of exceptions to break the normal control flow in case of a validation error,
there might arise memory leaks if you use [ARC]. Since exceptions are considered [programmer errors],
this is perfectly fine in a normal Objective-C environment, but we use this method in a none-fatal
way to allow a concise chaining syntax.

However, there are at least two use cases where this is perfectly fine and the benefits outweight
the drawbacks:

1. You compile your Objective-C ARC code with [`-fobjc-arc-exceptions`]
   to make the use of exceptions memory safe. This might introduce performance penalties and an
   increased binary size. Don't enable this option without profiling its influence.
2. Your developing against data from an external API which might change from time to time,
   but only very rarely. E.g., you are also the author of the external API and just wanna
   be safe against application crashes.

If one of the above two points apply to you, it is perfectly reasonable to use this framework
for data validation.

## License

OMPromises is licensed under the terms of the MIT license.
Please see the [LICENSE](LICENSE) file for full details.

[data transfer object]: https://en.wikipedia.org/wiki/Data_transfer_object
[OMPromises]: https://github.com/b52/OMPromises
[CocoaPods]: http://cocoapods.org/
[pre-rendered online documnation]: http://cocoadocs.org/docsets/OMValidation/
[KVC]: https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/KeyValueCoding/Articles/KeyValueCoding.html#//apple_ref/doc/uid/10000107i
[ARC]: http://clang.llvm.org/docs/AutomaticReferenceCounting.html
[programmer errors]: https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/ErrorHandling/ErrorHandling.html
[`-fobjc-arc-exceptions`]: http://clang.llvm.org/docs/AutomaticReferenceCounting.html#exceptions
