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
static NSString* kMAPIKey    = @"ApIkEy";
static NSString* kMAPISecret = @"SeCrEtKeY";

@implementation RootViewController

@synthesize status  = _status;
@synthesize matchID = _matchID;

- (void)takePicture {
    MImagePickerController * picker = [[MImagePickerController alloc] initWithKey:kMAPIKey andSecret:kMAPISecret];
    picker.delegate = self;
    [self presentModalViewController:picker animated:NO];
    [picker release];
}

#pragma mark -
#pragma mark MImagePickerControllerDelegate

- (void)imagePickerController:(MImagePickerController*)picker didFinishQueryingWithInfo:(NSDictionary *)info {
    [self dismissModalViewControllerAnimated:NO];
        
    if ([info objectForKey:@"error"] == nil) {
        BOOL found = [[info objectForKey:@"found"] boolValue];
        if (found) {
            // The API found a match: let's obtain the result ID
            self.matchID = [info objectForKey:@"id"];
            self.status = @"Match found";
        }
        else {
            // No match found
            self.matchID = nil;
            self.status = @"No match found";
        }
    }
    else {
        // An error occurred while querying
        // The "error" key contains a message which could be:
        // * "Connection failure"
        // * "Request timed out"
        // * "Authentication error", i.e. wrong API key / secret pair
        // * "Internal error", for miscellaneous error
        [[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                     message:[info objectForKey:@"error"]
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil] autorelease] show];
    }
    
    // (optional) if needed, you can retrieve the original image that has just been scanned
    // e.g. this is useful if your application needs to upload it, save it into the library, etc
    //
    // This image corresponds to the `UIImagePickerControllerOriginalImage' format (resolution is 2592x1936 on an iPhone 4)
    UIImage* image = [info objectForKey:@"image"];
    // ... do something useful with `image'
    
    [self.tableView reloadData];
}

- (void)imagePickerControllerDidCancel:(MImagePickerController*)picker {
    [self dismissModalViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                       target:self action:@selector(takePicture)] autorelease];
    self.title = @"Moodstocks SDK Demo";
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger nbRows;
    
    switch (section) {
        case 0:
        case 1:
            nbRows = 1;
            break;
            
        default:
            nbRows = 0;
    }
    
    return nbRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
   NSString * title; 
    switch (section) {
        case 0:
            title = @"Status";
            break;
        case 1:
            title = @"Match ID";
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
        textLabel.text = self.status ? self.status : @"N/A";
    }
    else if ([indexPath section] == 1) {
        textLabel.text = self.matchID ? self.matchID : @"N/A";
    }

    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // do nothing
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_status release];
    [_matchID release];

    [super dealloc];
}


@end

