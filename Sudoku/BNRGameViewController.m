//
//  BNRGameViewController.m
//  Sudoku
//
//  Created by Vadzim Vasileuski on 23.11.15.
//  Copyright (c) 2015 Vadzim Vasileuski. All rights reserved.
//

#import "BNRGameViewController.h"
#import "BNRBoardView.h"
#import "BNRMove.h"


@interface BNRGameViewController ()
@property (weak, nonatomic) IBOutlet BNRBoardView *boardView;

- (IBAction)numberButtonClicked:(id)sender;
- (IBAction)unmakeMoveButtonClicked:(id)sender;
- (IBAction)remakeMoveButtonClicked:(id)sender;


@end

@implementation BNRGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.gameController = [[BNRGameController alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.boardView.cellArray = self.gameController.cellArray;

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)numberButtonClicked:(id)sender
{
    int value = [sender tag];
    int selectedCell = self.boardView.selectedCell;
    BNRMove *move = [[BNRMove alloc] initWIthCellNumber:selectedCell value:value];
    self.boardView.cellArray = [self.gameController makeMove:move];
}

- (IBAction)unmakeMoveButtonClicked:(id)sender
{
    self.boardView.cellArray = [self.gameController unmakeMove];
}

- (IBAction)remakeMoveButtonClicked:(id)sender
{
    self.boardView.cellArray = [self.gameController remakeMove];
}

@end
