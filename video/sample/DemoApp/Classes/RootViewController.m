/**
 * Copyright (c) 2010-2011 Moodstocks SAS
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "RootViewController.h"

/**
 * PLEASE MAKE SURE TO REPLACE WITH YOUR KEY/SECRET PAIR
 *
 * For more details, please refer to:
 * https://github.com/Moodstocks/moodstocks-api/wiki/api-v2-doc
 */
static NSString* kMSAPIKey    = @"ApIkEy";
static NSString* kMSAPISecret = @"SeCrEt";

@implementation RootViewController

@synthesize resultID  = _resultID;
@synthesize resultType = _resultType;

- (void)scanAction {
    MSScannerController* scanner = [[MSScannerController alloc] initWithKey:kMSAPIKey andSecret:kMSAPISecret];
    scanner.delegate = self;
    
    // Notes about barcode decoding
    // --
    // By default *all* barcode formats are decoded. You can easily enable/disable decoding
    // per barcode format, e.g.:
    /*
    scanner.decodeITF   = NO; // do NOT decode ITF format
    scanner.decodeUPC_E = NO; // do NOT decode UPC-E format
    */
    
    // You can also completely turn off barcode decoding by setting all these flags to NO
    
    // Notes about scanner messages
    // --
    // The scanner includes an info view with displayed message to help the end user understand
    // what's going on (see MoodstocksSDK.h for more details). You can freely customize / localize
    // each message if you wish, e.g.:
    /*
    scanner.noConnectionMessage = @"There is no Internet connection: please try again later.";
    */
    
    [self presentModalViewController:scanner animated:YES];
    [scanner release];
}

#pragma mark -
#pragma mark MSScannerControllerDelegate

- (void)scannerController:(MSScannerController*)scanner didScanObject:(NSString*)objectID withInfo:(NSDictionary*)info {
    // An object has been successfully scanned: let's dismiss the scanner
    [self dismissModalViewControllerAnimated:YES];
        
    // `objectID' is the ID you've used to index this object on Moodstocks API
    //
    // In most cases you'll have now to retrieve related metadata (e.g. URL, product title)
    //
    // Such data could:
    //
    // * be decoded from the objectID if you've chosen to do so (e.g. obtain an URL from base64url encoded ID)
    //   see "Step 5 - Decode ID and open the URL" from tutorial:
    //   https://github.com/Moodstocks/moodstocks-api/wiki/usnap-like-application
    //
    // * be fetched from a local database
    // * be fetched from a remote database via an HTTP call to your web server
    //   see https://github.com/Moodstocks/moodstocks-api/wiki/api-v2-help-appmodel
    self.resultID = objectID;
    self.resultType = @"Image";
    
    // (optional) if needed, you can retrieve the image that has just been successfully scanned
    // e.g. this is useful if your application needs to upload it, save it into the library, etc
    /*
    UIImage* image = [info objectForKey:@"image"];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    */
    
    [self.tableView reloadData];
}

- (void)scannerController:(MSScannerController*)scanner didScanBarcode:(NSString*)ean withInfo:(NSDictionary*)info {
    // A barcode has been successfully scanned: let's dismiss the scanner
    [self dismissModalViewControllerAnimated:YES];
    
    // `ean' gives the decoded barcode value (e.g. @"3384442115711")
    // You can also query the `info' dict for the @"barcode_type" (e.g. @"ean_13")
    self.resultID = ean;
    self.resultType = (NSString *) [info objectForKey:@"barcode_type"];
    
    [self.tableView reloadData];
}

- (void)scannerControllerDidCancel:(MSScannerController*)scanner {
    // The user has just clicked on Cancel: let's dismiss the scanner
    [self dismissModalViewControllerAnimated:YES];
    
    self.resultID = nil;
    self.resultType = nil;
    
    [self.tableView reloadData];
}

// -------------------------------------------------
// DEBUG ONLY
// -------------------------------------------------
//
// This method receives messages sent by the scanner to ease the process of development in DEBUG mode
//
- (void)scannerController:(MSScannerController*)scanner failedToScanObject:(UIImage*)image withReason:(NSString*)reason {
    //`reason' is a string containing a debugging information, e.g. @"Invalid credentials" if the API key/secret	
    // has not been sent correctly.
    //
    // IMPORTANT: do *NOT* rely on these messages to implement specific application logic.

    NSLog(@"[MS SCANNER] Object scan failed, reason: %@", reason);
    
    // (optional) if needed, you can use the latest scanned frame
    // e.g. this could be useful in advanced cases if your application needs to do something when scanning
    //      couldn't find results
    /*
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    */
    
    self.resultID = nil;
    self.resultType = nil;
    
    [self.tableView reloadData];
}
// -------------------------------------------------
// DEBUG ONLY
// -------------------------------------------------

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                       target:self action:@selector(scanAction)] autorelease];
    self.title = @"Moodstocks SDK Demo";
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
   NSString * title; 
    switch (section) {
        case 0:
            title = @"Result ID";
            break;
        case 1:
            title = @"Result type";
            break;
            
        default:
            title = @"";
    }
    
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    UILabel* textLabel = cell.textLabel;
    
    if ([indexPath section] == 0) {
        textLabel.text = self.resultID;
    }
    else if ([indexPath section] == 1) {
        textLabel.text = self.resultType;
    }

    return cell;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [_resultID release];
    [_resultType release];

    [super dealloc];
}


@end
