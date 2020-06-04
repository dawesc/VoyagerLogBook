//
//  PickerToolbar.h
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Voyager_Log_Book+CoreDataModel.h"

@interface ImagePicker : UIImageView<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

-(id) initWithParent:(UIViewController*)parent frame:(CGRect)frame;
@property (nonatomic, weak) UIViewController* parent;

-(bool) didChange;
-(void) setEnabled:(bool)enabled;
-(void) resetImage:(UIImage *)image;

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<UIImagePickerControllerInfoKey, id> *)editingInfo API_DEPRECATED("", ios(2.0, 3.0));

@end

