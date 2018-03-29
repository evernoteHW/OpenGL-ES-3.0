//
//  CustomGLKView.m
//  Textures
//
//  Created by WeiHu on 2018/3/27.
//  Copyright © 2018年 WeiHu. All rights reserved.
//

#import "CustomGLKView.h"

@interface CustomGLKView ()
{
    CGFloat move_orign;
}
@end

@implementation CustomGLKView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    move_orign = point.x;
    
//    NSLog(@"开始===%f", move_orign);
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"2222");
//    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    UITouch *touch = touches.anyObject;
//    CGPoint point = [touch locationInView:self];
//    _move_x = (point.x - move_orign)/self.frame.size.width;
//    
//    [self setNeedsDisplay];
    
}
@end
