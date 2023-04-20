### 1. beacon optimization

见代码：test_se2/test_beacon.m

首先生成几个真值的landmark点(5个)

<img src="/home/junwangcas/Documents/working/typora_imgs/2023/se2_test/image-20230316204714647.png" alt="image-20230316204714647" style="zoom: 50%;" />

然后生成一个固定的pose, 通过一个2d位置加上一个角度，就可以生成一个SE2:  
$$
\mathbb{R}^3 = [\rho, \theta]^T -> se(2)=\begin{bmatrix} [\theta]_{\times} &\rho \\ 0 & 1\end{bmatrix}-> SE(2)=\begin{bmatrix} R&t\\0&1 \end{bmatrix}
$$
这里要注意的是，这个$\rho$ 并不是这个pose的translation。

<img src="/home/junwangcas/Documents/working/typora_imgs/2023/se2_test/image-20230317145442092.png" alt="image-20230317145442092" style="zoom: 50%;" />

然后给他一个初始值：

<img src="/home/junwangcas/Documents/working/typora_imgs/2023/se2_test/image-20230317150217871.png" alt="image-20230317150217871" style="zoom:50%;" />

后面fix住pose，然后对beacon进行优化：

<img src="/home/junwangcas/Documents/working/typora_imgs/2023/se2_test/image-20230317150339218.png" alt="image-20230317150339218" style="zoom:50%;" />

目标函数是：

$$f = M_G^L*p - y = {M_L^G}^{-1}*p - y$$

其中p是这些landmark点，y是观测。因为这个M = SE(2)是固定量。令: $$M = {M_L^G}^{-1}$$, 那么$$f = M * p - y$$，这个f是一个2*1的矩阵，变量$$p\in \mathbb{R}^2$$, 那么雅克比应该是$$J \in \mathbb{R}^{2\times 2}$$, 那么有如下形式

$$J = \frac{\delta f}{\delta p} = \frac{M(p+\delta p) -y - (M*p - y )}{\delta p} = \frac{M * \delta p}{\delta p}$$

以上$$\delta p -> 0$$, 这里$$M\in \mathbb{R}^{3\times 3}, \delta p \in \mathbb{R}^2$$,  根据eq. 165: $$M * p = Rp + t$$, 上面这个式子不对(主要是带星号的乘法不是正儿八经的乘法）。应该是：

$$J = \frac{\delta f}{\delta p} = \frac{M(p+\delta p) -y - (M*p - y )}{\delta p} = \frac{R(p+\delta p) + t - y - (Rp +t -y)}{\delta p} = \frac{R\delta p}{\delta p} = R$$



### 2. Test Fix Pose

第一节中主要是把pose当成了常数，这里把pose当成变量，并将其固定住。脚本manif/matlab/test_se2/test_fix_pose.m

假设要pose要固定的值如左图，初始值如中图，最终优化的值如右图：

<center>
<img src="/home/junwangcas/Documents/working/typora_imgs/2023/se2_test/image-20230325112007698.png" alt="image-20230325112007698" style="zoom:50%;" />
<img src="/home/junwangcas/Documents/working/typora_imgs/2023/se2_test/image-20230325112041881.png" alt="image-20230325112041881" style="zoom:50%;" />
    <img src="/home/junwangcas/Documents/working/typora_imgs/2023/se2_test/image-20230325112403687.png" alt="image-20230325112403687" style="zoom:50%;" />
<center>
令真值pose为$$\bar{M}$$, 那么目标函数可以写为：

$$f = ( M \ominus \bar{M})^{\vee} = (\bar{M}^{-1}*M)^{\vee} = (Y * M)^{\vee}$$

以上$$f\in \mathbb{R}^{3}$$.  那它的雅克比，应该是$$J\in \mathbb{R}^{3\times 3}$$

$$J^{Y*M}_M = \frac{Log(Y*M*Exp(\tau)\ominus (Y*M))}{\tau}=\frac{Log(M^{-1}Y^{-1}*Y*M*Exp(\tau))}{\tau}=\frac{Log(Exp(\tau))}{\tau} = I$$

还有一种情况，当把目标函数定义为如下：

$$f = (\bar{M}\ominus M)^{\vee} = (M^{-1}*\bar{M})^\vee = (X * \bar{M})^\vee$$

根据eq. 62.

$$J_M^{M^{-1} * \bar{M}} = J_{X}^{X*\bar{M}} * J_M^{M^{-1}}$$

那就是分别对这两个东西求偏导

$$J_{X}^{X*\bar{M}} = (Ad_\bar{M})^{-1}$$

$$J_M^{M^{-1}} = -Ad_M$$

关于$$Ad_M$$的求法，下面以SE2为例进行推导(参考Ex 6)

$$M = \begin{bmatrix}R&t\\ 0 &1\end{bmatrix}, \tau^{\hat{}} = \begin{bmatrix}\theta_{\times}&\rho\\0&0\end{bmatrix}, \tau = \begin{bmatrix}\rho\\ \theta\end{bmatrix}$$

因此，可以定义

$$\bold{Ad}_M * \tau = (M*\tau^{\hat{}}*M^{-1})^{\vee} = (\begin{bmatrix}R&t\\ 0 &1\end{bmatrix} * \begin{bmatrix}\theta_{\times}&\rho\\0&0\end{bmatrix} * \begin{bmatrix} R^T & -R^Tt\\0&1 \end{bmatrix})^{\vee} \\ = (\begin{bmatrix} R\theta_{\times}&R\rho\\ 0&0\end{bmatrix} \begin{bmatrix} R^T & -R^Tt\\0&1 \end{bmatrix})^{\vee} \\ = \begin{bmatrix}R\theta_{\times}R^T&-R\theta_{\times}R^Tt + R\rho\\0 &0 \end{bmatrix})^{\vee}$$

然后利用$$R\theta_{\times}R^T = \theta_\times$$,  TODO: 这个地方很奇怪，用了这个替换之后，后面就推导不通过了。如果不用是可以的。

$$\bold{Ad}_M * \tau  = (\begin{bmatrix} \theta_\times & \theta_\times t+R\rho\\ 0 &0\end{bmatrix})^{\vee} \\= \begin{bmatrix}R\rho-\theta_\times t\\ \theta \end{bmatrix}$$ 

**上式通过验证没通过**。见 test_adjoint.m, line 34

$$\bold{Ad}_M * \tau = \begin{bmatrix}R\theta_{\times}R^T&-R\theta_{\times}R^Tt + R\rho\\0 &0 \end{bmatrix})^{\vee} \\=\begin{bmatrix}R\rho-\theta_\times t\\ \theta \end{bmatrix} = \begin{bmatrix}R&-1_{\times}t\\0& 1\end{bmatrix}\begin{bmatrix}\rho \\ \theta\end{bmatrix}$$

上式验证通过。见式39

