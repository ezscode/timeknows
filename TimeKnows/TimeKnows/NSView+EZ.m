//
//  NSView+EZ.m
//  TimeKnows
//
//  Created by luyi on 2023/7/14.
//

#import "NSView+EZ.h"

@implementation NSColor (EZ)

+ (NSColor *)colorWithHexString:(NSString *)stringToConvert {
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
//    NSColor *color = [NSColor colorWithRGBHex:hexNum];
    
    return [NSColor colorWithRGBHex:hexNum];
}


+ (NSColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    return [NSColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:1];
}


- (NSColor *)lightenColorByValue:(float)value {
    float red = [self redComponent];
    red += value;
    
    float green = [self greenComponent];
    green += value;
    
    float blue = [self blueComponent];
    blue += value;
    
    return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0f];
}

- (NSColor *)darkenColorByValue:(float)value {
    float red = [self redComponent];
    red -= value;
    
    float green = [self greenComponent];
    green -= value;
    
    float blue = [self blueComponent];
    blue -= value;
    
    return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0f];
}

@end


@implementation NSButton (EZ)

- (void)ezCommonSetting{
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor clearColor].CGColor;
    
//    [self msSetLayerColor:[NSColor clearColor]];
    [self setBezelStyle:NSBezelStyleRoundRect];
    self.bordered = NO;
    self.imagePosition = NSImageLeft;
    [self setFocusRingType:NSFocusRingTypeNone];
    
}


@end

@implementation NSView (EZ)

- (void)ezSetLayerColor:(NSColor *)layerColor{
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = layerColor.CGColor;
    
}


- (void)ezSetCornerRadius:(CGFloat)cornerRadius{
    self.wantsLayer = YES;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}


- (void)ezSetLayerLineWith:(CGFloat)lineWith
                 lineColor:(NSColor *)lineColor
              cornerRadius:(CGFloat)cornerRadius{
    
    self.wantsLayer = YES;
 
    self.layer.borderWidth = lineWith;
    self.layer.borderColor = lineColor.CGColor;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}




@end


@implementation NSScrollView (EZ)

- (void)ezCommonStyle{
    
    self.scrollsDynamically = YES;
    self.hasHorizontalScroller = NO;
    self.hasVerticalScroller = NO;
    
    self.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.autohidesScrollers = YES;//自动隐藏滚动条（滚动的时候出现）
    
    [self setDrawsBackground:NO];//不画背景（背景默认画成白色）
    
    [self ezSetLayerColor:[NSColor whiteColor]];
}

@end

@implementation NSTextField (EZ)

- (void)ezInputStyle{
    self.bordered = NO;
    self.editable = YES;
    self.font = [NSFont systemFontOfSize:14];
    self.textColor = kColor_TextBlack;
    
    [self setFocusRingType:NSFocusRingTypeNone];
}

- (void)ezLabelStyle2{
    
    self.editable = NO;
    self.bordered = NO;
    self.font = [NSFont systemFontOfSize:14];
    self.textColor = kColor_TextBlack;
    
    self.backgroundColor = [NSColor clearColor];
}


- (void)ezLabelStyle{
    
    self.editable = NO;
    self.bordered = NO;
    self.backgroundColor = [NSColor clearColor];
//    self.font = [NSFont systemFontOfSize:14];
//    self.textColor = kColor_TextBlack;
}

- (void)ezWebWindowTitleStyle{
    
    [self ezLabelStyle];
    
    self.font = [NSFont systemFontOfSize:14];
    self.textColor = kColor_DarkGray;
}

- (void)ezDescLabelStyle{
    
    [self ezLabelStyle];
    
    self.font = [NSFont systemFontOfSize:12];
//    self.textColor = kColor_TextGray;
    
}

- (void)ezTitleLabelStyle{
    
    [self ezLabelStyle];
    
    self.font = [NSFont systemFontOfSize:16];
    self.textColor = kColor_TextBlack;
    
}

// kFontNamePingFangSC_Regular

- (void)ezSetPlaceholder:(NSString *)placeholder color:(NSColor*)color{
    
    
//    if(color ==nil) {
//        color = RGB(190, 190, 225);
//    }
//    NSFont *font = [NSFont fontWithName:kFontNamePingFangSC_Regular size:14];
    NSFont *font = [NSFont systemFontOfSize:14];
    
    NSMutableParagraphStyle *centredStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [centredStyle setAlignment:NSCenterTextAlignment];
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:                   centredStyle,NSParagraphStyleAttributeName,
                           font, NSFontAttributeName,
                           color, NSForegroundColorAttributeName, nil];
    
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:placeholder attributes:attrs];
    [self setPlaceholderAttributedString:attributedString];
    
}





@end

