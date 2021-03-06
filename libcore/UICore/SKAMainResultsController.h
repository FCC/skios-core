//
//  SKAMainResultsController.h
//  SKA
//
//  Copyright (c) 2011-2014 SamKnows Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


#import "SKAGraphViewCell.h"
#import "SKARunTestsButtonCell.h"
#import "SKARunTestsController.h"
#import "SKASettingsController.h"

@interface SKAMainResultsController : UIViewController
    <UITableViewDataSource,
    UITableViewDelegate,
    UIActionSheetDelegate,
    SKARunTestsDelegate,
    SKARunTestsButtonCellProtocol,
    SKAGraphViewDelegate,
    UIAlertViewDelegate,
    MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewBG;
@property (weak, nonatomic) IBOutlet UILabel *lblMain;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblAlert;
@property (weak, nonatomic) IBOutlet UILabel *lblLastDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgviewAlert;
//@property (weak, nonatomic) IBOutlet UIButton *btnRun;
//@property (weak, nonatomic) IBOutlet UIButton *btnRange;
@property (weak, nonatomic) IBOutlet UIButton *showArchivedResultsButton;
@property (weak, nonatomic) IBOutlet UIButton *networkTypeButton;
- (IBAction)networkTypeButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *networkTypeLabel;

#pragma mark SKARunTestsButtonCellProtocol
//- (void)runContinuousTesting:(BOOL)continuousTesting;

- (IBAction)showArchivedResultsButton:(id)sender;
- (IBAction)actionBarButtonItem:(id)sender;
- (IBAction)shareButton:(id)sender;

-(void) setNetworkTypeTo:(NSString*)toNetworkType;

+(SKAMainResultsController*)getSKAMainResultsController;

@end
