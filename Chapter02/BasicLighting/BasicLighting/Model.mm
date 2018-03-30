//
//  Model.m
//  BasicLighting
//
//  Created by WeiHu on 2018/3/30.
//  Copyright © 2018年 WeiHu. All rights reserved.
//

#import "Model.h"
#import "Mesh.h"
#import <assimp/Importer.hpp>

@interface Model() {
    
}
@end

@implementation Model

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)loadModel:(NSString *)path
{
    // read file via ASSIMP
    Assimp::Importer i;
    
//    Assimp::Importer importer;
//    const aiScene* scene = importer.ReadFile(path, aiProcess_Triangulate | aiProcess_FlipUVs | aiProcess_CalcTangentSpace);
//    // check for errors
//    if(!scene || scene->mFlags & AI_SCENE_FLAGS_INCOMPLETE || !scene->mRootNode) // if is Not Zero
//    {
//        cout << "ERROR::ASSIMP:: " << importer.GetErrorString() << endl;
//        return;
//    }
//    // retrieve the directory path of the filepath
//    directory = path.substr(0, path.find_last_of('/'));
//
//    // process ASSIMP's root node recursively
//    processNode(scene->mRootNode, scene);
}
@end
