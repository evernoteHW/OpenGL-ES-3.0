//
//  Shader.h
//  HelloTriangle
//
//  Created by WeiHu on 2018/3/26.
//  Copyright © 2018年 WeiHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Shader : NSObject
- (void)use;
- (void)glUniform1i:(const GLchar *)name value:(GLfloat)value;
- (void)setUniform4f:(const GLchar *)name value:(GLKVector4)value;

- (instancetype)initVSShader:(NSString *)vsShader fsShader:(NSString *)fsShader;
@end
