### 1. test beacon

目标函数

目标函数：

$$f = M_G^L*p - y = {M_L^G}^{-1}*p - y = M^{-1} * p - y$$

其中p是这些landmark点，y是观测。因为这个M = SO(2)是固定量。令: $$M = {M_L^G}^{-1}$$, 那么$$f = M_{-1} * p - y$$，这个f是一个3*1的矩阵，变量$$p\in \mathbb{R}^3$$, 那么雅克比应该是$$J \in \mathbb{R}^{3\times 3}$$, 那么有如下形式

$$J = \frac{\delta f}{\delta p} = \frac{M(p+\delta p) -y - (M*p - y )}{\delta p} = \frac{M * \delta p}{\delta p} = R$$

与SO2的形式是一模一样的。

![image-20230508202614870](/home/junwangcas/Documents/working/typora_imgs/2023/se3_test/image-20230508202614870.png)

### 2. test fix pose

令真值pose为$$\bar{M}$$, 那么目标函数可以写为：

$$f = ( M \ominus \bar{M}) = (\bar{M}^{-1}*M) = (Y * M)$$

以上$$f\in \mathbb{R}^{6}$$.  那它的雅克比，应该是$$J\in \mathbb{R}^{6\times 6}$$, 参考 eq. 64 (这与SE2的形式都是一样的，且推导过程一样)

$$J^{Y*M}_M = \frac{Log(Y*M*Exp(\tau)\ominus (Y*M))}{\tau}=\frac{Log(M^{-1}Y^{-1}*Y*M*Exp(\tau))}{\tau}=\frac{Log(Exp(\tau))}{\tau} = I$$

与SO2的一样

![image-20230508204059574](/home/junwangcas/Documents/working/typora_imgs/2023/se3_test/image-20230508204059574.png)

---

还有一种情况，当把目标函数定义为如下：

$$f = (\bar{M}\ominus M) = (M^{-1}*\bar{M}) = (X * \bar{M})$$

根据eq. 62.

$$J_M^{M^{-1} * \bar{M}} = J_{X}^{X*\bar{M}} * J_M^{M^{-1}}$$

这里与SO3就有些不太一样了，见式子 177

$$J_{X}^{X*\bar{M}} = \begin{bmatrix}\bar{R}^T&-\bar{R}^T\bar{t}_\times\\0&\bar{R}^T\end{bmatrix}$$

而

$$J_M^{M^{-1}}=-\begin{bmatrix}R&t_\times R\\0&R\end{bmatrix}$$

![image-20230508205505981](/home/junwangcas/Documents/working/typora_imgs/2023/se3_test/image-20230508205505981.png)

**发现不一定每次都收敛**。找到问题了，是因为一个转置的问题。

---

### 3. test poses

参考test_se3/test_pose.m

在这一节中，固定landmarks，主要求pose

主力的目标函数为：

$$f = M_G^L*p - y = {M_L^G}^{-1}*p - y = M^{-1}*p - y$$

这里${M_L^G} = M$ 为变量，$p , y$为已知

这里的$f \in R^{3}$, 变量M维度那雅克比$J\in R^{3\times 6}$

求下面这个雅克比时，有一个非常容易错的，就是直接在$M^{-1}$上进行扰动，这样会导致后续的计算非常复杂，这个时候最好要借助链式法则，令$X = M^{-1}$

$$J^{M^{-1}*p - y}_M = J^{X*p-y}_XJ^{X}_M$$

---

根据eq. 182, 这里是将$\tau$拆分开了，分为$\theta 与 \rho$部分，其中$\rho$求导得到的eq. 172的V(theta), 这个东西与R是相近的。

$$J^{X*p-y}_X = \begin{bmatrix}R&-Rp_\times\end{bmatrix}$$

这里R是X的

---

而

$$J^{X}_M = J^{M^{-1}}_M = -\begin{bmatrix}R&t_\times R\\0 &R\end{bmatrix}$$

![image-20230509145549808](/home/junwangcas/Documents/working/typora_imgs/2023/se3_test/image-20230509145549808.png)