//
//  PickerToolbar.m
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import "ImagePicker.h"
#import "DetailViewController.h"

@interface ImagePicker ()

@end

@implementation ImagePicker {
  bool didChange;
  bool enabled;
  bool empty;
}

-(id) initWithParent:(UIViewController*)parent frame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    didChange = false;
    enabled   = true;
    empty     = true;
    self.parent = parent;
    [self setImage:[UIImage imageNamed:@"ClickToSelect.png"]];
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [[UIColor grayColor] CGColor];
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.userInteractionEnabled = true;
    UITapGestureRecognizer* tapper  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSelected:)];
    tapper.numberOfTapsRequired     = 1;
    tapper.numberOfTouchesRequired  = 1;
    [self addGestureRecognizer:tapper];
    
  }
  return self;
}

-(bool) didChange {
  return didChange;
}

-(void) setEnabled:(bool)enabledP {
  enabled = enabledP;
  if (empty) {
    if (enabled) {
      [self setImage:[UIImage imageNamed:@"ClickToSelect.png"]];
    } else {
      self.image = nil;
    }
  }
}

-(void) resetImage:(UIImage *)image {
  didChange = false;
  empty = (image == nil);
  self.image = image;
  [self setEnabled:enabled];
}

-(void)imageSelected:(UITapGestureRecognizer *)recognizer {
  if (!enabled) return;
  UIImagePickerController* imagePicker  = [[UIImagePickerController alloc] init];
  imagePicker.sourceType                = UIImagePickerControllerSourceTypePhotoLibrary;
  //imagePicker.allowsEditing             = false;
  imagePicker.delegate                  = self;
  [self.parent presentViewController:imagePicker animated:true completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<UIImagePickerControllerInfoKey, id> *)editingInfo API_DEPRECATED("", ios(2.0, 3.0)) {
  [self.parent dismissViewControllerAnimated:true completion:nil];
  self.image  = image;
  didChange   = true;
  empty       = false;
}

@end
