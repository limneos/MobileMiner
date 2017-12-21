//
//  AddConfigurationViewController.m
//  MobileMiner
//
//  Created by Elias Limneos on 15/12/2017.
//  Copyright © 2017 Elias Limneos. All rights reserved.
//

#include "AddConfigurationViewController.h"

@interface EditCell : UITableViewCell

@property (nonatomic, retain) UITextField *textField;
@end

@implementation EditCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
    
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
        self.contentView.layer.cornerRadius=15;
        self.contentView.layer.masksToBounds=YES;
        self.contentView.layer.borderWidth=1;
        self.contentView.layer.borderColor=[[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] CGColor];
        self.selectedBackgroundView=[UIView new];
        
        self.textField=[[UITextField alloc] initWithFrame:CGRectZero];
        self.textField.textColor=[UIColor whiteColor];
        self.textField.clearButtonMode=UITextFieldViewModeAlways;
        self.textField.autocorrectionType=UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType=UITextAutocapitalizationTypeNone;
        
        UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil action:nil];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone target:self
                                                                      action:@selector(doneClicked:)];
        
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexBarButton,doneButton, nil]];
        [flexBarButton release];
        [doneButton release];
        self.textField.inputAccessoryView = keyboardDoneButtonView;
        
    }
    
    return self;
}
-(void)setTextfieldPlaceholder:(NSString *)text{
    
    NSAttributedString * attr = [[NSAttributedString alloc] initWithString:self.textField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]}];
    self.textField.attributedPlaceholder = attr;
    [attr release];
    
}
-(void)doneClicked:(id)sender{
    
    [self.textField resignFirstResponder];

}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    if (self.textField.placeholder){
        self.contentView.frame=CGRectMake(20,10,self.contentView.frame.size.width-40,self.contentView.frame.size.height-20);
    }
    else{
        self.contentView.backgroundColor=[UIColor clearColor];
        self.contentView.layer.borderWidth=0;
        self.contentView.frame=CGRectMake(5,0,self.contentView.frame.size.width-10,self.contentView.frame.size.height);
    }
    
    [self.contentView addSubview:self.textField];
    
    if (self.textField.placeholder){
        [self setTextfieldPlaceholder:self.textField.placeholder];
        self.textField.frame=CGRectMake(20,0,self.contentView.frame.size.width-40,self.contentView.frame.size.height);
        if([self.textField.placeholder isEqualToString:@"2"]){
            self.textField.keyboardType=UIKeyboardTypeNumberPad;
        }
        if([self.textField.placeholder rangeOfString:@"stratum"].location!=NSNotFound){
            self.textField.keyboardType=UIKeyboardTypeURL;
        }
    }
    else{
        self.textField.alpha=0;
        self.textLabel.textColor=[UIColor whiteColor];
    }
    
}
-(void)dealloc{
    
    [self.textField release];
    [super dealloc];
    
}
@end


@implementation AddConfigurationViewController{
    NSDictionary *config;
    NSUserDefaults *defaults;
}
-(id)initWithConfiguration:(NSDictionary *)configuration{
    
    
    if (self=[super initWithStyle:UITableViewStylePlain]){
    
        config=[configuration retain];
        defaults=[NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        self.title=configuration ? @"Edit Configuration" : @"Add Configuration";
        
        
    }
    return self;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.row % 2){
        return 70;
    }
    return 20;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return config ? 12 : 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row==11){
        
        NSArray *configs=[defaults objectForKey:CONFIGS_KEY];
        if ([configs count]==1){
            [self simpleAlert:@"You need to have at least one configuration."];
        }
        else{
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"MobileMiner" message:@"Delete configuration?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *a){
                [self deleteCurrentConfig];
            }];
            [alert addAction:okAction];
            
            UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *a){}];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *REUSEID = [NSString stringWithFormat:@"Cell-%lu-%lu",indexPath.section,indexPath.row];
    EditCell *cell=(EditCell*)[tableView dequeueReusableCellWithIdentifier:REUSEID];
   
    NSInteger row=indexPath.row;
    NSString *placeholder=NULL;
    NSString *text=NULL;
    NSString *textFieldText=NULL;
    
    NSArray *configs=[defaults objectForKey:CONFIGS_KEY];
    
    //titles
    if (row==0){
        text=@"Configuration Name:";
    }
    if (row==2){
        text=@"Pool URL:";
    }
    if (row==4){
        text=@"Username/Address:";
    }
    if (row==6){
        text=@"Password:";
    }
    if (row==8){
        text=@"Threads:";
    }
    
    // values
    if (row==1){
        placeholder=[NSString stringWithFormat:@"Config%lu",[configs count]+1];
        textFieldText=[config objectForKey:@"name"];
    }
    if (row==3){
        placeholder=@"stratum+tcp://pool.electroneum.space:3333";
        textFieldText=[config objectForKey:@"url"];
    }
    if (row==5){
        placeholder=@"etnk2mq6kXN8HcnBeqiGgRVBivwCU2t842mWU6ZMaVMQDGWtJkGxJ5yhU5MZfKDF2cAaJ83JpnpqMCPAygT1CpgV6H3PzBLnwK";
        textFieldText=[config objectForKey:@"user"];
    }
    
    if (row==7){
        placeholder=@"x";
        textFieldText=[config objectForKey:@"pass"];
    }
    if (row==9){
        placeholder=@"2";
        textFieldText=[config objectForKey:@"threads"];
        
    }
    
    if (!cell){
        cell=[[EditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:REUSEID];
    }
    
    if (row==9){
        UIStepper *stepper=[[UIStepper alloc] initWithFrame:CGRectZero];
        [stepper addTarget:self action:@selector(stepperChanged:) forControlEvents:UIControlEventTouchUpInside];
        stepper.minimumValue=1;
        stepper.maximumValue=8;
        stepper.stepValue=1;
        stepper.wraps=NO;
        stepper.value=[config objectForKey:@"threads"] ? [[config objectForKey:@"threads"] intValue] : 2;
        CGRect frame=cell.textField.frame;
        frame.size.width=cell.contentView.frame.size.width-150;
        cell.textField.frame=frame;
        cell.textField.clearButtonMode=UITextFieldViewModeNever;
        cell.textField.userInteractionEnabled=NO;
        cell.textField.text= [config objectForKey:@"threads"] ?: @"2";
        cell.accessoryView=stepper;
        [stepper release];
        
    }
    if (row==0){
        cell.textField.autocapitalizationType=UITextAutocapitalizationTypeAllCharacters;
    }
    cell.textField.placeholder=placeholder;
    cell.textLabel.text=text;
    if (config){
        cell.textField.text=textFieldText;
    }
    if (row==11){
        
        cell.textField.placeholder=@"Delete";
        cell.textField.text=@"Delete";
        cell.contentView.backgroundColor=[UIColor redColor];
        cell.textField.userInteractionEnabled=NO;
        cell.textField.textAlignment=NSTextAlignmentCenter;
        cell.textField.clearButtonMode=UITextFieldViewModeNever;
    }
    
    return cell;
}
-(void)stepperChanged:(UIStepper *)sender{
    int value = [sender value];
    EditCell *cell=(EditCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9  inSection:0]];
    cell.textField.text=[NSString stringWithFormat:@"%d", (int)value];
}
-(void)viewDidLoad{
    
    [super viewDidLoad];
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:config ? @"Save" : @"Done" style:UIBarButtonItemStyleDone target:self action:@selector(addConfig:)];
    self.navigationItem.rightBarButtonItem=right;
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor colorWithRed:1 green:0.8 blue:0 alpha:1];
    [right release];
    self.view.backgroundColor=[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    ((UITableView *)self.view).tableFooterView=[[UIView alloc] init];
    ((UITableView *)self.view).tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,20)];
    if ([self isModal]){
        UIBarButtonItem *left=[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelModal:)];
        self.navigationItem.leftBarButtonItem=left;
        [left release];
    }
}
-(void)cancelModal:(id)sender{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (BOOL)isModal {
    
    return ![[self parentViewController] isKindOfClass:NSClassFromString(@"SettingsNavigationController")];
}
-(void)addConfig:(UIButton*)button{
    
    
    EditCell *cell5=(EditCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1  inSection:0]];
    EditCell *cell1=(EditCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3  inSection:0]];
    EditCell *cell2=(EditCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5  inSection:0]];
    EditCell *cell3=(EditCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7  inSection:0]];
    EditCell *cell4=(EditCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9  inSection:0]];
    
    
    NSString *url= [cell1.textField.text length] ? cell1.textField.text : cell1.textField.placeholder;
    NSString *user= [cell2.textField.text length] ? cell2.textField.text : cell2.textField.placeholder;
    NSString *pass= [cell3.textField.text length] ? cell3.textField.text : cell3.textField.placeholder;
    NSString *threads= [cell4.textField.text length] ? cell4.textField.text : cell4.textField.placeholder;
    NSString *name= [cell5.textField.text length] ? cell5.textField.text : cell5.textField.placeholder;
    
    
    NSMutableArray *configs=[defaults mutableArrayValueForKey:CONFIGS_KEY] ?: [NSMutableArray array];
    NSDictionary *foundConfig=NULL;
    for (NSDictionary *aconfig in configs){
        if ([[aconfig objectForKey:@"url"] isEqual:url]
            && [[aconfig objectForKey:@"user"] isEqual:user]
            && [[aconfig objectForKey:@"pass"] isEqual:pass]
            && [[aconfig objectForKey:@"threads"] isEqual:threads]){
        
            foundConfig=aconfig;
            if (!config){
                [self simpleAlert:@"This configuration already exists."];
            }
            break;
        }
        else if ([[aconfig objectForKey:@"name"] isEqual:name]){
            foundConfig=aconfig;
            if (!config){
                [self simpleAlert:@"A configuration with the same name already exists."];
            }
            else{
                if (![aconfig isEqual:config] && [[aconfig objectForKey:@"name"] isEqual:name]){
                    [self simpleAlert:@"Another configuration with the same name already exists."];
                    return;
                }
            }
            break;
        }
    }
    if (!config){
        if (!foundConfig){
            
            NSMutableDictionary *dict=[NSMutableDictionary dictionary];
            [dict setObject:url forKey:@"url"];
            [dict setObject:user forKey:@"user"];
            [dict setObject:pass forKey:@"pass"];
            [dict setObject:threads forKey:@"threads"];
            [dict setObject:name forKey:@"name"];
            CFUUIDRef theUUID = CFUUIDCreate(NULL);
            CFStringRef uuid = CFUUIDCreateString(NULL, theUUID);
            CFRelease(theUUID);
            [dict setObject:(id)uuid forKey:@"id"];
            [configs addObject:dict];
            
            NSArray *immutableConfigs=[configs copy];
            [defaults setObject:immutableConfigs forKey:CONFIGS_KEY];
            [immutableConfigs release];
            [defaults synchronize];

            
            if ([self isModal]) {
                [self dismissViewControllerAnimated:YES completion:NULL];
            }
            else{
                [[self navigationController] popViewControllerAnimated:YES];
            }
            

        }
        
    }
    else{
        NSMutableDictionary *mutableConfig=[config mutableCopy];
        [mutableConfig setObject:url forKey:@"url"];
        [mutableConfig setObject:user forKey:@"user"];
        [mutableConfig setObject:pass forKey:@"pass"];
        [mutableConfig setObject:threads forKey:@"threads"];
        [mutableConfig setObject:name forKey:@"name"];
        unsigned long index=[configs indexOfObject:foundConfig];
        [configs replaceObjectAtIndex:index withObject:mutableConfig];
        NSArray *immutableConfigs=[configs copy];
        [defaults setObject:immutableConfigs forKey:CONFIGS_KEY];
        [immutableConfigs release];
        [mutableConfig release];
        
        [defaults synchronize];
        if ([self isModal]) {
            
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
        else{
            [[self navigationController] popViewControllerAnimated:YES];
        }
        
        
    }
    
    
    
}
-(void)deleteCurrentConfig{
    
    
    NSMutableArray *configs=[defaults mutableArrayValueForKey:CONFIGS_KEY];
    NSDictionary *foundDict=NULL;
    for (NSDictionary *dict in configs){
        if ([[dict objectForKey:@"id"] isEqual:[config objectForKey:@"id"]]){
            foundDict=dict;
            break;
        }
    }
    [configs removeObject:foundDict];
    NSArray *immutableConfigs=[configs copy];
    [defaults setObject:immutableConfigs forKey:CONFIGS_KEY];
    [immutableConfigs release];
    [defaults synchronize];
    [[self navigationController] popViewControllerAnimated:YES];
    
}
-(void)simpleAlert:(NSString *)alertString{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"MobileMiner" message:alertString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a){}];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)dealloc{
    [config release];
    [super dealloc];
}
@end
