//
//  TTSAttchmentNode.h
//  TTLoveCar
//
//  Created by Gary on 22/01/2018.
//  Copyright © 2018 王洋. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>



@interface TTSAttchmentNode : ASTextNode

- (void)setImages:(NSArray<NSString *> *)paths text:(NSString *)text textAttrDic:(NSDictionary*)attrDic;

@end
