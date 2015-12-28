//
//  BNRBoard.h
//  Sudoku
//
//  Created by Vadzim Vasileuski on 12.11.15.
//  Copyright (c) 2015 Vadzim Vasileuski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRBoardView : UIView

@property (nonatomic) NSArray *cellArray;

@property (nonatomic, readonly) NSInteger selectedCell;

@end
