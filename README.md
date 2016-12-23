# AnimationGroup
## AnimationGroup · iOS · OC · AnimationGroup

<p align="left">
![enter image description here]
(https://img.shields.io/badge/iOS-Animation-brightgreen.svg) 
![enter image description here]
(https://img.shields.io/badge/license-MIT-green.svg?style=flat) 
</a>

在使用中有任何问题都可以提 issue, 欢迎加入QQ群:475814382

------------------------------------------------------------------------------------------------

### SMEmitter演示
![image](https://github.com/icoderRo/SMAnimationDemo/blob/master/Resource/emitterViewAnimation/emitterView.gif)![image](https://github.com/icoderRo/SMAnimationDemo/blob/master/Resource/emitterViewAnimation/emitterViewbg.gif)![image](https://github.com/icoderRo/SMAnimationDemo/blob/master/Resource/emitterViewAnimation/emitterView.png)

#### SMEmitterView Usage
``` Objc
// 1.create
SMEmitterView *emitterView = [[SMEmitterView alloc] init];
emitterView.frame = CGRectMake(10, 120, width, 400);
[self.view addSubview:emitterView];

// 2. open fire 
[emitterView fireWithEmitterCount:100];
```
