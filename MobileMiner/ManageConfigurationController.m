//
//  ManageConfigurationController.m
//  MobileMiner
//
//  Created by Elias Limneos on 16/12/2017.
//  Copyright © 2017 Elias Limneos. All rights reserved.
//

#include "ManageConfigurationController.h"
#include "AddConfigurationViewController.h"
#include "CustomCell.h"

@implementation ManageConfigurationController{
    NSUserDefaults *defaults;
    UIBarButtonItem *rightItem;
    UIBarButtonItem *leftItem;
    BOOL readOnly;
}
-(void)simpleAlert:(NSString *)alertString{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"MobileMiner" message:alertString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a){}];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return !readOnly;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (readOnly){
        return;
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *configs=[defaults objectForKey:CONFIGS_KEY];
        if ([configs count]==1){
            [self simpleAlert:@"You need to have at least one configuration."];
            return;
        }
        
        [tableView beginUpdates];
        
        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        NSMutableArray *array=[defaults mutableArrayValueForKey:CONFIGS_KEY];
        for (int i=0; i<[array count]; i++){
            NSDictionary *dict=[array objectAtIndex:i];
            CustomCell *cell=(CustomCell *)[tableView cellForRowAtIndexPath:indexPath];
            if ([[dict objectForKey:@"id"] isEqual:cell.configId]){
                [array removeObject:dict];
            }
            NSArray *immutableArray=[array copy];
            [defaults setObject:immutableArray forKey:CONFIGS_KEY];
            [defaults synchronize];
            
        }
        [tableView endUpdates];
        
    }
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem=readOnly ? NULL : [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(toggleEdit:)];
    rightItem=self.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor colorWithRed:1 green:0.8 blue:0 alpha:1];
    self.tableView.allowsSelectionDuringEditing=YES;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.tableView.separatorColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    UIBlurEffect *blurEffect=[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.tableView.separatorEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    
    
}
-(void)toggleEdit:(UIBarButtonItem *)sender{
    self.editing=!self.isEditing;
    [self.tableView reloadData];
}
-(id)init{
    
    if (self=[super initWithStyle:UITableViewStylePlain]){
        defaults=[NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        
    }
    return self;
    
}
-(id)initReadOnly{
    
    if (self=[super initWithStyle:UITableViewStylePlain]){
        defaults=[NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        readOnly=YES;
    }
    return self;
}
-(void)setEditing:(BOOL)editing{
    [super setEditing:editing];
    if (readOnly){
        return;
    }
    rightItem.title=self.editing ? @"Done" : @"Edit";
    if (editing){
        if (!leftItem){
            leftItem=[[UIBarButtonItem alloc] initWithTitle:@"Add New" style:UIBarButtonItemStylePlain target:self action:@selector(addConfig:)];
            leftItem.tintColor=[UIColor colorWithRed:1 green:0.8 blue:0 alpha:1];
        }
        self.navigationItem.leftBarButtonItem=leftItem;
    }
    else{
        self.navigationItem.leftBarButtonItem=NULL;
    }
}
-(void)addConfig:(id)sender{
    UINavigationController *navi=[[UINavigationController alloc] initWithRootViewController:[[AddConfigurationViewController alloc] initWithConfiguration:NULL]];
    
    [self presentViewController:navi animated:YES completion:^{
        [self setEditing:NO];
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray *)[defaults objectForKey:CONFIGS_KEY] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (readOnly){
        CustomCell *cell=(CustomCell *)[tableView cellForRowAtIndexPath:indexPath];
        [defaults setObject:cell.configId forKey:@"activeConfigurationID"];
        [defaults synchronize];
        [[self navigationController] popViewControllerAnimated:YES];
        return;
    }
    if (![(NSArray *)[defaults objectForKey:CONFIGS_KEY] count]){
        return;
    }
    NSDictionary *dict=[[defaults objectForKey:CONFIGS_KEY] objectAtIndex:indexPath.row];
    if (!self.isEditing){
        [self.navigationController pushViewController:[[AddConfigurationViewController alloc] initWithConfiguration:dict] animated:YES];
    }
    
}
-(id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath  {
    
    NSString *REUSEID = [NSString stringWithFormat:@"BCELL-%d-%d",(int)indexPath.section,(int)indexPath.row];
    CustomCell *cell=[tableView dequeueReusableCellWithIdentifier:REUSEID];
    if (!cell){
        cell=[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:REUSEID];
    }
    NSArray *configs=[defaults objectForKey:CONFIGS_KEY];
    cell.textLabel.text=[[configs objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.configId=[[configs objectAtIndex:indexPath.row] objectForKey:@"id"];
    if (readOnly){
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    cell.hasSeparator=YES;
    return (UITableViewCell *)cell;
}
-(id)title{
    return readOnly ? @"Choose Configuration" : @"Edit Configurations";
}
-(void)dealloc{
    [rightItem release ];
    [leftItem release];
    [super dealloc];
}
@end
