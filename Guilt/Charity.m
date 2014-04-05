//
//  Charity.m
//  Guilt
//
//  Created by John Andrews on 3/16/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "Charity.h"

@implementation Charity
- (UIImage *)charityImageURLSForSpecifcCharity:(NSUInteger)specificCharity
{
    NSArray *charityImagesArray = [NSArray array];
    charityImagesArray = @[@[
                               @"http://www.assisianimalhealth.com/news/wp-content/uploads/2012/11/Animal-Rescue.jpg",
                               @"http://designyoutrust.com/wp-content/uploads/2011/10/animal-rescue-operations-c.jpg",
                               @"http://www.bored-todeath.com/wp-content/uploads/2011/07/animal-rescue-08.jpg",
                               @"http://muttshack.org/images/NMlucy.jpg",
                               @"http://matchbin-assets.s3.amazonaws.com/public/sites/274/assets/1QLD_102610AnimalShelter09.jpg",
                               @"http://media.nola.com/pets_impact/photo/9634751-large.jpg",
                               @"http://vetcareproject.com/wp-content/uploads/2013/03/wp2.jpg",
                               @"http://media.npr.org/assets/img/2013/02/06/dog_wide-e19af42dcba6ac82e35773015db5d04ef49c9beb-s6-c30.jpg",
                               @"http://www.chewy.com/c/sites/default/files/imce/animal-shelter.jpg",
                               @"http://i.huffpost.com/gen/1318622/thumbs/o-DETROIT-DOG-RESCUE-570.jpg?6",
                               @"http://assets3.razoo.com/assets/media/images/000/061/307/images/size_550x415_110523_WARL0011.png?1317834667",
                               @"http://www.tennisconnect.org/pages/TXgiammalva/image/aar3.jpg",
                               @"http://d2mlnkprj9wd81.cloudfront.net/sites/default/files/imagecache/themeSlideshow/theme-AR_0.jpg"
                               ],
                           @[
                               @"http://www.un.org/News/dh/photos/large/2011/November/17-11-2011ivoire.jpg",
                               @"http://www.careerbreak360.com/wp-content/uploads/2013/03/unicef1.jpg",
                               @"http://static.guim.co.uk/sys-images/Guardian/Pix/pictures/2011/6/15/1308133033232/Photos-taken-by-children--020.jpg",
                               @"http://www.comminit.com/files/unicef_photography.jpg",
                               @"http://www.unicef.org.uk/Images/Media-medium-201x106/Legacy.jpg",
                               @"http://www.unmultimedia.org/radio/english/wp-content/uploads/2013/04/UNI76342-384x262.jpg",
                               @"http://blog.unicef.org.nz/wp-content/uploads/2012/05/P1010925.jpg",
                               @"http://newsimg.bbc.co.uk/media/images/41608000/jpg/_41608896_unicef4.jpg",
                               @"http://www.e4conference.org/wp-content/uploads/2010/03/UNICEF.NYHQ2006-0322.Giacomo.Pirozzi-.jpg",
                               @"http://www.educationandtransition.org/wp-content/uploads/2011/11/Sudan-Girls-smile-in-an-outdoor-classroom-at-the-UNICEF-supported-Gua-Community.jpg",
                               @"http://www.unicef.org.uk/PageFiles/220169/back-to-school-3.jpg",
                               @"http://www.gucci.com/images/ecommerce/styles_new/201006/web_inset/wg_unicef_history_4_web_inset.jpg",
                               @"http://69.41.180.110/userfiles/image/Haiti%20UNICEF%20B.jpg"
                               ],
                           @[
                               @"http://www.cardonationwizard.com/blog/wp-content/uploads/2011/04/ftc3.jpg?w=300",
                               @"http://blogs.csdw.org/wp-content/uploads/FTC-drinking-2.jpg",
                               @"http://philanthropy.com/img/photos/biz/photo_3185_carousel.jpg",
                               @"http://www.topsecretwriters.com/wp-content/uploads/2012/10/haitichildren.jpg",
                               @"http://www.fmsc.org/view.image?Id=520",
                               @"http://shepherd-hills.com/wp-content/uploads/2013/05/Girls+bowls_Asia.300x200.jpg"
                               ],
                           @[
                               @"http://9dc3f407a257cfd3f7ea-d14ef12e680aa00597bdffb57368cf92.r6.cf2.rackcdn.com/gift-catalog/animals/ducks2.jpg",
                               @"http://www.fauxfarmgirl.com/wp-content/uploads/2008/11/ducks_large1.jpg",
                               @"http://www.ineedprettythings.com/wp-content/uploads/2010/12/geese.jpg",
                               @"http://www.leonardleonard.com/philanthropy/img/heifer-ducks.jpg",
                               @"http://9dc3f407a257cfd3f7ea-d14ef12e680aa00597bdffb57368cf92.r6.cf2.rackcdn.com/Ending_Hunger/global_challanges/answering-challenges01.jpg",
                               @"http://4.bp.blogspot.com/-eqa-ODeCaX0/UKpjBVhSb-I/AAAAAAAAAZw/gtQSw690Eeg/s1600/nc_chicks1_big_thumb%255B1%255D.jpg",
                               @"http://www.heifer.org/armenia/wp-content/uploads/2013/06/Young-Duck-farmer.jpg",
                               @"http://robinfollette.com/wp-content/uploads/Flock-of-Ducks-Pham-Thi-Nguyen-in-Vietnam.jpg",
                               @"http://2.bp.blogspot.com/-pexM23gc-0c/Tt6am8-MfjI/AAAAAAAAA_0/lw-YOn17t5A/s1600/6427450449_8ee8991ba4.jpg",
                               @"http://www.theglobalbridge.com/uploads/China%20Ducks.jpg",
                               @"http://www.patrickrothfuss.com/blog/uploaded_images/Chicken.Large-772548.jpg",
                               @"http://www.motherearthnews.com/~/media/Images/MEN/Editorial/Articles/Magazine%20Articles/2005/12-01/Changing%20the%20World%20One%20Chicken%20at%20a%20Time/Heifer-girl_chicken1.jpg",
                               @"https://shop.heifer.org/media/catalog/product/cache/4/image/370x/9df78eab33525d08d6e5fb8d27136e95/n/c/nc_ducks_big_thumb_1.jpg",
                               @"http://9dc3f407a257cfd3f7ea-d14ef12e680aa00597bdffb57368cf92.r6.cf2.rackcdn.com/migration/blog/wp-content/uploads/2012/12/duck.jpg"
                               ],
                           @[
                               @"http://9dc3f407a257cfd3f7ea-d14ef12e680aa00597bdffb57368cf92.r6.cf2.rackcdn.com/gift-catalog/animals/honey-full.jpg",
                               @"http://9dc3f407a257cfd3f7ea-d14ef12e680aa00597bdffb57368cf92.r6.cf2.rackcdn.com/migration/blog/wp-content/uploads/2013/08/bees-in-guatemala-1024x731.jpg",
                               @"http://9dc3f407a257cfd3f7ea-d14ef12e680aa00597bdffb57368cf92.r6.cf2.rackcdn.com/migration/blog/wp-content/uploads/2012/12/boy_honey1.jpg",
                               @"http://9dc3f407a257cfd3f7ea-d14ef12e680aa00597bdffb57368cf92.r6.cf2.rackcdn.com/migration-drupal/images/ext/from_the_field/FelicianaMartin.jpg",
                               @"http://1.bp.blogspot.com/-43c8KX7kPWI/UsCi9nPlPEI/AAAAAAAABfQ/DDyF5lFryGQ/s1600/Bees.jpg",
                               @"http://3.bp.blogspot.com/-AmzY6e1XTfg/UgCecZmfSeI/AAAAAAAAFVs/YP9_LgSneFY/s1600/gc_bees.jpg",
                               @"http://imaginechildhood.typepad.com/.a/6a0120a765554d970b012876f163d9970c-pi"
                               ],
                           @[
                               @"http://food-fun.wisconsinfood.com/.a/6a00e54f0ac1a68834014e8a5aca91970d-320wi",
                               @"http://www.northwestmilitary.com/news/focus/2011/05/The-more-mail-a-happily-married-deployed-Soldier-gets-from-home-the-fewer/uploads/articles/14016-banner-thumbs_up_soldier.jpg",
                               @"http://www.justmilitaryloans.com/wp-content/uploads/2012/02/military-care-packages.jpg",
                               @"http://img64.imageshack.us/img64/1353/mwrsoldiersopencarepacks4rz3.jpg",
                               @"http://seaofsavings.com/wp-content/uploads/2011/06/Military-care-package.jpg",
                               @"http://www.magazinesfortroops.com/images/troop_mags.jpg"
                               ],
                           @[
                               @"http://www.spdfraktion.de/sites/default/files/imagecache/article_lb/Entwicklungspolitik_Brunnen_in_Afrika_Bilderbox_720x360.jpg",
                               @"http://www.aidforafrica.org/wp-content/uploads/2011/12/world-hope-international-well2.jpg",
                               @"http://www.bgland24.de/bilder/2012/03/19/2189117/1020672372-brunnen-afrika-kinder-wedic5ym034.jpg",
                               @"http://thewaterproject.org/images/sponsor-a-well-2.jpg",
                               @"http://ithirst.org/wp-content/uploads/2013/03/HappyKid_well.jpeg",
                               @"http://purpleisright.com/blog/wp-content/uploads/2012/11/african-well.jpg",
                               @"http://www.trbimg.com/img-51ff28ac/turbine/aan-a-quest-to-build-well-in-africa-central-gr-001/600/600x522",
                               @"https://www.dropinthebucket.org/wp-content/uploads/2012/05/IMG_4296.jpg",
                               @"https://www.dropinthebucket.org/wp-content/uploads/2012/03/IMG_3530-300x200.jpg",
                               @"http://www.ecorazzi.com/wp-content/uploads/2012/03/african-well.jpeg",
                               @"http://www.pbs.org/wnet/wideangle/previous_seasons/shows/botswana/images/photo9.jpg",
                               @"http://www.socialearth.org/wp-content/uploads/2009/07/ethiopia-charity-water.jpg",
                               @"http://www.mcac.ca/Portals/0/Graphics/Children_20water_20pump_20Tanz,property=Galeriebild__gross.jpg",
                               @"http://www.compassion-care.org/tororo-images/happy-new-well72009.jpg",
                               @"https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQ_Atv6KhCZ7t2gHnIRV7KxCr6g73zL205dklSI0bhrlIUlmWV_",
                               @"http://www.africanwellfund.org/blog/ghana/ghana-stories-3.jpg",
                               @"http://www.aidforafrica.org/wp-content/uploads/2011/12/world-hope-international-well2.jpg"
                               ]
                           ];
    NSMutableArray *specificCharityImagesArray = [[NSMutableArray alloc] initWithArray:[charityImagesArray objectAtIndex:specificCharity]];
    int randomNumber = arc4random() % (specificCharityImagesArray.count - 1);
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[specificCharityImagesArray objectAtIndex:randomNumber]]]];
    
    return image;
}

- (NSString *)charityDescriptionPlural:(NSUInteger)specificCharity
{
    NSArray *charityDescriptionPluralArray = [NSArray array];
    charityDescriptionPluralArray = @[@"animal meals through The Animal Rescue Site",
                                      @"months of vaccines, schooling & natural disaster relief through Unicef",
                                      @"months of food, water, and medical supplies through Feed The Children",
                                      @"flocks of ducklings per a 3rd world family through Heifer International",
                                      @"gifts of honey bees per a 3rd world family through Heifer International",
                                      @"military care packages through Soildier's Angels",
                                      @"spring catchments serving 250 people through African Well Fund"];
    return [charityDescriptionPluralArray objectAtIndex:specificCharity];
}

- (NSString *)charityDescriptionSingular:(NSUInteger)specificCharity
{
    NSArray *charityDescriptionSingularArray = [NSArray array];
    charityDescriptionSingularArray = @[@"animal meal through The Animal Rescue Site",
                                        @"month of vaccines, schooling & natural disaster relief through Unicef",
                                        @"month of food, water, and medical supplies through Feed The Children",
                                        @"flocks of ducklings per a 3rd world family through Heifer International",
                                        @"gifts of honey bees per a 3rd world family through Heifer International",
                                        @"military care packages through Soildier's Angels",
                                        @"spring catchment serving 250 people through African Well Fund"];
    return [charityDescriptionSingularArray objectAtIndex:specificCharity];
}
/*
 charityImagesArray = @[@"homeless dogs.png", @"feedTheHungry.png", @"homelessFamily.png",@"ducklingsFlock.png", @"honeybee.png", @"Soldiers.png", @"waterPump.png"];
 
 charityDiscriptionsArray = @[@"animal meals through The Animal Rescue Site",
 @"month(s) of vaccines, schooling & natural disaster relief through Unicef",
 @"month(s) of food, water, and medical supplies through Feed The Children",
 @"flock(s) of ducklings per a 3rd world family through Heifer International",
 @"gift(s) of honey bees per a 3rd world family through Heifer International",
 @"military care package(s) through Soildier's Angels",
 @"natural spring catchment(s) serving 250 people through African Well Fund"
 ];
 */

@end
