# SO2 walk through

以SO2为例，对各个章节中的公式进行推导。

## II A Micro Lie Theory

### A. The Lie group

这个lie  group是一组2D旋转群。这一组群能表示所有的2D旋转.

2D的旋转其实就是一个圆，可微、光滑，局部是线性的。这种embed方式实际上是增加了一维。状态向量+约束=组成了这个群。群上每一处都定义了一个切空间，这个切空间是向量空间，~~这里来说，就是theta角。我们是可以在这个切空间（theta角）上来做积分的~~。



### B. The group actions

对于SO2来说，就是旋转2D向量和Composition.

### C. The tangent spaces and the lie algebra

matlab 的expm和logm 可以用来做这个lie algebra 和 lie group的变换。

对于公式9，要利用
$$
X^{-1} = X^T
$$
的性质来推导，具体在Example3那里有推导, 还有因为转置是线性的，所以有
$$
(\dot{X})^T = \dot{(X^T)}
$$

### D. Exponential Map

对于expm出现的时机，这里用到了常微分方程，不太明白，暂且不管了。

但是这个东西的计算，实际上就是一个泰勒展开, 从公式16也说明了，为什么泰勒展开的位置不能太远，即tao不能太大，太大之后，就会造成乘方之后数值会越来越大，而不是越来越小。

![image-20230304101100929](/home/junwangcas/Documents/working/typora_imgs/2023/so2 walk through/image-20230304101100929.png)

### E. Plus and minus operators

对于SO(2)来说，25 与27没啥区别

F. The adjoint and the adjoint matrix

在SO2中，tao local与tao global是一样的。

### G. Derivatives on Lie groups

之前一直在想一个问题，怎么样来确定自己求的偏导数没有问题，使用syms功能就可以了。

这里x是变量，f(x)就是残差函数，在SO(2)中，变量X为1维，就相当于这里m=1，误差项如果有三个，那么n=3;

H. Uncertainty in manifolds, covariance propagation

uncertainty 这一部分还是比较重要的，但凡涉及到优化那一部分的。都要有covariance

X_bar在这里相当于均值。通过eqt52，就把group上的方差，类似转换为tangent space上了。

### I. Descrete integration on Manifolds

这一部分是角速度积分的关键，看起来也是比较简单的，有一个概念是连续时间的积分与分割时间段的积分，一般来说都用后者，也就是$\delta t$.



## III. Differentiation fules on manifolds

### A. The chain rule

这个链式法则非常重要，形式与传统的复合函数的链式法则是一样的

### B. Elementary Jacobian blocks

这个eq 62还有点疑问，为什么，把31再看一下，看明白了，这里要把看清楚粗体Ad

eq 65/66推导过，没啥问题。





