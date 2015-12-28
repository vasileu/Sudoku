//
//  BNRCell.h
//  Sudoku
//
//  Created by Vadzim Vasileuski on 17.11.15.
//  Copyright (c) 2015 Vadzim Vasileuski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRCell : NSObject

@property (nonatomic) NSInteger value;
@property (nonatomic) BOOL disable;
@property (nonatomic) BOOL wrongValue;
@property (nonatomic) NSInteger counter;


@end
