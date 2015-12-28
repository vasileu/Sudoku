//
//  BNRMove.h
//  Sudoku
//
//  Created by Vadzim Vasileuski on 12.11.15.
//  Copyright (c) 2015 Vadzim Vasileuski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRMove : NSObject

@property (nonatomic, readonly) NSInteger cellNumber;
@property (nonatomic, readonly) NSInteger value;

- (instancetype) initWIthCellNumber:(NSInteger)cellNumber value:(NSInteger)value;

@end
