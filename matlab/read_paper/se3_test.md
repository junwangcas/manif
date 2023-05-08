### 1. test beacon

目标函数

目标函数：

$$f = M_G^L*p - y = {M_L^G}^{-1}*p - y = M^{-1} * p - y$$

其中p是这些landmark点，y是观测。因为这个M = SO(2)是固定量。令: $$M = {M_L^G}^{-1}$$, 那么$$f = M_{-1} * p - y$$，这个f是一个3*1的矩阵，变量$$p\in \mathbb{R}^3$$, 那么雅克比应该是$$J \in \mathbb{R}^{3\times 3}$$, 那么有如下形式

$$J = \frac{\delta f}{\delta p} = \frac{M(p+\delta p) -y - (M*p - y )}{\delta p} = \frac{M * \delta p}{\delta p} = R$$

与SO2的形式是一模一样的。

![image-20230508202614870](/home/junwangcas/Documents/working/typora_imgs/2023/se3_test/image-20230508202614870.png)