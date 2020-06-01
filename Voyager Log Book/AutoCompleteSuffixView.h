#import <UIKit/UIKit.h>

@interface AutoCompleteRexView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITextField *bindedTextField;
@property (nonatomic, strong) NSArray *suffixs;
@property (nonatomic) BOOL roundedBorder; //default YES
@property (nonatomic) CGFloat maxDisplayHeight;

//should use this init, any other init method will not work.
- (id)initWithInputField:(UITextField *)inputField suffixs:(NSArray *)suffixs;
@end
