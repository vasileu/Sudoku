//
//  BNRBoard.m
//  Sudoku
//
//  Created by Vadzim Vasileuski on 12.11.15.
//  Copyright (c) 2015 Vadzim Vasileuski. All rights reserved.
//

#import "BNRBoardView.h"
#import "BNRCell.h"

@interface BNRBoardView ()

@property (nonatomic) CGPoint lastTapPoint;

@end


@implementation BNRBoardView

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapRecognizer];
        
        self.backgroundColor = [UIColor whiteColor];
        self.lastTapPoint = CGPointZero;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGFloat cellHeight = self.bounds.size.height / 9.001;
    CGFloat cellWidth = self.bounds.size.width / 9.001;
    UIBezierPath *cellRect = [self makeRectangleWithSize:CGSizeMake(cellWidth, cellHeight)];
    
    CGPoint topRightPoint = CGPointMake(self.bounds.size.width, 0);
    UIBezierPath *horizontalLine = [self makeLineFromPoint:CGPointZero toPoint:topRightPoint];
    
    CGPoint leftBottomPoint = CGPointMake(0, self.bounds.size.height);
    UIBezierPath *verticalLine = [self makeLineFromPoint:CGPointZero toPoint:leftBottomPoint];
    
    [[UIColor blackColor] setStroke];
        
    //Horizontal lines
    [self stokePath:horizontalLine repeat:10 withTranslation:CGPointMake(0, cellHeight)];
    
    //Vertical lines
    [self stokePath:verticalLine repeat:10 withTranslation:CGPointMake(cellWidth, 0)];
    
    
        
    //coloring cells
    CGFloat fontSize = MIN(cellHeight, cellWidth) * 0.7;
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
    int cellNumber = 0;
    for (BNRCell* cell in self.cellArray) {
        if (cell.value != 0) {
            int cellCol = cellNumber % 9;
            int cellRow = cellNumber / 9;        
            NSString *value = [NSString stringWithFormat:@"%d",cell.value];
        
            [[UIColor blackColor] setFill];
            if (cell.wrongValue) {
                [[UIColor redColor] setFill];
            }
        
            [value drawInRect:CGRectMake(cellCol*cellWidth, (0.15 + cellRow)*cellHeight, cellWidth, cellHeight/2)
                withFont:font
           lineBreakMode:NSLineBreakByClipping
               alignment:NSTextAlignmentCenter];
        
            if (cell.disable) {
                [[UIColor darkGrayColor] setFill];
                [self fillPath:cellRect
               withTranslation:CGPointMake(cellCol*cellWidth, cellRow*cellHeight)];
            }
        }
        cellNumber++;
    }
    
    //selectedCell
    [[UIColor greenColor] setFill];
    int selectedCellCol = self.lastTapPoint.x / cellWidth;
    int selectedCellRow = self.lastTapPoint.y / cellHeight;
    
    [self fillPath:cellRect
   withTranslation:CGPointMake(selectedCellCol*cellWidth, selectedCellRow*cellHeight)];
    
    
}


- (UIBezierPath *)makeLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    UIBezierPath *line = [[UIBezierPath alloc] init];
    [line moveToPoint:from];
    [line addLineToPoint:to];
    [line closePath];
    return line;
}

-(UIBezierPath *)makeRectangleWithSize:(CGSize)size
{
    UIBezierPath *rect = [[UIBezierPath alloc] init];
    [rect moveToPoint:CGPointMake(0, 0)];
    [rect addLineToPoint:CGPointMake(0, size.height)];
    [rect addLineToPoint:CGPointMake(size.width, size.height)];
    [rect addLineToPoint:CGPointMake(size.width, 0)];
    [rect closePath];
    return rect;
}

- (void)stokePath:(UIBezierPath *)path repeat:(NSInteger)times withTranslation:(CGPoint)point
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    for (int i = 0; i < times; i++) {
        if (i % 3 == 0) {
            path.lineWidth = 3;
        }
        else {
            path.lineWidth = 1;
        }
        [path stroke];
        CGContextTranslateCTM(context, point.x, point.y);
        
    }
    CGContextRestoreGState(context);
}

- (void)fillPath:(UIBezierPath *)path withTranslation:(CGPoint)point
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, point.x, point.y);
    [path fillWithBlendMode:kCGBlendModeNormal alpha:0.3];
    CGContextRestoreGState(context);
    
}

- (void)tap: (UITapGestureRecognizer *)gr
{
    self.lastTapPoint = [gr locationInView:self];
    [self setNeedsDisplay];
}

- (void)setCellArray:(NSArray *)cellArray
{
    _cellArray = cellArray;
    [self setNeedsDisplay];
}

- (NSInteger)selectedCell
{
    CGFloat cellHeight = self.bounds.size.height / 9.001;
    CGFloat cellWidth = self.bounds.size.width / 9.001;
    
    int selectedCellCol = self.lastTapPoint.x / cellWidth;
    int selectedCellRow = self.lastTapPoint.y / cellHeight;
    
    return selectedCellRow * 9 + selectedCellCol;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapRecognizer];
        
        self.backgroundColor = [UIColor whiteColor];
        self.lastTapPoint = CGPointZero;
        
    }
    return self;
}

@end
