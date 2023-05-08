### 1. test beacon

目标函数：

$$f = M_G^L*p - y = {M_L^G}^{-1}*p - y = M^{-1} * p - y$$

其中p是这些landmark点，y是观测。因为这个M = SO(2)是固定量。令: $$M = {M_L^G}^{-1}$$, 那么$$f = M * p - y$$，这个f是一个2*1的矩阵，变量$$p\in \mathbb{R}^2$$, 那么雅克比应该是$$J \in \mathbb{R}^{2\times 2}$$, 那么有如下形式

$$J = \frac{\delta f}{\delta p} = \frac{M(p+\delta p) -y - (M*p - y )}{\delta p} = \frac{M * \delta p}{\delta p} = R$$

与SO2的形式是一模一样的。

![image-20230508163956198](/home/junwangcas/Documents/working/typora_imgs/2023/so3_test/image-20230508163956198.png)

### 2. test fix pose

令真值pose为$$\bar{M}$$, 那么目标函数可以写为：

$$f = ( M \ominus \bar{M}) = (\bar{M}^{-1}*M) = (Y * M)$$

以上$$f\in \mathbb{R}^{3}$$.  那它的雅克比，应该是$$J\in \mathbb{R}^{3\times 3}$$, 参考 eq. 64 (这与SE2的形式都是一样的，且推导过程一样)

$$J^{Y*M}_M = \frac{Log(Y*M*Exp(\tau)\ominus (Y*M))}{\tau}=\frac{Log(M^{-1}Y^{-1}*Y*M*Exp(\tau))}{\tau}=\frac{Log(Exp(\tau))}{\tau} = I$$

与SO2的一样

![image-20230508173040658](/home/junwangcas/Documents/working/typora_imgs/2023/so3_test/image-20230508173040658.png)

---

还有一种情况，当把目标函数定义为如下：

$$f = (\bar{M}\ominus M) = (M^{-1}*\bar{M}) = (X * \bar{M})$$

根据eq. 62.

$$J_M^{M^{-1} * \bar{M}} = J_{X}^{X*\bar{M}} * J_M^{M^{-1}}$$

那就是分别对这两个东西求偏导，第一个公式参考eq. 65。 这里面有一步关键的变换，在eq. 20. 

$$J_{X}^{X*\bar{M}} = (Ad_\bar{M})^{-1}$$

$$J_M^{M^{-1}} = -Ad_M$$

第二个式子，见公式62.  最后，就落脚到求Adm上了

---

SO3的伴随矩阵

关于$$Ad_M$$的求法，下面以SO2为例进行推导(参考Ex 6)

$$M = R, \tau^{\hat{}} = \theta_{\times}, \tau =  \theta$$

$$\bold{Ad}_M * \tau = (M*\tau^{\hat{}}*M^{-1})^{\vee} = (R * \theta_{\times} *  R^T )^{\vee} \\ = (R\theta)_\times$$

这样的话，**带入实际值应用没问题，从形式上这个地方似乎不太保险**。

$$\bold{Ad}_M = R $$

---

![image-20230508173722711](/home/junwangcas/Documents/working/typora_imgs/2023/so3_test/image-20230508173722711.png)

### 3. test poses

