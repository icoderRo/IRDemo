
## Demo

--------------

<p align="left">
![enter image description here]
(https://img.shields.io/badge/iOS-Animation-brightgreen.svg) 
![enter image description here]
(https://img.shields.io/badge/license-MIT-green.svg?style=flat) 
</a>

在使用中有任何问题都可以提 issue, 欢迎加入QQ群:475814382

--------------
### SMEmitterView
![image](https://github.com/icoderRo/SMAnimationDemo/blob/master/Resource/emitterViewAnimation/emitterView.gif) ![image](https://github.com/icoderRo/SMAnimationDemo/blob/master/Resource/emitterViewAnimation/emitterViewbg.gif)

#### SMEmitterView Usage
``` Objc
// 1.基本创建
SMEmitterView *emitterView = [[SMEmitterView alloc] init];
emitterView.frame = CGRectMake(10, 120, width, 400);
[self.view addSubview:emitterView];

// 2.可以设置 粒子大小和发射源位置
emitterView.emitterSize = CGSizeMake(36, 36);
emitterView.positionType = SMEmitterPositionLeft;

// 3.可以设置粒子, 默认为绘制心形
emitterView.images = images;

// 4.开始, 暂停, 恢复, 停止 
[self.emitterView fireWithEmitterCount:100];
[self.emitterView resume];
[self.emitterView pause];
[self.emitterView stop];

// 6.可以监听view的点击
emitterView.delegate = self;
- (void)emitterView:(SMEmitterView *)emitterView didAddEmitterCount:(NSUInteger)emitterCount {
    NSLog(@"%zd", emitterCount);
}
```
--

### SMEmitterButton
![image](https://github.com/icoderRo/SMAnimationDemo/blob/master/Resource/emitterViewAnimation/emitterView1.gif)

#### SMEmitterButton Usage
```Objc
// 1.创建
SMEmitterButton *btn = [[SMEmitterButton alloc] initWithEffectType:SMEffectType frame:CGRectMake(30, 550, 46, 46)];

// 2.1 使用SMEffectEmitter效果, 传入图片数组
btn.emitters = @[[UIImage imageWithContentsOfFile:path(@"emitter", @"bundle", @"Sparkle2")]];
 
// 2.2 使用SMEffectWare效果, 设置wareType(SMWareLayerCircle,SMWareLayerHeart)类型和颜色
btn.wareType = SMWareLayerHeart;
btn.wareColor = [UIColor redColor];

 .
 .
 .
```
##### 后续会新增各类型的动画, 有需要的小伙伴可以持续关注.

##### LICENSE - "MIT License"

##### 赶项目, 对于弹幕的封装会慢一点完成
