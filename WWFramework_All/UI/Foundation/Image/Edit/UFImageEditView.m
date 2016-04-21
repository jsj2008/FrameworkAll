//
//  UFImageEditView.m
//  Test
//
//  Created by ww on 16/3/11.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFImageEditView.h"

/*
 这里使用手势处理图片的移动和缩放操作，没有使用scroll view，是因为后者无法实现将图片的滚动区域限定在遮罩范围内
 */

@interface UFImageEditView ()

@property (nonatomic) UIImageView *imageView;

@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic) UIPinchGestureRecognizer *pinchGestureRecognizer;

- (void)handlePanGestureRecognizer:(UIGestureRecognizer *)recognizer;

- (void)handlePinchGestureRecognizer:(UIGestureRecognizer *)recognizer;

- (void)adjustImageViewToAvailableFrame;

@end


@implementation UFImageEditView

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    if (image)
    {
        [self.imageView removeFromSuperview];
        
        self.imageView = [[UIImageView alloc] initWithImage:image];
        
        self.imageView.bounds = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
        
        [self addSubview:self.imageView];
        
        __weak typeof(self) weakSelf = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.imageView.center = CGPointMake(weakSelf.frame.size.width / 2, weakSelf.frame.size.height / 2);
        });
    }
    else
    {
        [self.imageView removeFromSuperview];
        
        self.imageView = nil;
    }
}

- (void)setMaskView:(UFImageEditMaskView *)maskView
{
    [_maskView removeFromSuperview];
    
    _maskView = maskView;
    
    [self addSubview:_maskView];
}

- (void)setEnableEdit:(BOOL)enableEdit
{
    _enableEdit = enableEdit;
    
    if (enableEdit)
    {
        if (!self.panGestureRecognizer)
        {
            self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
            
            [self addGestureRecognizer:self.panGestureRecognizer];
        }
        
        if (!self.pinchGestureRecognizer)
        {
            self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGestureRecognizer:)];
            
            [self addGestureRecognizer:self.pinchGestureRecognizer];
        }
    }
    else
    {
        self.panGestureRecognizer = nil;
        
        self.pinchGestureRecognizer = nil;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.maskView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)handlePanGestureRecognizer:(UIGestureRecognizer *)recognizer
{
    if ([recognizer isEqual:self.panGestureRecognizer] && (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged))
    {
        CGPoint translation = [self.panGestureRecognizer translationInView:self];
        
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x + translation.x, self.imageView.frame.origin.y + translation.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
        
        [self.panGestureRecognizer setTranslation:CGPointZero inView:self];
        
        [self adjustImageViewToAvailableFrame];
    }
}

- (void)handlePinchGestureRecognizer:(UIGestureRecognizer *)recognizer
{
    if ([recognizer isEqual:self.pinchGestureRecognizer] && (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged))
    {
        self.imageView.transform = CGAffineTransformScale(self.imageView.transform, self.pinchGestureRecognizer.scale, self.pinchGestureRecognizer.scale);
        
        self.pinchGestureRecognizer.scale = 1;
        
        [self adjustImageViewToAvailableFrame];
    }
}

- (void)adjustImageViewToAvailableFrame
{
    CGPoint origin = self.imageView.frame.origin;
    
    CGSize size = self.imageView.frame.size;
    
    CGRect editableRect = self.maskView ? [self.maskView editableRect] : CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    if (size.width > editableRect.size.width)
    {
        if (origin.x > editableRect.origin.x)
        {
            origin.x = editableRect.origin.x;
        }
        else if (origin.x + size.width < editableRect.origin.x + editableRect.size.width)
        {
            origin.x = editableRect.origin.x + editableRect.size.width - size.width;
        }
    }
    else
    {
        if (origin.x < editableRect.origin.x)
        {
            origin.x = editableRect.origin.x;
        }
        else if (origin.x + size.width > editableRect.origin.x +  editableRect.size.width)
        {
            origin.x = editableRect.origin.x +  editableRect.size.width - size.width;
        }
    }
    
    if (size.height > editableRect.size.height)
    {
        if (origin.y > editableRect.origin.y)
        {
            origin.y = editableRect.origin.y;
        }
        else if (origin.y + size.height < editableRect.origin.y + editableRect.size.height)
        {
            origin.y = editableRect.origin.y + editableRect.size.height - size.height;
        }
    }
    else
    {
        if (origin.y < editableRect.origin.y)
        {
            origin.y = editableRect.origin.y;
        }
        else if (origin.y + size.height > editableRect.origin.y + editableRect.size.height)
        {
            origin.y = editableRect.origin.y + editableRect.size.height - size.height;
        }
    }
    
    self.imageView.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
}

- (UIImage *)currentEditedImage
{
    CGRect imageFrame = self.imageView.frame;
    
    CGRect editableRect = self.maskView ? [self.maskView editableRect] : CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    CGFloat leftScale = 0;
    
    CGFloat rightScale = 0;
    
    CGFloat topScale = 0;
    
    CGFloat bottomScale = 0;
    
    if (imageFrame.origin.x < editableRect.origin.x)
    {
        leftScale = (editableRect.origin.x - imageFrame.origin.x) / imageFrame.size.width;
    }
    else
    {
        leftScale = 0;
    }
    
    if (imageFrame.origin.x + imageFrame.size.width > editableRect.size.width)
    {
        rightScale = (imageFrame.origin.x + imageFrame.size.width - editableRect.size.width) / imageFrame.size.width;
    }
    else
    {
        rightScale = 0;
    }
    
    if (imageFrame.origin.y < editableRect.origin.y)
    {
        topScale = (editableRect.origin.y - imageFrame.origin.y) / imageFrame.size.height;
    }
    else
    {
        topScale = 0;
    }
    
    if (imageFrame.origin.y + imageFrame.size.height > editableRect.origin.y + editableRect.size.height)
    {
        bottomScale = (imageFrame.origin.y + imageFrame.size.height - (editableRect.origin.y + editableRect.size.height)) / imageFrame.size.height;
    }
    else
    {
        bottomScale = 0;
    }
    
    CGRect imageRect = CGRectMake(self.image.size.width * self.image.scale * leftScale, self.image.size.height * self.image.scale * topScale, self.image.size.width * self.image.scale * (1 - leftScale - rightScale), self.image.size.height * self.image.scale * (1 - topScale - bottomScale));
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.image.CGImage, imageRect);
    
    return [UIImage imageWithCGImage:imageRef];
}

@end
