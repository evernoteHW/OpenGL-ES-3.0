//
//  Shader.hpp
//  Demo1
//
//  Created by WeiHu on 2018/3/22.
//  Copyright © 2018年 WeiHu. All rights reserved.
//

#ifndef Shader_hpp
#define Shader_hpp

#include <OpenGLES/ES3/gl.h>

#include <stdio.h>
#include <string>
#include <fstream>
#include <sstream>
#include <iostream>

class Shader {
public:
    Shader();
    Shader(const char *vertexPath, const char *fragmentPath);
    ~Shader();
private:
    GLuint ID;
    void checkCompileErrors(GLuint shader, std::string type);
};

#endif /* Shader_hpp */
