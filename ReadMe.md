####  1. 程序设计

主函数在INS.m, 其它部分为功能函数部分及画图部分。

~~~flow
st1=>start: 开始
io1=>inputoutput: 读取"Data1.bin"
op1=>operation: 初始化惯导信息

cond1=>condition: 还有历元(是或否?)
op2=>operation:  信息更新及
                 外推
               
op3=>operation: 等效旋转矢量法
                姿态更新

op4=>operation: 速度更新
op5=>operation: 位置更新
                
io2=>inputoutput: 输出纯惯导解算后数据
io3=>inputoutput: 读取"Data1_PureINS.bin"
op6=>operation: 绘图比较结果
e=>end: 终止

st1->io1->op1->cond1
cond1(yes)->op2->op3->op4->op5(right)->cond1
cond1(no,bottom)->io2->io3->op6->e

~~~

#### 2. 程序算法

##### 2.1 姿态更新

1. 等效旋转矢量法更新b系（高频更新）

$$
\begin{array}{r}
\boldsymbol{\phi}_{k}=\boldsymbol{\phi}_{b(k-1) b(k)} \approx \int_{t_{k-1}}^{t_{k}}\left[\boldsymbol{\omega}_{i b}^{b}+\frac{1}{2} \Delta \boldsymbol{\theta} \times \boldsymbol{\omega}_{i b}^{b}\right] d t=\Delta \boldsymbol{\theta}_{k}+\frac{1}{12} \Delta \boldsymbol{\theta}_{k-1} \times \Delta \boldsymbol{\theta}_{k} \\
\boldsymbol{q}_{b(k)}^{b(k-1)}=\left[\begin{array}{c}
\cos 0.5\left\|\boldsymbol{\phi}_{k}\right\|
\frac{\sin 0.5\left\|\boldsymbol{\phi}_{k}\right\|}{0.5\left\|\boldsymbol{\phi}_{k}\right\|} 0.5 \boldsymbol{\phi}_{k}
\end{array}\right]
\end{array}
$$

2. 等效旋转矢量法更新n系（可低频更新）

$$
\begin{array}{c}
\zeta_{k}=\zeta_{n(k-1) n(k)}=\int_{t_{k-l}}^{t_{k}}\left(\omega_{e n}^{n}+\omega_{i e}^{n}\right) d t \approx\left(\omega_{e n, k-1 / 2}^{n}+\omega_{i e, k-1 / 2}^{n}\right)\left(t_{k}-t_{k-1}\right) \\
\boldsymbol{q}_{n(k-l)}^{n(k)}=\left[\begin{array}{c}
\cos 0.5\left\|\zeta_{k}\right\| \\
-\frac{\sin 0.5\left\|\zeta_{k}\right\|}{0.5\left\|\zeta_{k}\right\|} 0.5 \zeta_{k}
\end{array}\right] \approx\left[\begin{array}{c}
1-\frac{1}{8}\left\|\zeta_{k}\right\|^{2} \\
-\frac{1}{2} \zeta_{k}
\end{array}\right]
\end{array}
$$
3. ​	计算当前时刻的姿态四元数

$$
\boldsymbol{q}_{b(k)}^{n(k)}=\boldsymbol{q}_{n(k-1)}^{n(k)} \boldsymbol{q}_{b(k-1)}^{n(k-1)} \boldsymbol{q}_{b(k)}^{b(k-1)}
$$
4. 对更新后的姿态四元数进行归一化处理

$$
q_{i}=\frac{\hat{q}_{i}}{\sqrt{\hat{q}_{0}^{2}+\hat{q}_{1}^{2}+\hat{q}_{2}^{2}+\hat{q}_{3}^{2}}}, i=0,1,2,3
$$

##### 2.2 速度更新

$$
\left\{\begin{array}{c}
\boldsymbol{v}_{k}^{n}=\boldsymbol{v}_{k-1}^{n}+\Delta \boldsymbol{v}_{f, k}^{n}+\Delta \boldsymbol{v}_{g / c o r, k}^{n} \\
\Delta \boldsymbol{v}_{g / \text {cor}, k}^{n}=\left\{\left[\boldsymbol{g}_{l}^{n}-\left(2 \omega_{i e}^{n}+\omega_{e n}^{n}\right) \times \boldsymbol{v}_{e}^{n}\right]_{t_{k-1 / 2}}\right\} \cdot\left(t_{k}-t_{k-1}\right) \\
\Delta \boldsymbol{v}_{f, k}^{n}=\left[\mathbf{I}-\left(0.5 \zeta_{k-1, k} \times\right)\right] \mathbf{C}_{b(k-1)}^{n(k-1)} \Delta \boldsymbol{v}_{f, k}^{b(k-1)} \\
\zeta_{k-1, k}=\left[\omega_{e n}^{n}\left(t_{k-1 / 2}\right)+\omega_{i e}^{n}\left(t_{k-1 / 2}\right)\right]\left(t_{k}-t_{k-1}\right) \\
\Delta \boldsymbol{v}_{f, k}^{b(\mathrm{k}-1)}=\Delta \boldsymbol{v}_{\mathrm{k}}+\frac{1}{2} \Delta \theta_{k} \times \Delta \boldsymbol{v}_{k}+\frac{1}{12}\left(\Delta \theta_{k-1} \times \Delta \boldsymbol{v}_{k}+\Delta \boldsymbol{v}_{k-1} \times \Delta \theta_{k}\right)
\end{array}\right.
$$

##### 2.3 位置更新

1. 高程

​       积分周期内 $v_{D}$ 简化随时间线性变化
$$
\begin{array}{c}
h\left(t_{k}\right)=h\left(t_{k-1}\right)-\int_{t_{k-1}}^{t_{k}} v_{D}(t) d t \\
h\left(t_{k}\right)=h\left(t_{k-1}\right)-\frac{1}{2}\left(v_{D}\left(t_{k}\right)+v_{D}\left(t_{k-1}\right)\right)\left(t_{k}-t_{k-1}\right)
\end{array}
$$

2. 纬度

   积分周期内可忽略 $R_{M}$ 随纬度（和时间）的变化，简化为常值。高程h在积分周期内简化为常值（积分周期内的平均高程）
   $$
   \varphi\left(t_{k}\right)=\varphi\left(t_{k-1}\right)+\frac{1}{2} \frac{v_{N}\left(t_{k}\right)+v_{N}\left(t_{k-1}\right)}{R_{M}\left(\varphi\left(t_{k-1}\right)\right)+\bar{h}}\left(t_{k}-t_{k-1}\right)
   $$

3. 经度
   $$
   \begin{array}{l}
   \lambda\left(t_{k}\right)=\lambda\left(t_{k-1}\right)+\frac{1}{2} \frac{v_{E}\left(t_{k}\right)+v_{E}\left(t_{k-1}\right)}{\left(R_{N}(\bar{\varphi})+\bar{h}\right) \cos (\bar{\varphi})}\left(t_{k}-t_{k-1}\right) \\
   \bar{h}=\frac{1}{2}\left(h\left(t_{k}\right)+h\left(t_{k-1}\right)\right), \quad \bar{\varphi}=\frac{1}{2}\left(\varphi\left(t_{k}\right)+\varphi\left(t_{k-1}\right)\right)
   \end{array}
   $$
   





#### 3.算例

  为节省空间，数据按照二进制存储，为双精度。由于数据文件过大，此处仅给出部分数据。

  Data1.bin数据用于纯惯导解算：  IMU的b-frame是前右下。

数据文件格式（7列）：  GPS周秒、Gx、Gy、Gz、Ax、Ay、Az （G代表陀螺，A代表加速度计）  ，陀螺和加速度计数据均为增量形式，单位分别为rad和m/s  。

初始时间：91620.0 s   初始位置（纬经高）：23.1373950708  [deg] 113.3713651222 [deg] 2.175 [m]  初始速度：0.0 0.0   0.0 [m/s]  初始姿态（roll,pitch,heading）：  0.0107951084511778,   -2.14251290749072, -75.7498049314083  [deg]     

Data1_PureINS.bin为机械编排参考结果：  纯惯导参考结果数据格式（10列）：  GPS周秒、纬度、经度、高度、北向速度、东向速度、垂向速度、横滚角、俯仰角、航向角  s        deg     m       m/s            deg  

 