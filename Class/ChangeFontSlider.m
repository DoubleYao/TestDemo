//
//  ChangeFontSlider.m
//  SunshineNews
//
//  Created by yaoyao on 2018/4/2.
//  Copyright © 2018年 yaoyao. All rights reserved.
//

#import "ChangeFontSlider.h"
@interface ChangeFontSlider (){
    CGFloat lineWidth;
    CGFloat spaceWidth;
    NSInteger count;
    CGFloat perWidth;
}
@property(nonatomic, strong)NSArray *titleArray;
@property(nonatomic, strong)NSMutableArray<UILabel *> *labels;
@property(nonatomic, strong)UIImageView *imgView;
@property(nonatomic, assign)NSInteger selectedIndex;
@property(nonatomic, assign)CGPoint beginPoint;
@end

@implementation ChangeFontSlider

- (instancetype)initWithFrame:(CGRect)frame textArray:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArray = titles;
        lineWidth = 1.;
        spaceWidth = 36;
        count = self.titleArray.count;
        perWidth = (frame.size.width-2*spaceWidth-count*lineWidth)/(count - 1);
        self.selectedIndex = 0;
        self.labels = [NSMutableArray array];
        for (int i = 0; i<titles.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/2+1, 60, frame.size.height/2-1)];
            label.center = CGPointMake((perWidth+lineWidth)*i+spaceWidth, label.center.y)  ;
            label.textColor = [UIColor blackColor];
            label.text = titles[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:17+i*2];
            [self addSubview:label];
            [self.labels addObject:label];
            label.alpha = 0.;
            if (i == self.selectedIndex) {
                label.alpha = 1;
            }
        }
        [self addSubview:self.imgView];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBStrokeColor(context, 102/255., 102/255., 102/255., 1.0);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, spaceWidth, rect.size.height/2);
    CGContextAddLineToPoint(context, rect.size.width-spaceWidth-1, rect.size.height/2);
    for (int i = 0; i < count; i++) {
        CGContextMoveToPoint(context, (perWidth+lineWidth)*i+spaceWidth, rect.size.height/2);
        CGContextAddLineToPoint(context, (perWidth+lineWidth)*i+spaceWidth, rect.size.height/2-10);
    }
    
    CGContextStrokePath(context);
    CGContextEndPage(context);
    
}


- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _imgView.frame = CGRectMake(0, 0, 26, 26);
        _imgView.backgroundColor = [UIColor redColor];
        _imgView.layer.cornerRadius = 13;
        _imgView.layer.masksToBounds = YES;
        _imgView.contentMode = UIViewContentModeCenter;
        _imgView.center = CGPointMake(spaceWidth, self.frame.size.height/2);
    }
    return _imgView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches.count > 1) {
        return;
    }
    CGPoint pt = [[touches anyObject] locationInView:self];
    [self beginWithPoint:pt];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches.count > 1) {
        return;
    }
    CGPoint pt = [[touches anyObject] locationInView:self];
    [self endWithPoint:pt];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches.count > 1) {
        return;
    }
    CGPoint pt = [[touches anyObject] locationInView:self];
    [self moveWithPoint:pt];
}

- (void)beginWithPoint:(CGPoint)pt {
    self.beginPoint = pt;
    if (CGRectContainsPoint(self.imgView.frame, pt)) {
        self.imgView.center = CGPointMake(pt.x, self.imgView.center.y);
    }
}

//计算两点之间距离
- (float)distanceFromPointX:(CGPoint)start distanceToPointY:(CGPoint)end{
    
    float distance;
    
    CGFloat xDist = (end.x - start.x);
    
    CGFloat yDist = (end.y - start.y);
    
    distance = sqrt((xDist * xDist) + (yDist * yDist));
    
    return distance;
    
}
- (void)endWithPoint:(CGPoint)pt {
    if ([self distanceFromPointX:self.beginPoint distanceToPointY:pt]<10) { //处理点击事件
        NSInteger c = ((int)(pt.x - spaceWidth))/((int)(perWidth+lineWidth));
        NSInteger n = ((int)(pt.x - spaceWidth))%((int)(perWidth+lineWidth));
        if (n>perWidth/2) {
            c++;
        }
        if (c>count-1) {
            c = count-1;
        }
        if (self.selectedIndex == c) { //说明最后停住的位置没变 有一个动画
            [UIView animateWithDuration:0.2 animations:^{
                self.imgView.center = CGPointMake(pt.x, self.imgView.center.y);
            } completion:^(BOOL finished) {
                
                [self changeLocal];
            }];
        }else { //位置变了 直接走到选中位置
            self.selectedIndex = c;
            [self changeLocal];
        }
       
        return;
    }else if (!CGRectContainsPoint(self.imgView.frame, pt)){
        return;
    }
    //拖动结束
    NSInteger c = ((int)(pt.x - spaceWidth))/((int)(perWidth+lineWidth));
    NSInteger n = ((int)(pt.x - spaceWidth))%((int)(perWidth+lineWidth));
    if (n>perWidth/2) {
        c++;
    }
    if (c>count-1) {
        c = count-1;
    }
    
    self.selectedIndex = c;
    [self changeLocal];
    
}
- (void)moveWithPoint:(CGPoint)pt {
    if (CGRectContainsPoint(self.imgView.frame, pt)) {
        self.imgView.center = CGPointMake(pt.x, self.imgView.center.y);
        NSInteger c = ((int)(pt.x - spaceWidth))/((int)(perWidth+lineWidth));
        NSInteger n = ((int)(pt.x - spaceWidth))%((int)(perWidth+lineWidth));
        
        self.labels[c].alpha = 1.-n*1.0/((CGFloat)(perWidth+lineWidth));
        if (self.labels.count>c+1) {
            self.labels[c+1].alpha = n*1.0/((CGFloat)(perWidth+lineWidth));
        }
        
    }else {
        [self changeLocal];
    }
    
}

- (void)changeLocal {
    for (NSInteger i = 0; i < self.labels.count; i ++) {
        if (i == self.selectedIndex) {
            self.labels[i].alpha = 1;
            
        }else {
            self.labels[i].alpha = 0;
        }
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.imgView.center = CGPointMake(spaceWidth+(lineWidth+perWidth)*self.selectedIndex, self.frame.size.height/2);
    }];
    
    if (self.selectedBlock) {
        self.selectedBlock(self.selectedIndex);
    }
}
@end
