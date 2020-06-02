//
//  PickerToolbar.h
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Voyager_Log_Book+CoreDataModel.h"

@interface PickerToolbar : UIToolbar

-(id) initWithTextField:(UITextField*)textField picker:(id)picker title:(NSString*)title;
@property (nonatomic, weak) UITextField* textFieldL;

@end

