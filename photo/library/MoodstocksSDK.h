//
//  Copyright 2010 Moodstocks. All rights reserved.
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

@protocol MImagePickerControllerDelegate;

@interface MImagePickerController : UIViewController {
    id<MImagePickerControllerDelegate> delegate;
}

@property (nonatomic, assign) id <MImagePickerControllerDelegate> delegate;

- (id)initWithKey:(NSString *)aKey andSecret:(NSString *)aSecret;

@end

@protocol MImagePickerControllerDelegate<NSObject>
- (void)imagePickerController:(MImagePickerController*)picker didFinishQueryingWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(MImagePickerController*)picker;
@end