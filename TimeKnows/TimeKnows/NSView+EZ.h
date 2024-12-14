//
//  NSView+EZ.h
//  TimeKnows
//
//  Created by luyi on 2023/7/14.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

#define kColor_TextBlack [NSColor colorWithHexString:@"4a4a4a"]  //普通黑色文本

#define kColor_DarkGray [NSColor colorWithHexString:@"666666"]//

@interface NSColor (EZ)

- (NSColor *)lightenColorByValue:(float)value;
- (NSColor *)darkenColorByValue:(float)value;

+ (NSColor *)colorWithHexString:(NSString *)stringToConvert;
@end

@interface NSView (EZ)

- (void)ezSetLayerColor:(NSColor *)layerColor;
- (void)ezSetCornerRadius:(CGFloat)cornerRadius;
- (void)ezSetLayerLineWith:(CGFloat)lineWith
                 lineColor:(NSColor *)lineColor
              cornerRadius:(CGFloat)cornerRadius;


@end

@interface NSScrollView (EZ)

- (void)ezCommonStyle;

@end


@interface NSTextField (EZ)

- (void)ezInputStyle;
- (void)ezLabelStyle;

- (void)ezDescLabelStyle;
- (void)ezTitleLabelStyle;

- (void)ezWebWindowTitleStyle;

- (void)ezSetPlaceholder:(NSString *)placeholder color:(NSColor*)color;
@end


@interface NSButton (EZ)


- (void)ezCommonSetting;

@end


NS_ASSUME_NONNULL_END
