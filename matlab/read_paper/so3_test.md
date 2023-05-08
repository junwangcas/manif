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

参考test_so3/test_pose.m

在这一节中，固定landmarks，主要求pose

主力的目标函数为：

$$f = M_G^L*p - y = {M_L^G}^{-1}*p - y = M^{-1}*p - y$$

这里${M_L^G} = M$ 为变量，$p , y$为已知

这里的$f \in R^{3}$, 变量M维度那雅克比$J\in R^{3\times 3}$

求下面这个雅克比时，有一个非常容易错的，就是直接在$M^{-1}$上进行扰动，这样会导致后续的计算非常复杂，这个时候最好要借助链式法则，令$X = M^{-1}$

$$J^{M^{-1}*p - y}_M = J^{X*p-y}_XJ^{X}_M$$

---

根据eq. 129

$$J^{X*p-y}_X = lim \frac{XExp(\tau)p-y- (Xp - y)}{\tau}$$

分子$$A = XExp(\tau)p - Xp = X(I + \tau_\times)p - Xp = X\tau_\times p$$

所以

$$J^{X*p-y}_X = XI_\times p$$

~~可以发现，这里与so2是一样的，只是维度I不太一样~~

正确的应该是eq.150

$$A = X\tau_\times p = - X p_\times \tau $$

所以： $$J^{X*p-y}_X = -Xp_{\times}$$

---

而

$$J^{X}_M = J^{M^{-1}}_M = -Ad_M = -R$$

这个东西在前面已经求过了

结果如下图：

![image-20230508200631284](/home/junwangcas/Documents/working/typora_imgs/2023/so3_test/image-20230508200631284.png)