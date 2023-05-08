### 1. beacon optimization

见代码：test_so2/test_beacon.m

首先生成几个真值的landmark点(5个)

<img src="/home/junwangcas/Documents/working/typora_imgs/2023/se2_test/image-20230316204714647.png" alt="image-20230316204714647" style="zoom: 50%;" />

然后生成一个固定的pose, 通过一个角度，就可以生成一个SO2:  
$$
\mathbb{R}^1 = [\theta]^T -> so(2)=[\theta]_{\times}-> SO(2)= R
$$
然后给他一个初始值：

![image-20230506174033916](/home/junwangcas/Documents/working/typora_imgs/2023/so2_test/image-20230506174033916.png)

后面fix住pose，然后对beacon进行优化：

![image-20230506174115907](/home/junwangcas/Documents/working/typora_imgs/2023/so2_test/image-20230506174115907.png)

目标函数是：

$$f = M_G^L*p - y = {M_L^G}^{-1}*p - y$$

其中p是这些landmark点，y是观测。因为这个M = SO(2)是固定量。令: $$M = {M_L^G}^{-1}$$, 那么$$f = M * p - y$$，这个f是一个2*1的矩阵，变量$$p\in \mathbb{R}^2$$, 那么雅克比应该是$$J \in \mathbb{R}^{2\times 2}$$, 那么有如下形式

$$J = \frac{\delta f}{\delta p} = \frac{M(p+\delta p) -y - (M*p - y )}{\delta p} = \frac{M * \delta p}{\delta p} = R$$



### 2. Test Fix Pose

第一节中主要是把pose当成了常数，这里把pose当成变量，并将其固定住。脚本manif/matlab/test_so2/test_fix_pose.m

manif/matlab/test_so2/test_fix_pose2.m

假设要pose要固定的值如左图，初始值如中图，最终优化的值如右图：

![image-20230508114115000](/home/junwangcas/Documents/working/typora_imgs/2023/so2_test/image-20230508114115000.png)



令真值pose为$$\bar{M}$$, 那么目标函数可以写为：

$$f = ( M \ominus \bar{M}) = (\bar{M}^{-1}*M) = (Y * M)$$

以上$$f\in \mathbb{R}^{1}$$.  那它的雅克比，应该是$$J\in \mathbb{R}^{1\times 1}$$, 参考 eq. 64 (这与SE2的形式都是一样的，且推导过程一样)

$$J^{Y*M}_M = \frac{Log(Y*M*Exp(\tau)\ominus (Y*M))}{\tau}=\frac{Log(M^{-1}Y^{-1}*Y*M*Exp(\tau))}{\tau}=\frac{Log(Exp(\tau))}{\tau} = I$$

还有一种情况，当把目标函数定义为如下：

$$f = (\bar{M}\ominus M) = (M^{-1}*\bar{M}) = (X * \bar{M})$$

根据eq. 62.

$$J_M^{M^{-1} * \bar{M}} = J_{X}^{X*\bar{M}} * J_M^{M^{-1}}$$

那就是分别对这两个东西求偏导，第一个公式参考eq. 65。 这里面有一步关键的变换，在eq. 20. 

$$J_{X}^{X*\bar{M}} = (Ad_\bar{M})^{-1}$$

$$J_M^{M^{-1}} = -Ad_M$$

第二个式子，见公式62. 具体实现见test_fix_pose2.m

---

关于$$Ad_M$$的求法，下面以SO2为例进行推导(参考Ex 6)

$$M = R, \tau^{\hat{}} = \theta_{\times}, \tau =  \theta$$

因此，可以定义，利用$$R\theta_{\times}R^T = \theta_\times$$  (**Ex 6中说的似乎并不是这样，但是实验验证了一下，的确又是对的**)

$$\bold{Ad}_M * \tau = (M*\tau^{\hat{}}*M^{-1})^{\vee} = (R * \theta_{\times} *  R^T )^{\vee} \\ = (\theta_{\times})^{\vee} \\ = I\theta$$

得到：

$$\bold{Ad}_M = I$$

---

### 3. Test Poses

参考test_so2/test_pose.m

在这一节中，固定住landmarks，主要求pose

这里的目标函数为

$$f = M_G^L*p - y = {M_L^G}^{-1}*p - y = M^{-1}*p - y$$

这里${M_L^G} = M$ 为变量，$p , y$为已知

这里的$f \in R^{2}$, 变量M维度那雅克比$J\in R^{2\times 1}$

求下面这个雅克比时，有一个非常容易错的，就是直接在$M^{-1}$上进行扰动，这样会导致后续的计算非常复杂，这个时候最好要借助链式法则，另外$X = M^{-1}$

$$J^{M^{-1}*p - y}_M = J^{X*p-y}_XJ^{X}_M$$

---

根据eq. 129

$$J^{X*p-y}_X = lim \frac{XExp(\tau)p-y- (Xp - y)}{\tau}$$

分子$$A = XExp(\tau)p - Xp = X(I + \tau_\times)p - Xp = X\tau_\times p$$

所以

$$J^{X*p-y}_X = X1_\times p$$

---

$$J^{X}_M = J^{M^{-1}}_M = -Ad_M$$

---

实验结果如下：

![image-20230508150155900](/home/junwangcas/Documents/working/typora_imgs/2023/so2_test/image-20230508150155900.png)
