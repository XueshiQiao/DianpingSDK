//
//  DPHomeViewController.m
//  DianpingSDKDemo
//
//  Created by Johnny on 11/10/13.
//  Copyright (c) 2013 Johnny. All rights reserved.
//

#import "DPHomeViewController.h"
#import "DPObject.h"
#import "DPAPI.h"

static NSString * const cellIdentifier = @"cell";

@interface DPHomeViewController ()

@property (nonatomic, strong) NSArray *businesses;
@property (nonatomic, strong) NSArray *deals;

@end

@implementation DPHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Dianping SDK Demo";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    [self loadBusinesses];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)loadBusinesses
{
    /*
    NSDictionary *params = @{@"city" : @"杭州"};
    
    NSURLSessionTask *task = [DPBusiness businessesWithParams:[DPAPI signedParamsWithParmas:params]
                                                      block:^(NSArray *businesses, NSError *error) {
                                                          if (!error) {
                                                              self.businesses = businesses;
                                                              [self.tableView reloadData];
                                                          }
                                                          else {
                                                              NSLog(@"%@", [error localizedDescription]);
                                                          }
                                                      }
                              ];
     */
    
    
    
    NSDictionary *params = @{@"deal_id" : @"1-5097286"};
    
    NSURLSessionTask *task = [DPDeal dealsWithParams:[DPAPI signedParamsWithParmas:params]
                                                        block:^(NSArray *deals, NSError *error) {
                                                            if (!error) {
                                                                self.deals = deals;
                                                                [self.tableView reloadData];
                                                            }
                                                            else {
                                                                NSLog(@"%@", [error localizedDescription]);
                                                            }
                                                        }
                              ];
    
    [task resume];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deals.count;
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DPBusiness *business = self.businesses[indexPath.row];
    DPDeal *deal = self.deals[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.text = business.name;
    
    cell.textLabel.text = deal.desc;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
