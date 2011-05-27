//
//  Copyright 2010-2011 Moodstocks. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSScannerControllerDelegate;

@interface MSScannerController : UIViewController {

}

/**
 * BARCODE DECODING
 * --
 *
 * Use these flags to enable/disable decoding per barcode format according to
 * your needs. By default *all* formats are enabled.
 *
 * If you are only interested in image decoding and want to completely turn off
 * barcode decoding, simply disable all flags.
 */
@property (nonatomic, assign) BOOL decodeUPC_E;
@property (nonatomic, assign) BOOL decodeEAN_8;
@property (nonatomic, assign) BOOL decodeEAN_13;
@property (nonatomic, assign) BOOL decodeCODE_128;
@property (nonatomic, assign) BOOL decodeCODE_39;
@property (nonatomic, assign) BOOL decodeITF;

/**
 * The scanner delegate (see protocol below)
 */
@property (nonatomic, assign) id <MSScannerControllerDelegate> delegate;

/**
 * Init with a valid Moodstocks API key/secret pair
 */
- (id)initWithKey:(NSString *)aKey andSecret:(NSString *)aSecret;

@end

/**
 * SCANNER PROTOCOL
 * --
 *
 * Informs the delegate of scanning results.
 *
 * All methods are optional but in practice you should always implement:
 * - `didScanBarcode' and/or `didScanObject' according to your needs
 * - `scannerControllerDidCancel' since it's up to you to dismiss the current
 *    scanner controller
 */
@protocol MSScannerControllerDelegate<NSObject>
@optional

/**
 * Called when an object has been successfully decoded via image search.
 *
 * - `objectID' holds the ID of the found object as it has been indexed on Moodstocks API
 * - `info' holds a dictionary that provides additional information, so far:
 *   - the image successfully recognized under the key @"image"
 *
 * It's up to the caller to dismiss the current scanner controller.
 */
- (void)scannerController:(MSScannerController*)scanner didScanObject:(NSString*)objectID withInfo:(NSDictionary*)info;

/**
 * Called when image search failed for some reason.
 *
 * - `image' represents the latest frame that was scanned
 * - `reason' indicates why scanning failed, i.e.:
 *   - @"Invalid credentials": wrong key/secret pair
 *   - @"No connection": no Internet connection (required for image search only)
 *   - @"Max tries": no results have been found after several tries (that said the scanner keeps processing)
 *   - @"Unknown": internal error
 *
 * This method is mainly provided for debugging/logging purpose since in most cases you should let the
 * end user acts according to the scanner info view messages.
 */
- (void)scannerController:(MSScannerController*)scanner failedToScanObject:(UIImage*)image withReason:(NSString*)reason;

/**
 * Called when a barcode has been successfully decoded.
 *
 * - `ean' holds the string that represents the decoded barcode value, e.g. @"3384442115711"
 * - `info' holds a dictionary that provides additional information, so far:
 *   - the barcode type under the key @"barcode_type", e.g. @"ean_13"
 *
 * It's up to the caller to dismiss the current scanner controller.
 */
- (void)scannerController:(MSScannerController*)scanner didScanBarcode:(NSString*)ean withInfo:(NSDictionary*)info;

/**
 * Called when the Cancel button has been touched and the scanner should be dismissed.
 *
 * It's up to the caller to dismiss the current scanner controller.
 */
- (void)scannerControllerDidCancel:(MSScannerController*)scanner;
@end