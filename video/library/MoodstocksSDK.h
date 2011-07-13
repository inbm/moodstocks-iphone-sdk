//
//  Copyright 2010-2011 Moodstocks. All rights reserved.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
 * INFO VIEW MESSAGES
 * --
 *
 * The scanner includes an info view on bottom of the screen that is kept
 * updated so that to inform the end user what is going on, e.g. in case
 * of no Internet connection.
 *
 * The scanner provides default English messages that you may want to customize
 * or localize by using the following setters.
 *
 * `readyMessage'
 * --
 * Message displayed when the scanner is ready to scan.
 *
 * Default:
 * "I'm ready to scan! Just point me to the object of interest."
 *
 * `scanningMessage'
 * --
 * Message displayed when the scanner is processing.
 *
 * Default:
 * "I'm scanning right now. Hold me still while I'm processing!"
 *
 * `maxTriesMessage'
 * --
 * Message displayed when the scanner could not find a result
 * after several consecutive tries. It *keeps* scanning after
 * this message has been displayed.
 *
 * Default:
 * "I'm having trouble finding information but I'm not giving up!"
 *
 * `noConnectionMessage'
 * --
 * Message displayed when there is no Internet connection 
 * (and a connection is required for image decoding)
 *
 * Default:
 * "I couldn't find any Internet connection!"
 *
 * `sleepMessage'
 * --
 * Message displayed when the scanner enters the sleep mode
 * if left untouched for a long amount of time. 
 *
 * Default:
 * "I got tired of waiting. But we can make me up by shaking me!"
 */
@property (nonatomic, copy) NSString* readyMessage;
@property (nonatomic, copy) NSString* scanningMessage;
@property (nonatomic, copy) NSString* maxTriesMessage;
@property (nonatomic, copy) NSString* noConnectionMessage;
@property (nonatomic, copy) NSString* sleepMessage;

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