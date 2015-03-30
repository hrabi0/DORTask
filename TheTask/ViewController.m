//
//  ViewController.m
//  TheTask
//
//  Created by Bartek Kozłowski on 28/03/15.
//  Copyright (c) 2015 Bartosz Kozlowski. All rights reserved.
//

#import "ViewController.h"
#import "StyleManager.h"
#import "StyleObject.h"
#import "StyleEntity.h"
#import "Utils.h"
#import "RBBCustomAnimation.h"
#import "RBBSpringAnimation.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define TRANSITION_DURATION 0.5f

@interface ViewController () {
    int currentStyleIndex;
}

@property IBOutlet UIImageView *imageView;
@property IBOutlet UISlider *slider;
@property IBOutlet UIButton *button;

@property (strong) NSArray *stylesArray;
@property (weak) StyleObject *currentStyle;

@end

@implementation ViewController


#pragma mark - view lifecycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadStyles];
    [StyleManager updateStyles:(^{
        [self reloadStyles];
    })];
}



#pragma mark - actions -

- (IBAction)nextStyle:(id)sender {
    [self loadNextStyle];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    [self updateImageRotation:sender.value];
}


#pragma mark - view data and properties -

- (void) loadStylePropertiesToTheView:(StyleObject*)style {
    self.currentStyle = style;
    style.delegate = self;
    [self loadImageForCurrentStyle];
    [self loadPropertiesForCurrentStyle];
}

- (void) loadImageForCurrentStyle {
    self.imageView.image = [self.currentStyle getImageAndDownloadIfNotPresent];
}

- (void) loadPropertiesForCurrentStyle {
    StyleEntity *styleEntity = self.currentStyle.styleEntity;
    
    
    //[self animateButtonColorTo:[Utils colorFromHexString:styleEntity.buttonColor]];
    [self animateValue:@"backgroundColor"
              ofAnView:self.button
             fromColor:self.button.backgroundColor
               toColor:[Utils colorFromHexString:styleEntity.buttonColor]];
    
    self.button.backgroundColor = [Utils colorFromHexString:styleEntity.buttonColor];
    
    self.button.layer.cornerRadius = styleEntity.buttonCornerRadius.floatValue;
    [self.button setTitle:styleEntity.buttonTitle forState:UIControlStateNormal];
    self.button.frame = [self viewFrameCentered:self.button
                                       forWidth:styleEntity.buttonWidth.floatValue
                                      andHeight:styleEntity.buttonHeight.floatValue];
    
    self.imageView.layer.cornerRadius = styleEntity.imageCornerRadius.floatValue;
    self.imageView.layer.borderWidth = styleEntity.imageBorderWidth.floatValue;
    
    [self animateValue:@"borderColor"
              ofAnView:self.imageView
             fromColor:[UIColor colorWithCGColor:self.imageView.layer.borderColor]
               toColor:[Utils colorFromHexString:styleEntity.imageBorderColor]];
    self.imageView.layer.borderColor =  [[Utils colorFromHexString:styleEntity.imageBorderColor] CGColor];
    [self updateImageRotation:0];
    self.imageView.frame = [self viewFrameCentered:self.imageView
                                          forWidth:styleEntity.imageWidth.floatValue
                                         andHeight:styleEntity.imageHeight.floatValue];
    
    
    [self.slider setValue:styleEntity.imageRotation.floatValue animated:YES];
    [self updateImageRotation:self.slider.value];
    [self animateImageDrop];
}


- (void) updateImageRotation:(CGFloat)value {
    double imageRotationRadians = DEGREES_TO_RADIANS(value);
    self.imageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, imageRotationRadians);
}

    
- (CGRect) viewFrameCentered:(UIView*)view forWidth:(CGFloat)width andHeight:(CGFloat)height {
    CGRect frame = view.frame;
    
    CGFloat offsetX = (frame.size.width - width ) / 2;
    frame.origin.x += offsetX;
    frame.size.width = width;
    
    CGFloat offsetY = (frame.size.height - height ) / 2;
    frame.origin.y += offsetY;
    frame.size.height = height;
    
    return frame;
}


#pragma mark - styles logic -

- (void)loadNextStyle {
    [self updateStyleCounter];
    [self loadCurrentStyleData];
}

- (void) reloadStyles {
    self.stylesArray = [StyleManager getStylesArray];
    [self loadCurrentStyleData];
}

- (void) loadCurrentStyleData {
    StyleObject *styleObject = [self getCurrentStyle];
    if (styleObject == nil) {
        [self noStylesCase];
    }
    else {
        [self loadStylePropertiesToTheView:styleObject];
    }
}

- (StyleObject*) getCurrentStyle {
    if (self.stylesArray == nil || self.stylesArray.count == 0) {
        return nil;
    }
    [self checkWrapStyleIndex];
    return [self.stylesArray objectAtIndex:currentStyleIndex];
}

- (void) updateStyleCounter {
    currentStyleIndex++;
    [self checkWrapStyleIndex];
}

- (void)checkWrapStyleIndex {
    if (currentStyleIndex >= self.stylesArray.count) {
        currentStyleIndex = 0;
    }
}

- (void) noStylesCase {
    NSLog(@"NO STYLES");
}

- (void) imageDidLoadForStyleObjectIndex:(int)styleIndex {
    if (self.currentStyle.styleEntity.styleIndex.integerValue == styleIndex) {
        [self loadImageForCurrentStyle];
    }
}

#pragma mark - custom animations -

- (void) animateValue:(NSString*)keyPath ofAnView:(UIView*)object fromColor:(UIColor*)startColor toColor:(UIColor*)targetColor {
    RBBCustomAnimation *colorAnimation = [RBBCustomAnimation animationWithKeyPath:keyPath];
    colorAnimation.animationBlock = ^(CGFloat elapsed, CGFloat duration) {
        CGFloat percent = elapsed/duration;
        UIColor *currentColor = [Utils transColorFrom:startColor to:targetColor progress:percent];
        return (id)currentColor.CGColor;
    };
    colorAnimation.duration = TRANSITION_DURATION;
    [object.layer addAnimation:colorAnimation forKey:@"colorAnimation"];
}

- (void) animateImageDrop {
    RBBSpringAnimation *spring = [RBBSpringAnimation animationWithKeyPath:@"position.y"];
    
    spring.fromValue = @(-200.0f);
    spring.toValue = @(0.0f);
    spring.velocity = 0;
    spring.mass = 1;
    spring.damping = 8;
    spring.stiffness = 200;
    
    spring.additive = YES;
    spring.duration = [spring durationForEpsilon:0.01];
    
    [self.imageView.layer addAnimation:spring forKey:@"spring"];
}


@end
