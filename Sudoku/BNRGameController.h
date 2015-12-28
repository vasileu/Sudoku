//
//  BNRGameState.h
//  Sudoku
//
//  Created by Vadzim Vasileuski on 12.11.15.
//  Copyright (c) 2015 Vadzim Vasileuski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRMove.h"


@interface BNRGameController : NSObject

@property (nonatomic, readonly) NSArray  *cellArray;


- (NSArray *)makeMove:(BNRMove *)move;
- (NSArray *)unmakeMove;
- (NSArray *)remakeMove;

- (void)generateStartPosition;


@end
