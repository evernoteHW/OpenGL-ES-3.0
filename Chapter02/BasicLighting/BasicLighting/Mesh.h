//
//  Mesh.h
//  BasicLighting
//
//  Created by WeiHu on 2018/3/30.
//  Copyright © 2018年 WeiHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
//#import <assimp/types.h>

typedef struct Vertex {
    // position
    GLKVector3 Position;
    // normal
    GLKVector3 Normal;
    // texCoords
    GLKVector3 TexCoords;
    // tangent
    GLKVector3 Tangent;
    // bitangent
    GLKVector3 Bitangent;
} Vertex_Struct;

typedef struct Texture {
    GLuint id;
    const char *type;
//    struct aiString path;
} Texture_Struct;

@interface Mesh : NSObject
@property (nonatomic, strong) NSMutableArray *vertices;
@property (nonatomic, strong) NSMutableArray *indices;
@property (nonatomic, strong) NSMutableArray *textures;
@end
