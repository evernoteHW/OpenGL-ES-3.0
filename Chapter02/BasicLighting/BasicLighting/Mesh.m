//
//  Mesh.m
//  BasicLighting
//
//  Created by WeiHu on 2018/3/30.
//  Copyright © 2018年 WeiHu. All rights reserved.
//

#import "Mesh.h"
#import <OpenGLES/ES3/gl.h>
//#import <OpenGLES/ES1/gl.h>

#import "Shader.h"

@interface Mesh() {
    unsigned int VAO;
    unsigned int VBO, EBO;
}
@end

@implementation Mesh

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupMesh];
    }
    return self;
}
- (void)draw:(Shader *)shader
{
    // bind appropriate textures
//    unsigned int diffuseNr  = 1;
//    unsigned int specularNr = 1;
//    unsigned int normalNr   = 1;
//    unsigned int heightNr   = 1;
    for(unsigned int i = 0; i < _textures.count; i++)
    {
        glActiveTexture(GL_TEXTURE0 + i); // active proper texture unit before binding
//        // retrieve texture number (the N in diffuse_textureN)
//        stringstream ss;
//        string number;
//        _textures[i]
//        string name = textures[i].type;
//        if(name == "texture_diffuse"){
//            ss << diffuseNr++; // transfer unsigned int to stream
//        }
//        else if(name == "texture_specular"){
//            ss << specularNr++; // transfer unsigned int to stream
//        } else if(name == "texture_normal"){
//            ss << normalNr++; // transfer unsigned int to stream
//        }else if(name == "texture_height"){
//            ss << heightNr++; // transfer unsigned int to stream
//        }
//        number = ss.str();
//        // now set the sampler to the correct texture unit
//        glUniform1i(glGetUniformLocation(shader.ID, (name + number).c_str()), i);
//        // and finally bind the texture
//        glBindTexture(GL_TEXTURE_2D, textures[i].id);
    }
    
    // draw mesh
    glBindVertexArray(VAO);
    glDrawElements(GL_TRIANGLES, (GLsizei)_indices.count, GL_UNSIGNED_INT, 0);
    glBindVertexArray(0);
    
    // always good practice to set everything back to defaults once configured.
    glActiveTexture(GL_TEXTURE0);
}
- (void)setupMesh{
    // create buffers/arrays
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    glGenBuffers(1, &EBO);
    
    glBindVertexArray(VAO);
    // load data into vertex buffers
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    // A great thing about structs is that their memory layout is sequential for all its items.
    // The effect is that we can simply pass a pointer to the struct and it translates perfectly to a glm::vec3/2 array which
    // again translates to 3/2 floats which translates to a byte array.
    glBufferData(GL_ARRAY_BUFFER, _vertices.count * sizeof(Vertex_Struct), (__bridge const GLvoid *)(_vertices.firstObject), GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, _vertices.count * sizeof(unsigned int), (__bridge const GLvoid *)(_indices.firstObject), GL_STATIC_DRAW);
    
    // set the vertex attribute pointers
    // vertex Positions
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex_Struct), (void*)0);
    // vertex normals
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex_Struct), (void*)offsetof(Vertex_Struct, Normal));
    // vertex texture coords
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex_Struct), (void*)offsetof(Vertex_Struct, TexCoords));
    // vertex tangent
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex_Struct), (void*)offsetof(Vertex_Struct, Tangent));
    // vertex bitangent
    glEnableVertexAttribArray(4);
    glVertexAttribPointer(4, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex_Struct), (void*)offsetof(Vertex_Struct, Bitangent));
    
    glBindVertexArray(0);
}
@end
