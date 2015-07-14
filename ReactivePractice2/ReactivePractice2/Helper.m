//
//  Helper.m
//  FunctionalReactivePixels
//
//  Created by Young Hoo Kim on 7/13/15.
//  Copyright (c) 2015 Young Hoo Kim. All rights reserved.
//

#import "Helper.h"
#import <500px-iOS-api/PXAPI.h>

@implementation PXHelper

- (PXAPIHelper *)makePXAPIHelper {
    return [[PXAPIHelper alloc] initWithHost:nil consumerKey:@"DC2To2BS0ic1ChKDK15d44M42YHf9gbUJgdFoF0m" consumerSecret:@"i8WL4chWoZ4kw9fh3jzHK7XzTer1y5tUNvsTFNnB"];
}

@end
