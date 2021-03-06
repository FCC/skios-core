//
//  SKAArchivedResultsController.m
//  SKA
//
//  Copyright (c) 2011-2014 SamKnows Limited. All rights reserved.
//

#import "SKAArchivedResultsController.h"

@interface SKAArchivedResultsController ()
{
  NSMutableArray *resultsArray;
  NSMutableDictionary *metricsDictionary;
}

- (void)populateResults;
- (void)addSwipeGesture;
- (void)swipeLeft;
- (void)swipeRight;
- (void)setLabels;
- (void)addBackButton;
- (void)addMainButton;

- (void)goToMain;

@property (nonatomic, strong) NSMutableArray *resultsArray;
@property (nonatomic, strong) NSMutableDictionary *metricsDictionary;

@property (nonatomic, strong) NSNumber *testId;

@property (nonatomic, strong) NSString *device;
@property (nonatomic, strong) NSString *os;
@property (nonatomic, strong) NSString *carrierName;
@property (nonatomic, strong) NSString *carrierCountryCode;
@property (nonatomic, strong) NSString *carrierNetworkCode;
@property (nonatomic, strong) NSString *carrierIsoCode;
@property (nonatomic, strong) NSString *networkType;
@property (nonatomic, strong) NSString *radioType;

@end

@implementation SKAArchivedResultsController

@synthesize viewBG;
@synthesize lblMain;
@synthesize lblDate;
@synthesize lblClosest;
@synthesize lblCount;
@synthesize tableView;
@synthesize testMetaData;
@synthesize resultsArray;
@synthesize metricsDictionary;

@synthesize device;
@synthesize os;
@synthesize carrierName;
@synthesize carrierCountryCode;
@synthesize carrierNetworkCode;
@synthesize carrierIsoCode;
@synthesize networkType;
@synthesize radioType;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  if ([[SKAAppDelegate getAppDelegate] isSocialMediaExportSupported] == NO) {
    // Hide the toolbar, if social media export not supported!
    [self.uiToolbar setHidden:YES];
  }

  self.title = NSLocalizedString(@"Storyboard_ArchivedResults_Title",nil);
  self.lblMain.text = NSLocalizedString(@"Storyboard_ArchivedResults_Archived_Result",nil);
  
//  self.navigationController.delegate = self;
  
  SK_ASSERT(self.tableView != nil);
  
  [self addSwipeGesture];
}

// http://stackoverflow.com/questions/8303811/toolbar-in-navigation-controller
//#pragma mark UINavigationControllerDelegate (begin)
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//  BOOL shouldHide = ([[SKAAppDelegate getAppDelegate] isSocialMediaExportSupported] == NO);
//  [navigationController setToolbarHidden:shouldHide animated:animated];
//}
//#pragma mark UINavigationControllerDelegate (end)

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self populateResults];
  [self setLabels];
  [self addBackButton];
  [self addMainButton];
  
  [self.tableView reloadData];
  
  self.showOlderResultsButton.enabled = [self isThereOlderDataToShow];
  
  self.navigationController.navigationBarHidden = NO;
}

-(BOOL) isThereOlderDataToShow{
  int newIndex = self.testIndex + 1;
  
  if (newIndex <= [self.testMetaData count]-1)
  {
    return YES;
  }

  return NO;
}

- (IBAction)showOlderResultsButton:(id)sender {
  [self swipeLeft];
}

- (void)addSwipeGesture
{
  UISwipeGestureRecognizer *swipeL = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(swipeLeft)];
  
  swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
  [self.tableView addGestureRecognizer:swipeL];
  
  
  UISwipeGestureRecognizer *swipeR = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(swipeRight)];
  
  swipeR.direction = UISwipeGestureRecognizerDirectionRight;
  [self.tableView addGestureRecognizer:swipeR];
  
}

- (void)swipeLeft
{
  int newIndex = self.testIndex + 1;
  
  if (newIndex <= [self.testMetaData count]-1)
  {
    SK_ASSERT([self isThereOlderDataToShow]);
    
    // This is how you perform a seque to self with a storyboard...
    // http://stackoverflow.com/questions/9226983/storyboard-segue-from-view-controller-to-itself
    UIStoryboard *storyboard = [SKAAppDelegate getStoryboard];
    SKAArchivedResultsController *dest = [storyboard instantiateViewControllerWithIdentifier:@"SKAArchivedResultsController"];
    dest.testIndex = newIndex;
    dest.testMetaData = self.testMetaData;
    [self.navigationController pushViewController:dest animated:YES];
    
  } else {
    SK_ASSERT(![self isThereOlderDataToShow]);
  }
}

- (void)swipeRight
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)setLabels
{
  self.navigationItem.title = NSLocalizedString(@"RESULT_Title", nil);

  
  [self.lblMain setText:NSLocalizedString(@"RESULT_Label", nil)];
  
  NSString *txt = [NSString stringWithFormat:@"%d %@ %d",
                   (int)self.testIndex+1,
                   NSLocalizedString(@"Storyboard_ArchivedResults_Of_Separator",nil),
                   (int)[self.testMetaData count]];
  [self.lblCount setText:txt];
}

- (void)addBackButton
{
//  NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                        [UIColor whiteColor],UITextAttributeTextColor,
//                        [[SKAAppDelegate getAppDelegate] getSpecialFontOfSize:12.0],UITextAttributeFont,
//                        nil];
//  
//  [[UIBarButtonItem appearance] setTitleTextAttributes:dict forState:UIControlStateNormal];
}

- (void)addMainButton
{
//  UIImage *img = [UIImage imageNamed:@"WAY_BACK"];
//  
//  UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
//  [backButton setImage:img forState:UIControlStateNormal];
//  [backButton addTarget:self action:@selector(goToMain) forControlEvents:UIControlEventTouchDown];
//  
//  UIBarButtonItem *barBackItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//  
//  self.navigationItem.rightBarButtonItem = barBackItem;
}

- (void)goToMain
{
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)populateResults
{
  NSDictionary *testData = [self.testMetaData objectAtIndex:self.testIndex];
  
  NSMutableArray *tmpArray = [NSMutableArray array];
  
  if (nil != testData)
  {
    self.testId = [testData objectForKey:@"TEST_ID"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[testData objectForKey:@"DATE"] doubleValue]];
    
    self.lblDate.text = [SKGlobalMethods formatDate:date];
    
    self.metricsDictionary = [SKDatabase getMetricsForTestId:self.testId];
    
    if ([self.metricsDictionary objectForKey:@"DEVICE"])
    {
      self.device = [self.metricsDictionary objectForKey:@"DEVICE"];
    }
    
    if ([self.metricsDictionary objectForKey:@"OS"])
    {
      self.os = [self.metricsDictionary objectForKey:@"OS"];
    }
    
    if ([self.metricsDictionary objectForKey:@"CARRIER_NAME"])
    {
      self.carrierName = [self.metricsDictionary objectForKey:@"CARRIER_NAME"];
    }
    
    if ([self.metricsDictionary objectForKey:@"COUNTRY_CODE"])
    {
      self.carrierCountryCode = [self.metricsDictionary objectForKey:@"COUNTRY_CODE"];
    }
    
    if ([self.metricsDictionary objectForKey:@"ISO_CODE"])
    {
      self.carrierIsoCode = [self.metricsDictionary objectForKey:@"ISO_CODE"];
    }
    
    if ([self.metricsDictionary objectForKey:@"NETWORK_CODE"])
    {
      self.carrierNetworkCode = [self.metricsDictionary objectForKey:@"NETWORK_CODE"];
    }
    
    if ([self.metricsDictionary objectForKey:@"NETWORK_TYPE"])
    {
      self.networkType = [self.metricsDictionary objectForKey:@"NETWORK_TYPE"];
    }
    
    if ([self.metricsDictionary objectForKey:@"RADIO_TYPE"])
    {
      self.radioType = [self.metricsDictionary objectForKey:@"RADIO_TYPE"];
    }
    
    NSString *target = [testData objectForKey:@"TARGET"];
    
    self.lblClosest.text = target;
    
    // DOWNLOAD ////////////////////////////////////////////////////////////////////////////////////////////////
    
    NSDictionary *downloadData = [SKDatabase getDownloadResultsForTestId:self.testId];
    
    if ([downloadData count] > 0)
    {
      double bitrateMbps1024Based = [[downloadData objectForKey:@"RESULT"] doubleValue];
      NSString *result = [SKGlobalMethods bitrateMbps1024BasedToString:bitrateMbps1024Based];
      
      NSMutableDictionary *tmpDict1 = [NSMutableDictionary dictionary];
      [tmpDict1 setObject:[NSNumber numberWithInt:DOWNLOAD_DATA] forKey:@"TYPE"];
      [tmpDict1 setObject:result forKey:@"RESULT_1"];
      [tmpDict1 setObject:@"NA" forKey:@"RESULT_2"];
      [tmpDict1 setObject:@"NA" forKey:@"RESULT_3"];
      [tmpDict1 setObject:[downloadData objectForKey:@"DISPLAY_NAME"] forKey:@"DISPLAY_NAME"];
      
       // SKAInformationCell - 49, SKATransferTestCell - 59, SKALatencyTestCell - 100!
      [tmpDict1 setObject:[NSNumber numberWithFloat:59.0f] forKey:@"HEIGHT"];
      
      
      [tmpDict1 setObject:result forKey:@"RESULT_1"];
      [tmpDict1 setObject:[downloadData objectForKey:@"DISPLAY_NAME"] forKey:@"DISPLAY_NAME"];
      
      [tmpArray addObject:tmpDict1];
    }
    
    
    // UPLOAD //////////////////////////////////////////////////////////////////////////////////////////////////
    
    NSDictionary *uploadData = [SKDatabase getUploadResultsForTestId:self.testId];
    
    if ([uploadData count] > 0)
    {
      double bitrateMbps1024Based = [[uploadData objectForKey:@"RESULT"] doubleValue];
      NSString *result = [SKGlobalMethods bitrateMbps1024BasedToString:bitrateMbps1024Based];
      
      NSMutableDictionary *tmpDict2 = [NSMutableDictionary dictionary];
      [tmpDict2 setObject:[NSNumber numberWithInt:UPLOAD_DATA] forKey:@"TYPE"];
      [tmpDict2 setObject:result forKey:@"RESULT_1"];
      [tmpDict2 setObject:@"NA" forKey:@"RESULT_2"];
      [tmpDict2 setObject:@"NA" forKey:@"RESULT_3"];
      [tmpDict2 setObject:[uploadData objectForKey:@"DISPLAY_NAME"] forKey:@"DISPLAY_NAME"];
      
      // SKAInformationCell - 49, SKATransferTestCell - 59, SKALatencyTestCell - 100!
      [tmpDict2 setObject:[NSNumber numberWithFloat:59.0f] forKey:@"HEIGHT"];
      
      [tmpArray addObject:tmpDict2];
    }
    
    
    // LATENCY / LOSS / JITTER
    
    NSDictionary *latencyData = [SKDatabase getLatencyResultsForTestId:self.testId];
    NSDictionary *lossData = [SKDatabase getLossResultsForTestId:self.testId];
    NSDictionary *jitterData = [SKDatabase getJitterResultsForTestId:self.testId];
    
    if ([latencyData count] > 0 && [lossData count] > 0)
    {
      double latency = [[latencyData objectForKey:@"RESULT"] doubleValue];
      double loss = [[lossData objectForKey:@"RESULT"] doubleValue];
      double jitter = [[jitterData objectForKey:@"RESULT"] doubleValue];
      
      NSString *strLatency = [NSString stringWithFormat:@"%@ ms", [SKGlobalMethods format2DecimalPlaces:latency]];
      NSString *strLoss = [NSString stringWithFormat:@"%d %%", (int)loss];
      NSString *strJitter = [NSString stringWithFormat:@"%@ ms", [SKGlobalMethods format2DecimalPlaces:jitter]];
      
      NSMutableDictionary *tmpDict3 = [NSMutableDictionary dictionary];
      [tmpDict3 setObject:[NSNumber numberWithInt:LATENCY_DATA] forKey:@"TYPE"];
      [tmpDict3 setObject:strLatency forKey:@"RESULT_1"];
      [tmpDict3 setObject:strLoss forKey:@"RESULT_2"];
      [tmpDict3 setObject:strJitter forKey:@"RESULT_3"];
      [tmpDict3 setObject:@"NA" forKey:@"DISPLAY_NAME"];
      
      // SKAInformationCell - 49, SKATransferTestCell - 59, SKALatencyTestCell - 100!
      [tmpDict3 setObject:[NSNumber numberWithFloat:100.0f] forKey:@"HEIGHT"];
      
      [tmpArray addObject:tmpDict3];
    }
  }
  
  self.resultsArray = tmpArray;
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  int row = (int)indexPath.row;
  int section = (int)indexPath.section;
  
  if (section == 0)
  {
    NSDictionary *dict = (NSDictionary*)[self.resultsArray objectAtIndex:row];
    
    float height = [[dict objectForKey:@"HEIGHT"] floatValue];
    
    SK_ASSERT(height == 59 || height == 100);
    
    if ([[SKAAppDelegate getAppDelegate] getIsJitterSupported]) {
      if (height == 100) {
        height = 150;
      }
    }
    
    return height;
  }
  else
  {
    // SKA Information cell!
    return 59.0f;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  if ([self.metricsDictionary count] > 0)
  {
    // If Mobile, show both passive and active metrics.
    NSString *theType = (NSString*)[self.metricsDictionary objectForKey:@"NETWORK_TYPE"];
    if ([theType isEqualToString:@"mobile"]) {
      return 2;
    }
    
    // Otherwise, show just active metrics.
    return 1;
  }
  
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (section == 0)
  {
    if (nil != self.resultsArray)
    {
      return [self.resultsArray count];
    }
    
    return 0;
  }
  else
  {
    return 7;
  }
}


- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  switch (section) {
    case 0:
    {
      // e.g. "Active Metrics"
      NSMutableString *activeMetricsText = [NSMutableString stringWithString:NSLocalizedString(@"Label_Active", nil)];
      // e.g. "Active Metrics (Mobile)" or "Active Metrics (Wifi)"
      NSString *theType = (NSString*)[self.metricsDictionary objectForKey:@"NETWORK_TYPE"];
      if ([theType isEqualToString:@"mobile"]) {
        theType = NSLocalizedString(@"NetworkTypeMenu_Mobile",nil);
      } else {
        theType = NSLocalizedString(@"NetworkTypeMenu_WiFi",nil);
      }
      [activeMetricsText appendString:[NSString stringWithFormat:@" (%@)", theType]];
      
      return activeMetricsText;
    }
      
    case 1:
    default:
      return @"Passive Metrics";
  }
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  int row = (int)indexPath.row;
  int section = (int)indexPath.section;
  
  if (section == 0)
  {
    NSDictionary *dict = nil;
    
    @synchronized(self)
    {
      dict = [self.resultsArray objectAtIndex:row];
    }
    
    TestDataType type       = (TestDataType)[[dict objectForKey:@"TYPE"] integerValue];
    NSString *result1       = [dict objectForKey:@"RESULT_1"];
    NSString *result2       = [dict objectForKey:@"RESULT_2"];
    NSString *result3       = [dict objectForKey:@"RESULT_3"];
    NSString *displayName   = [dict objectForKey:@"DISPLAY_NAME"];
    
    if (type == LATENCY_DATA)
    {
      // Latency/loss/jitter!
      static NSString *CellIdentifier = @"SKALatencyTestCell";
      SKALatencyTestCell *cell = (SKALatencyTestCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (cell == nil) {
        cell = [[SKALatencyTestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
      }
      
      cell.lblLatencyResult.hidden = NO;
      cell.lblLossResult.hidden = NO;
      cell.lblJitterResult.hidden = !([[SKAAppDelegate getAppDelegate] getIsJitterSupported]);
      cell.lblJitter.hidden = !([[SKAAppDelegate getAppDelegate] getIsJitterSupported]);
      cell.latencyProgressView.hidden = YES;
      cell.lossProgressView.hidden = YES;
      cell.jitterProgressView.hidden = YES;
      
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
      cell.lblLatencyResult.text = result1;
      cell.lblLossResult.text = result2;
      cell.lblJitterResult.text = result3;
      
      cell.lblLatency.text = NSLocalizedString(@"Test_Latency", nil);
      cell.lblLoss.text = NSLocalizedString(@"Test_Loss", nil);
      cell.lblJitter.text = NSLocalizedString(@"Test_Jitter", nil);
      
      return cell;
    }
    else if (type == DOWNLOAD_DATA)
    {
      static NSString *CellIdentifier = @"SKATransferTestCell";
      SKATransferTestCell *cell = (SKATransferTestCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (cell == nil) {
        cell = [[SKATransferTestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
      }
      
      cell.lblResult.hidden = NO;
      cell.progressView.hidden = YES;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.lblResult.text = result1;
      cell.lblTest.text = displayName;
      
      return cell;
    }
    else if (type == JITTER_DATA)
    {
      SK_ASSERT(false);
      return nil;
    }
    else
    {
      static NSString *CellIdentifier = @"SKATransferTestCell";
      SKATransferTestCell *cell = (SKATransferTestCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (cell == nil) {
        cell = [[SKATransferTestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
      }
      
      cell.lblResult.hidden = NO;
      cell.progressView.hidden = YES;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
      cell.lblResult.text = result1;
      cell.lblTest.text = displayName;
      
      return cell;
    }
  }
  else
  {
    static NSString *CellIdentifier = @"SKAInformationCell";
    SKAInformationCell *cell = (SKAInformationCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[SKAInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (row == 0) {
      cell.lblTitle.text = NSLocalizedString(@"Network_Type", nil);
      cell.lblDetail.text = NSLocalizedString(@"NetworkType_Unknown",nil);
      if ([self.networkType isEqualToString:@"network"]) {
        cell.lblDetail.text = NSLocalizedString(@"NetworkTypeMenu_WiFi",nil);
      } else if ([self.networkType isEqualToString:@"mobile"]) {
        
        NSString *mobileString = NSLocalizedString(@"NetworkTypeMenu_Mobile",nil);
       
        NSString *theRadio =[SKGlobalMethods getNetworkTypeLocalized:self.radioType];
        if ([theRadio isEqualToString:NSLocalizedString(@"CTRadioAccessTechnologyUnknown",nil)]) {
          cell.lblDetail.text = mobileString;
        } else {
          cell.lblDetail.text = [NSString stringWithFormat:@"%@ (%@)", mobileString, theRadio];
        }
      }
    }
    else if (row == 1)
    {
      cell.lblTitle.text = NSLocalizedString(@"Carrier_Name", nil);
      cell.lblDetail.text = self.carrierName;
    }
    else if (row == 2)
    {
      cell.lblTitle.text = NSLocalizedString(@"Carrier_Country", nil);
      cell.lblDetail.text = self.carrierCountryCode;
    }
    else if (row == 3)
    {
      cell.lblTitle.text = NSLocalizedString(@"Carrier_Network", nil);
      cell.lblDetail.text =self.carrierNetworkCode;
    }
    else if (row == 4)
    {
      cell.lblTitle.text = NSLocalizedString(@"Carrier_ISO", nil);
      cell.lblDetail.text = self.carrierIsoCode;
    }
    else if (row == 5)
    {
      cell.lblTitle.text = NSLocalizedString(@"Phone", nil);
      cell.lblDetail.text = self.device;
    }
    else if (row == 6)
    {
      cell.lblTitle.text = NSLocalizedString(@"OS", nil);
      cell.lblDetail.text = self.os;
    }
    else
    {
      SK_ASSERT(false);
    }
    
    
    return cell;
  }
}

- (void)viewDidUnload {
  [self setViewBG:nil];
  [super viewDidUnload];
}



//
//
//

-(NSString*) getTextForSocialMedia:(NSString*)socialNetwork {
  
  NSDictionary *testData = [testMetaData objectAtIndex:self.testIndex];
  
  if (testData == nil) {
    SK_ASSERT(false);
    return nil;
  }
  
  NSNumber *testId = [testData objectForKey:@"TEST_ID"];
  
  NSString *download = nil;
  NSString *upload = nil;
  
  // DOWNLOAD
  
  NSDictionary *downloadData = [SKDatabase getDownloadResultsForTestId:testId];
  
  if ([downloadData count] > 0)
  {
    double bitrateMbps1024Based = [[downloadData objectForKey:@"RESULT"] doubleValue];
    download = [SKGlobalMethods bitrateMbps1024BasedToString:bitrateMbps1024Based];
  }
  
  // UPLOAD
  
  NSDictionary *uploadData = [SKDatabase getUploadResultsForTestId:testId];
  
  if ([uploadData count] > 0)
  {
    double bitrateMbps1024Based = [[uploadData objectForKey:@"RESULT"] doubleValue];
    upload = [SKGlobalMethods bitrateMbps1024BasedToString:bitrateMbps1024Based];
    
  }
  
  /*
  // LATENCY and LOSS
  
  NSDictionary *latencyData = [SKDatabase getLatencyResultsForTestId:testId];
  NSDictionary *lossData = [SKDatabase getLossResultsForTestId:testId];
  
  if ([latencyData count] > 0 && [lossData count] > 0)
  {
    double latency = [[latencyData objectForKey:@"RESULT"] doubleValue];
    double loss = [[lossData objectForKey:@"RESULT"] doubleValue];
    
    strLatency = [NSString stringWithFormat:@"%@ ms", [SKGlobalMethods format2DecimalPlaces:latency]];
    strLoss = [NSString stringWithFormat:@"%d %%", (int)loss];
    
  }
  */
  
  return [SKAAppDelegate sBuildSocialMediaMessageForCarrierName:carrierName SocialNetwork:socialNetwork Upload:upload Download:download ThisDataIsAveraged:NO];
}

- (IBAction)actionButton:(id)sender {
  
//#if TARGET_IPHONE_SIMULATOR
//#else // TARGET_IPHONE_SIMULATOR
  if (![self.networkType isEqualToString:@"mobile"]) {
    UIAlertView *alert =
    [[UIAlertView alloc]
     initWithTitle:NSLocalizedString(@"Title_ShareUsingSocialMediaMobile",nil)
     message:NSLocalizedString(@"Message_ShareUsingSocialMediaMobile",nil)
     delegate:nil
     cancelButtonTitle:NSLocalizedString(@"MenuAlert_OK",nil)
     otherButtonTitles:nil];
    [alert show];
    return;
  }
//#endif // TARGET_IPHONE_SIMULATOR
  
  NSString *twitterString = [self getTextForSocialMedia:(NSString*)SLServiceTypeTwitter];
  NSString *facebookString = [self getTextForSocialMedia:(NSString*)SLServiceTypeFacebook];
  NSString *sinaWeiboString = [self getTextForSocialMedia:(NSString*)SLServiceTypeSinaWeibo];
  NSDictionary *dictionary = @{SLServiceTypeTwitter:twitterString, SLServiceTypeFacebook:facebookString, SLServiceTypeSinaWeibo:sinaWeiboString};
  
  [SKAAppDelegate showActionSheetForSocialMediaExport:dictionary OnViewController:self];
}

@end
