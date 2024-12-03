# 一、模块设计

## 模块一：寄存器堆

- 功能同 P0 第三题 GRF

## 模块二：算术逻辑单元

- ALUOp 决定 ALU 进行的运算

## 模块三：取指令模块

- 每个时钟周期上升沿将pcNext赋值给pc
- 将pc的值减去初值0x00003000，作为ROM读取的地址addr
- pc若为0则将pc置为初始值0x00003000，地址置为0

## 模块四：乘除模块

- 进行乘除运算，结果存入内部相应的寄存器
- 通过busy信号对后续指令进行阻塞
- 写使能时，将值写入内部寄存器中
- 根据控制信号，输出内部寄存器地计算结果

##  模块五：控制信号生成器

### （1）D段

- **pcOp**：设置程序计数器的操作。
- **cmpOp**：表示条件跳转比较。
- **extOp**：是否需要扩展符号。
- **regWE**：表示寄存器写使能。
- **MD** ：是否需要使用乘除模块。
- **rtTuse** 和 **rsTuse**：再过几个周期，该指令要使用  rs 或  rt 寄存器的值。

### （2）E段

- **ALUOp**：决定 ALU 执行的操作。
- **MDOp**：决定 MD 执行的操作。
- **MDWE**：表示HI、LO寄存器写使能。
- **MDAddrOp**：选择读取 MD 中的寄存器。
- **resOp**：选择E段结果来自 ALU 还是 MD。
- **ALUIn2Op**：确定 ALU 第二个输入。
- **fwAddrOp**：选择转发的地址。
- **fwDataOp**：选择转发的数据。
- **Tnew**：表示以D级为基准，再过几个周期，该指令产生所需的结果。

### （3）M段

- **memStoreOp**：决定写入主存的数据是字、字节和半字。
- **memLoadOp**：决定主存读出的数据是字、字节和半字。
- **fwAddrOp**：选择转发的地址。
- **fwDataOp**：选择转发的数据。
- **Tnew**：从结果产生到存入流水线寄存器需要几个周期。

### （4）W段

- **fwAddrOp**：选择转发的地址。
- **fwDataOp**：选择转发的数据。
- **Tnew**：从结果产生到存入流水线寄存器需要几个周期。

## 模块六：流水线寄存器

- **D段**：存储 pc、指令
- **E段**：存储 pc、指令、rs 和  rt 读出的数据、立即数、是否写入寄存器
- **M段**：存储 pc、指令、rs 和  rt 读出的数据、立即数、ALU 计算结果、是否写入寄存器
- **W段**：存储 pc、指令、rs 和  rt 读出的数据、立即数、ALU 计算结果、主存读出结果、是否写入寄存器

## 模块七：字节/半字/字选择模块

- 根据ALU计算地址的后两位，以及存取指令的类型，决定主存存取的数据

# 二、阻塞与转发

## 1.阻塞

### 条件：
- 读写寄存器冲突
	- Tuse\<Tnew 
	- 需要将后续数据写入寄存器
	- 写入寄存器地址不为0
	- 写入寄存器地址与后续转发地址相同
- 乘除单元使用冲突
	- MD单元处于busy状态
	- 后续指令需要使用MD单元

### 行为：
- 停止取下一条指令
- D级寄存器保持原值不变
- E级寄存器复位

## 2.转发

###  条件：
- Tnew=0
- 需要将后续数据写入寄存器
- 写入寄存器地址不为0
- 写入寄存器地址与后续转发地址相同

### 通路：
- E段->D段
- M段->D段、E段
- W段->D段、E段、M段

### 内容：
- 转发地址：写入的寄存器
- 转发数据：写入寄存器的内容

# 三、思考题

## 问题一、
- Q：为什么需要有单独的乘除法部件而不是整合进 ALU？为何需要有独立的 HI、LO 寄存器？
- 乘除法的运算时间远大于其他运算，若将其整合进ALU，则需要在一个周期内支持包括乘除运算在内的所有运算，整个CPU的时钟周期大大延长；独立出来可使用多个时钟周期进行乘除运算
- 独立的HI、LO寄存器便于存放可能产生的64位数据或商和余数，简化了CPU的数据通路，便于并行指令
## 问题二、
- Q：真实的流水线 CPU 是如何使用实现乘除法的？请查阅相关资料进行简单说明。

  ### 1. **乘法（Multiplication）**

  在硬件级别，乘法可以使用不同的算法来实现，具体取决于硬件设计的复杂性和效率要求。对于流水线CPU，常见的乘法实现包括以下几种：

  #### 1.1 **加法乘法器（Array Multiplier）**
  这是一个硬件实现，其中使用了并行的加法器阵列来同时计算乘法操作。其基本思想是通过将两个操作数的每一位乘法的结果加和来得到最终结果。

  - **流水线处理**：乘法操作通常会分成若干个阶段。每个阶段进行部分乘法并将结果传递到下一阶段。因为乘法是一个多步骤的过程，所以实现加法乘法器时会分多个流水线阶段，分别处理每一位的乘法和加法，最终将结果合成。
  - **优点**：可以并行处理多个位的乘法，从而加快整体运算速度。
  - **缺点**：硬件消耗较大，需要较多的资源。

  #### 1.2 **Booth算法（Booth's Algorithm）**
  Booth算法是一种用于乘法的高效算法，通过优化乘法的位移和加法，能够减少需要进行的加法次数，尤其是在乘法的操作数中存在连续的0或1时，能够有效压缩计算量。

  - **流水线实现**：Booth算法通过分段处理部分乘法的过程，使得CPU可以在流水线阶段中逐步计算。这个过程可以通过流水线化的乘法单元并行执行，每一阶段计算一个部分乘积。
  - **优点**：在有重复位模式时，比直接的逐位乘法更加高效。
  - **缺点**：硬件实现相对复杂。

  #### 1.3 **分割乘法（Divide-and-Conquer）**
  分割乘法将乘法分解为多个较小的乘法操作，通常采用递归的方式进行实现。例如，可以通过分治法将大整数的乘法拆解为多个小数乘法，然后合并结果。

  - **流水线实现**：在流水线CPU中，乘法操作会被划分为多个阶段，每个阶段计算一部分乘积。分治法的每个递归步骤都可以并行地在不同流水线阶段进行处理。
  - **优点**：能更有效地处理大数乘法。
  - **缺点**：需要更多的硬件资源和控制逻辑。

  ### 2. **除法（Division）**

  除法是比乘法更加复杂的操作，它通常比乘法更耗时，尤其是在没有专用硬件支持的情况下。对于流水线CPU，常见的除法实现方法有：

  #### 2.1 **恢复余数法（Restoring Division）**
  恢复余数法是一种传统的除法算法，它通过模拟长除法的过程来逐步计算商和余数。在每次循环中，它会对被除数进行“恢复”操作，然后与除数进行比较，判断是否需要继续处理。

  - **流水线实现**：恢复余数法可以分为几个阶段：首先将被除数和除数加载到寄存器中，然后逐步进行恢复和计算商的过程。每一步都可以在流水线的一个阶段内完成。
  - **优点**：算法简单，容易实现。
  - **缺点**：效率较低，尤其是在处理大数时。

  #### 2.2 **非恢复余数法（Non-Restoring Division）**
  非恢复余数法通过改进恢复余数法来提高效率。其核心思想是在计算商的过程中，避免每次恢复余数的操作，从而减少计算步骤。

  - **流水线实现**：非恢复余数法通过将每个步骤分解为多个流水线阶段，例如，分为除数与被除数的比较、计算商位、更新余数等步骤，从而提高除法的并行性。
  - **优点**：比恢复余数法更高效，尤其适合高频使用的除法操作。
  - **缺点**：实现起来较复杂。

  #### 2.3 **SRT除法（Sweeney, Robertson, and Tocher）**
  SRT除法算法通过“猜测”商的位，并在每个步骤中进行修正。这种算法通常比恢复余数法更快，适用于在高效的硬件中实现。

  - **流水线实现**：SRT除法的每个步骤也可以分为多个阶段，利用流水线将各个部分并行处理，从而加速除法过程。每个流水线阶段负责更新部分商位和余数，直到整个除法操作完成。
  - **优点**：在硬件中可以实现更高的效率。
  - **缺点**：实现复杂，可能需要更多的硬件资源。

  #### 2.4 **倒数法（Reciprocal Approximation）**
  倒数法是一种通过求取除数的倒数并进行乘法来进行除法的近似方法。在现代的高速CPU中，通常使用浮点单元中的倒数逼近方法，通过迭代或查找表等方式得到除数的倒数，再与被除数相乘得到商。

  - **流水线实现**：通过采用查找表或近似计算方法，可以将倒数的计算并行化，并与其他操作一起流水线处理。
  - **优点**：当精度要求不高时，可以大大加快除法运算速度。
  - **缺点**：计算精度有限，适用场景有限。

  ### 3. **现代CPU中的乘除法实现**

  现代CPU（例如Intel和AMD的处理器）通常包括专用的乘法和除法硬件单元，这些单元通过流水线结构进行并行计算，从而提高计算速度。

  - **乘法**：现代CPU使用高速乘法器（如前述的数组乘法器或Booth算法实现），这些乘法器通常是高度流水线化的，可以在多个时钟周期内同时计算多个部分乘积。
  - **除法**：现代CPU中的除法器通常采用更复杂的算法，如SRT除法或倒数法。对于整数除法，CPU可能使用硬件级别的除法单元来加速计算；对于浮点除法，则可能使用近似算法。

  在流水线设计中，每个阶段通常会涉及数据的传递、计算和结果存储。乘法和除法操作由于其计算步骤多、依赖关系强，往往会涉及多阶段流水线和复杂的控制逻辑。

## 问题三、
- Q：请结合自己的实现分析，你是如何处理 Busy 信号带来的周期阻塞的？
- A：在MD模块中，Busy信号用于指示乘除模块当前的工作状态，体现模块是否正在进行乘除运算，以及该运算距离完成还需要多少个时钟周期，顶层模块通过监测这个信号来知晓当前乘除模块是否可用，避免在其忙碌时发送新的运算请求造成冲突，从而实现对周期阻塞情况的合理处理。

## 问题四、
- Q：请问采用字节使能信号的方式处理写指令有什么好处？（提示：从清晰性、统一性等角度考虑）
- A：字节使能信号处理写指令实现十分得清晰，根据ALU计算地址的后两位，以及存取指令的类型，决定主存存取的数据，避免了大量的位拼接和分条件写入的情况，使代码有更模块化，易于维护，对于按字、半字、字节写入的实现通用，统一性好。

## 问题五、
- Q：请思考，我们在按字节读和按字节写时，实际从 DM 获得的数据和向 DM 写入的数据是否是一字节？在什么情况下我们按字节读和按字节写的效率会高于按字读和按字写呢？
- 不是，实际获得的数据是字，然后经过分割和拓展得到存取主存的结果
- 在处理大量单字节数据，例如字符串中的字符时，按字节读和按字节写的效率会高于按字读写

## 问题六、
- Q：为了对抗复杂性你采取了哪些抽象和规范手段？这些手段在译码和处理数据冲突的时候有什么样的特点与帮助？
- 每个流水段中的信号严格按照规则命名，提高代码的可读性和易维护性
- 顶层信号与子模块的信号名称保持相似性，防止出现接线错误
- 转发的数据和地址进行特别标注，使逻辑更清晰
- 每一种阻塞的逻辑单列一行，使代码清晰整洁

## 问题七、
- Q：在本实验中你遇到了哪些不同指令类型组合产生的冲突？你又是如何解决的？相应的测试样例是什么样的？
- 第一类是在P5中遇到的Tuse和Tnew时产生的冲突
- 第二类是乘除模块busy时进行乘除指令的冲突
- 通过在P5的基础上增加一个乘除模块的阻塞逻辑来实现冲突的处理

```assembly
# 测试Tuse和Tnew
lw $t3, 0($s1) 
sw $t4, 0($s1)
lw $t5, 0($s1)          
add $t6,$t5,$t3
# 测试乘除法的busy
ori $t0,5
ori $t1,9
multu $t0,$t1
nop
mflo $t1
mfhi $t2
mtlo $t2
mthi $t1
```

## 问题八：
- Q：如果你是手动构造的样例，请说明构造策略，说明你的测试程序如何保证覆盖了所有需要测试的情况；如果你是完全随机生成的测试样例，请思考完全随机的测试程序有何不足之处；如果你在生成测试样例时采用了特殊的策略，比如构造连续数据冒险序列，请你描述一下你使用的策略如何结合了随机性达到强测的效果。
- 限制寄存器的使用数量，以提高数据冲突的频率
- 将test分为几个subtest，用jal，beq指令将其串联，避免了跳转指令地址不合理的情况
- 指令绝对数目多，在长时间内多组指令轮测可覆盖绝大部分情况
