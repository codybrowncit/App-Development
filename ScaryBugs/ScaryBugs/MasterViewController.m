//
//  MasterViewController.m
//  ScaryBugs
//
//  Created by Cody Brown on 10/8/14.
//  Copyright (c) 2014 Cody Brown. All rights reserved.
//

#import "MasterViewController.h"
#import "ScaryBugDoc.h"
#import "ScaryBugsData.h"
#import "EDStarRating.h"
#import <Quartz/Quartz.h>
#import "NSImage+Extras.h"

@interface MasterViewController ()
@property (weak) IBOutlet EDStarRating *bugRating;
@property (weak) IBOutlet NSImageView *bugImageView;
@property (weak) IBOutlet NSTableView *bugsTableView;
@property (weak) IBOutlet NSTextField *bugTitleView;
@property (weak) IBOutlet NSButton *deleteButton;
@property (weak) IBOutlet NSButton *changePictureButton;






@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    // Get a new ViewCell
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    // Since this is a single-column table view, this would not be necessary.
    // But it's a good practice to do it in order by remember it when a table is multicolumn.
    if( [tableColumn.identifier isEqualToString:@"BugColumn"] )
    {
        ScaryBugDoc *bugDoc = [self.bugs objectAtIndex:row];
        cellView.imageView.image = bugDoc.thumbImage;
        cellView.textField.stringValue = bugDoc.data.title;
        return cellView;
    }
    return cellView;
}
-(void)loadView
{
    [super loadView];
    self.bugRating.starImage = [NSImage imageNamed:@"star.png"];
    self.bugRating.starHighlightedImage = [NSImage imageNamed:@"shockedface2_full.png"];
    self.bugRating.starImage = [NSImage imageNamed:@"shockedface2_empty.png"];
    self.bugRating.maxRating = 5.0;
    self.bugRating.delegate = (id<EDStarRatingProtocol>) self;
    self.bugRating.horizontalMargin = 12;
    self.bugRating.editable=NO;
    self.bugRating.displayMode=EDStarRatingDisplayFull;
    
    
    self.bugRating.rating= 0.0;
}

-(ScaryBugDoc*)selectedBugDoc
{
    NSInteger selectedRow = [self.bugsTableView selectedRow];
    if( selectedRow >=0 && self.bugs.count > selectedRow )
    {
        ScaryBugDoc *selectedBug = [self.bugs objectAtIndex:selectedRow];
        return selectedBug;
    }
    return nil;
    
}

-(void)setDetailInfo:(ScaryBugDoc*)doc
{
    NSString    *title = @"";
    NSImage     *image = nil;
    float rating=0.0;
    if( doc != nil )
    {
        title = doc.data.title;
        image = doc.fullImage;
        rating = doc.data.rating;
    }
    [self.bugTitleView setStringValue:title];
    [self.bugImageView setImage:image];
    [self.bugRating setRating:rating];
    
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    ScaryBugDoc *selectedDoc = [self selectedBugDoc];
    
    // Update info
    [self setDetailInfo:selectedDoc];
    
    // Enable/Disable buttons based on selection
    BOOL buttonsEnabled = (selectedDoc!=nil);
    [self.deleteButton setEnabled:buttonsEnabled];
    [self.changePictureButton setEnabled:buttonsEnabled];
    [self.bugRating setEditable:buttonsEnabled];
    [self.bugTitleView setEnabled:buttonsEnabled];
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.bugs count];
}
- (IBAction)bugTitleDidEndEdit:(id)sender {
    // 1. Get selected bug
    ScaryBugDoc *selectedDoc = [self selectedBugDoc];
    if (selectedDoc )
    {
        // 2. Get the new name from the text field
        selectedDoc.data.title = [self.bugTitleView stringValue];
        // 3. Update the cell
        NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:[self.bugs indexOfObject:selectedDoc]];
        NSIndexSet * columnSet = [NSIndexSet indexSetWithIndex:0];
        [self.bugsTableView reloadDataForRowIndexes:indexSet columnIndexes:columnSet];
    }
}
- (IBAction)addBug:(id)sender {
    // 1. Create a new ScaryBugDoc object with a default name
    ScaryBugDoc *newDoc = [[ScaryBugDoc alloc] initWithTitle:@"New Bug" rating:0.0 thumbImage:nil fullImage:nil];
    
    // 2. Add the new bug object to our model (insert into the array)
    [self.bugs addObject:newDoc];
    NSInteger newRowIndex = self.bugs.count-1;
    
    // 3. Insert new row in the table view
    [self.bugsTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] withAnimation:NSTableViewAnimationEffectGap];
    
    // 4. Select the new bug and scroll to make sure it's visible
    [self.bugsTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] byExtendingSelection:NO];
    [self.bugsTableView scrollRowToVisible:newRowIndex];
}
- (void) pictureTakerDidEnd:(IKPictureTaker *) picker
                 returnCode:(NSInteger) code
                contextInfo:(void*) contextInfo
{
    NSImage *image = [picker outputImage];
    if( image !=nil && (code == NSOKButton) )
    {
        [self.bugImageView setImage:image];
        ScaryBugDoc * selectedBugDoc = [self selectedBugDoc];
        if( selectedBugDoc )
        {
            selectedBugDoc.fullImage = image;
            selectedBugDoc.thumbImage = [image imageByScalingAndCroppingForSize:CGSizeMake( 44, 44 )];
            NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:[self.bugs indexOfObject:selectedBugDoc]];
            
            NSIndexSet * columnSet = [NSIndexSet indexSetWithIndex:0];
            [self.bugsTableView reloadDataForRowIndexes:indexSet columnIndexes:columnSet];
        }
    }
}
- (IBAction)deleteBug:(id)sender {
    // 1. Get selected doc
    ScaryBugDoc *selectedDoc = [self selectedBugDoc];
    if (selectedDoc )
    {
        // 2. Remove the bug from the model
        [self.bugs removeObject:selectedDoc];
        // 3. Remove the selected row from the table view.
        [self.bugsTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:self.bugsTableView.selectedRow] withAnimation:NSTableViewAnimationSlideRight];
        // Clear detail info
        [self setDetailInfo:nil];
    }
}
-(void)starsSelectionChanged:(EDStarRating*)control rating:(float)rating
{
    ScaryBugDoc *selectedDoc = [self selectedBugDoc];
    if( selectedDoc )
    {
        selectedDoc.data.rating = self.bugRating.rating;
    }
}
- (IBAction)changePicture:(id)sender {
    ScaryBugDoc *selectedDoc = [self selectedBugDoc];
    if( selectedDoc )
    {
        [[IKPictureTaker pictureTaker] beginPictureTakerSheetForWindow:self.view.window withDelegate:self didEndSelector:@selector(pictureTakerDidEnd:returnCode:contextInfo:) contextInfo:nil];
    }
}
@end
