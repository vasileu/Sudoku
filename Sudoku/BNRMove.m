//
//  BNRMove.m
//  Sudoku
//
//  Created by Vadzim Vasileuski on 12.11.15.
//  Copyright (c) 2015 Vadzim Vasileuski. All rights reserved.
//

#import "BNRMove.h"

@interface BNRMove()
@property (nonatomic) NSInteger previousValue;
@end

@implementation BNRMove

- (instancetype)initWIthCellNumber:(NSInteger)cellNumber value:(NSInteger)value
{
    if (cellNumber < 0 || 80 < cellNumber) {
        return nil;
    }
    if (value < 0 || 9 < value) {
        return nil;
    }
    
    
    self = [super init];
    if (self) {
        _cellNumber = cellNumber;
        _value = value;
    }
    return self;
}

- (instancetype)init
{
    NSAssert(NO, @"Don't use it");
    return nil;
}

@end
