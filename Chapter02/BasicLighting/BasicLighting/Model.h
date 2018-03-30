//
//  Model.h
//  BasicLighting
//
//  Created by WeiHu on 2018/3/30.
//  Copyright © 2018年 WeiHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property (nonatomic, strong) NSMutableArray *textures_loaded;
@property (nonatomic, strong) NSMutableArray *meshes;
@property (nonatomic, copy) NSString *directory;
@property (nonatomic, assign) BOOL gammaCorrection;

@end
