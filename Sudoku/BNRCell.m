//
//  BNRCell.m
//  Sudoku
//
//  Created by Vadzim Vasileuski on 17.11.15.
//  Copyright (c) 2015 Vadzim Vasileuski. All rights reserved.
//

#import "BNRCell.h"

@interface BNRCell ()

@end

@implementation BNRCell


- (BOOL)wrongValue
{
    return (self.counter > 0);
}

- (void)setWrongValue:(BOOL)wrongValue
{
    if (wrongValue) {
        self.counter++;
    } else {
        self.counter--;
    }
}


@end
