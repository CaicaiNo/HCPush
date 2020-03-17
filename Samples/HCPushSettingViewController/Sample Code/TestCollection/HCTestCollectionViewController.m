//
//  HCTestCollectionViewController.m
//  HCPushSettingViewController
//
//  Created by haocaihaocai on 2020/3/16.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//

#import "HCTestCollectionViewController.h"
#import "HCCollectionViewCell.h"
#import "HCTestTableViewController.h"
@interface HCTestCollectionViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HCTestCollectionViewController

static NSArray* MediaImages;
static NSArray* MediaTitles;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HCCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HCCollectionReusableFooterView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SperateLineReuseView"];
    
    MediaImages = @[@"share_weixin",@"share_qq",@"share_link",@"share_weibo"];
    MediaTitles = @[@"Wechat",@"QQ",@"Link",@"Sina"];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UICollectionViewDataSource
static NSString * const kCellIdentifier = @"CellIdentifier";

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return section == 0 ? 6 : 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.iconImageView.image = [UIImage imageNamed:MediaImages[indexPath.row % 4]];
    cell.nameLabel.text = MediaTitles[indexPath.row % 4];
   
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.HCParentController) {
        self.HCParentController.pushChildViewController = [[HCTestTableViewController alloc] init];
    }
    NSLog(@"%@",MediaTitles[indexPath.row % 4]);
}

#pragma mark - UICollectionViewDelegateLeftAlignedLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 80);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return section == 0 ? 15 : 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SperateLineReuseView" forIndexPath:indexPath];
        return footerView;
    }
    return nil;
}

#pragma mark - Rotation

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeRight;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight;
}

@end
