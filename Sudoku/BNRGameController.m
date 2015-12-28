//
//  BNRGameState.m
//  Sudoku
//
//  Created by Vadzim Vasileuski on 12.11.15.
//  Copyright (c) 2015 Vadzim Vasileuski. All rights reserved.
//

#import "BNRGameController.h"
#import "BNRCell.h"

@interface BNRMove (Private)
@property (nonatomic) NSInteger previousValue;
@end


static const NSInteger AREA_DIMENSION = 3;
static const NSInteger DIMENSION = 9;

@interface BNRGameController ()

@property (nonatomic) NSMutableArray *movesChain;
@property (nonatomic) NSInteger currentMoveNumber;
@property (nonatomic) NSMutableArray *cells;

@end

@implementation BNRGameController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentMoveNumber = -1;
        _movesChain = [NSMutableArray new];
        _cells = [[NSMutableArray alloc] init];
        [self generateStartPosition];
    }
    return self;
}

- (NSArray *)cellArray
{
    return self.cells;
}


#pragma mark  - methods for sudoku generation

- (void)generateStartPosition
{
    //http://habrahabr.ru/post/192102/
    [self.cells removeAllObjects];
    //form the basic grid
    for (int i = 0; i < DIMENSION; i++) {
        for (int j = 0; j < DIMENSION; j++) {
            BNRCell *newCell = [[BNRCell alloc] init];
            newCell.value = (i*AREA_DIMENSION + i/AREA_DIMENSION +j) % DIMENSION + 1;
            newCell.disable = YES;
            [self.cells addObject:newCell];
        }
    }
    
    //mix grid
    for (int i = 0; i < 10; i++) {        
        int area = arc4random() % AREA_DIMENSION;
        int offset1 = arc4random() % AREA_DIMENSION;
        int offset2 = 0;
        do {
            offset2 = arc4random() % AREA_DIMENSION;
        } while (offset1 == offset2);

        int method = arc4random() % 5;
        switch (method) {
            case 0:
                [self transponsing];
                break;
            case 1:                
                [self swapRow:(area*AREA_DIMENSION + offset1)
                      withRow:(area*AREA_DIMENSION + offset2)];
                break;
            case 2:
                [self swapColumn:(area*AREA_DIMENSION + offset1)
                      withColumn:(area*AREA_DIMENSION + offset2)];
                break;
            case 3:
                [self swapColumnArea:offset1
                            withArea:offset2];
                break;
            case 4:
                [self swapRowArea:offset1
                         withArea:offset2];
                break;
            default:
                break;
        }
    }
    
    //delete cells
    for ( int i = 0; i < 50; i++) {
        int cellNumber = arc4random() % 81;
        BNRCell *cell = self.cells[cellNumber];
        cell.value = 0;
        cell.disable = NO;
    }
    
}

- (void)transponsing
{
    for (int i = 0; i < DIMENSION; i++) {
        for (int j = i; j < DIMENSION; j++) {
            BNRCell *temp = self.cells[linearIndex(i, j)];
            self.cells[linearIndex(i, j)] = self.cells[linearIndex(j, i)];
            self.cells[linearIndex(j, i)] = temp;
        }
    }
}

- (void)swapRow:(NSInteger)rowNumber withRow:(NSInteger)otherRowNumber
{
    for (int i = 0; i < DIMENSION; i++) {
        BNRCell *temp = self.cells[linearIndex(rowNumber, i)];
        self.cells[linearIndex(rowNumber, i)] = self.cells[linearIndex(otherRowNumber, i)];
        self.cells[linearIndex(otherRowNumber, i)] = temp;
    }
}
- (void)swapColumn:(NSInteger)columnNumber withColumn:(NSInteger)otherColumnNumber
{
    for (int i = 0; i < DIMENSION; i++) {
        BNRCell *temp = self.cells[linearIndex(i, columnNumber)];
        self.cells[linearIndex(i, columnNumber)] = self.cells[linearIndex(i, otherColumnNumber)];
        self.cells[linearIndex(i, otherColumnNumber)] = temp;
    }
}

- (void)swapRowArea:(NSInteger)areaNumber withArea:(NSInteger)otherAreaNumber
{
    for (int rowInArea = 0; rowInArea < AREA_DIMENSION; rowInArea++) {
        [self swapRow:(areaNumber*AREA_DIMENSION + rowInArea)
              withRow:(otherAreaNumber*AREA_DIMENSION + rowInArea)];
    }
}

- (void)swapColumnArea:(NSInteger)areaNumber withArea:(NSInteger)otherAreaNumber
{
    for (int colInArea = 0; colInArea < AREA_DIMENSION; colInArea++) {
        [self swapColumn:(areaNumber*AREA_DIMENSION + colInArea)
              withColumn:(otherAreaNumber*AREA_DIMENSION + colInArea)];
    }
}

static int linearIndex(int row, int column)
{
    return row * DIMENSION + column;
}

#pragma mark - Move/Unmove methods

- (NSArray *)makeMove:(BNRMove *)move
{
    if (move) {
        BNRCell *cell = self.cells[move.cellNumber];
        if (!cell.disable) {
            if (cell.value != move.value) {
                [self verifyAndMarkWrongCellsAfterMove:move];
                move.previousValue = cell.value;
                cell.value = move.value;
                
                if (self.currentMoveNumber < ([self.movesChain count] - 1)) {
                    NSRange range = NSMakeRange(self.currentMoveNumber + 1,
                                                [self.movesChain count] - 1 - self.currentMoveNumber);
                    [self.movesChain removeObjectsInRange:range];
                }
                [self.movesChain addObject:move];
                self.currentMoveNumber++;                
            }
        }
    }
    
    return self.cellArray;
}

- (NSArray *)unmakeMove
{
    if (self.currentMoveNumber >= 0) { 
        BNRMove *move = self.movesChain[self.currentMoveNumber];
        BNRMove *reverseMove = [[BNRMove alloc] initWIthCellNumber:move.cellNumber
                                                           value:move.previousValue];
        BNRCell *cell = self.cells[move.cellNumber];
        [self verifyAndMarkWrongCellsAfterMove:reverseMove];
        cell.value = reverseMove.value;
        self.currentMoveNumber--;        
    }
    return self.cellArray;
}

- (NSArray *)remakeMove
{
    if (self.currentMoveNumber < [self.movesChain count] - 1) {
        self.currentMoveNumber++;
        BNRMove *move = self.movesChain[self.currentMoveNumber];
        [self verifyAndMarkWrongCellsAfterMove:move];
        BNRCell *cell = self.cells[move.cellNumber];
        cell.value = move.value;
    }
    return self.cellArray;
}

#pragma mark - verify

- (void)verifyAndMarkWrongCellsAfterMove:(BNRMove *)move
{
    int cellRow = move.cellNumber / DIMENSION;
    int cellCol = move.cellNumber % DIMENSION;
    for (int i = cellRow * DIMENSION; i < (cellRow + 1) * DIMENSION; i++) {
        [self markIfWrongCellWithIndex:i afterMove:move];
    }
    for (int i = cellCol; i < (DIMENSION*DIMENSION - 1); i += DIMENSION) {
        [self markIfWrongCellWithIndex:i afterMove:move];
    }
    int blockRow = (cellRow / AREA_DIMENSION) * AREA_DIMENSION;
    int blockCol = (cellCol / AREA_DIMENSION) * AREA_DIMENSION;
    int index0 = (blockRow * DIMENSION + blockCol);
    for (int i = 0; i < AREA_DIMENSION; i++) {
        for (int j = 0; j < AREA_DIMENSION; j++) {
            int index = index0 + i * DIMENSION + j;
            [self markIfWrongCellWithIndex:index afterMove:move];
        }
    }
}

- (void)markIfWrongCellWithIndex:(NSInteger)cellIndex afterMove:(BNRMove *) move
{
    BNRCell *cell = self.cells[cellIndex];
    BNRCell *cellToChange = self.cells[move.cellNumber];
    if (cellIndex != move.cellNumber) {
        if (cellToChange.value == 0){
            if (cell.value == move.value){
                cell.wrongValue = YES;
                cellToChange.wrongValue = YES;
            }
            return;
        }
        if (move.value == 0){
            if (cellToChange.value == cell.value) {
                cell.wrongValue = NO;
                cellToChange.wrongValue = NO;
            }
            return;
        }
        if (cell.value != 0) {
            if (cellToChange.value == cell.value) {
                cell.wrongValue = NO;
                cellToChange.wrongValue = NO;
            }
            if (move.value == cell.value) {
                cell.wrongValue = YES;
                cellToChange.wrongValue = YES;
            }
        }        
    }       
}



@end
