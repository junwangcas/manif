### 1. beacon optimization

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

其中p是这些landmark点，y是观测。因为这个M = SE(3)是固定量。令: $$M = {M_L^G}^{-1}$$, 那么$$f = M * p - y$$，这个f是一个2*1的矩阵，变量$$p\in \mathbb{R}^2$$, 那么雅克比应该是$$J \in \mathbb{R}^{2\times 2}$$, 那么有如下形式

$$J = \frac{\delta f}{\delta p} = \frac{M(p+\delta p) -y - (M*p - y )}{\delta p} = \frac{M * \delta p}{\delta p}$$

以上$$\delta p -> 0$$, 这里$$M\in \mathbb{R}^{3\times 3}, \delta p \in \mathbb{R}^2$$,  根据eq. 165: $$M * p = Rp + t$$, 上面这个式子不对。应该是：

$$J = \frac{\delta f}{\delta p} = \frac{M(p+\delta p) -y - (M*p - y )}{\delta p} = \frac{R(p+\delta p) + t - y - (Rp +t -y)}{\delta p} = \frac{R\delta p}{\delta p} = R$$























