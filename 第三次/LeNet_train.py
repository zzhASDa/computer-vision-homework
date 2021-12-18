import torch.nn as nn
import torch
import torch.optim as optim
import numpy as np
import struct
import matplotlib.pyplot as plt

def getData():
    file_train_image = open('train-images.idx3-ubyte', 'rb')
    file_train_label = open('train-labels.idx1-ubyte', 'rb')
    
    #*读取前两个数字，一个magic来标识数据，第二个n代表数据总数，>II表示大端存储读取两个无符号整数
    [magic_lab, n] = struct.unpack(">II", file_train_label.read(8))
    [magic_img, n, row, col] = struct.unpack(">IIII", file_train_image.read(16))
    #*读取标签与图片，每个标签或者像素值都为8位无符号整数,并且将图片数据reshape
    train_label = np.fromfile(file_train_label, dtype=np.uint8)
    train_image = np.fromfile(file_train_image, dtype=np.uint8).reshape((n, row, col))
    
    return train_image, train_label, n, (row, col)

class convolution_neural_network(nn.Module):
    def __init__(self):
        super(convolution_neural_network, self).__init__()
        # 定义卷积层
        self.conv = nn.Sequential(
            #卷积  b*1*28*28 -> b*6*24*24
            nn.Conv2d(in_channels=1, out_channels=6, kernel_size=5, stride=1, padding=0),  
            nn.Sigmoid(),
            #下采样 b*6*24*24 -> b*6*12*12
            nn.MaxPool2d(kernel_size=2, stride=2),
            #卷积  b*6*12*12 -> b*16*8*8  
            nn.Conv2d(in_channels=6, out_channels=16, kernel_size=5, stride=1, padding=0),  
            nn.Sigmoid(),
            #下采样 b*16*8*8 -> b*16*4*4
            nn.MaxPool2d(kernel_size=2, stride=2) 
        )
        self.fc = nn.Sequential(
            #将特征图展开成向量作为输入，跟上3个全连接层,最后再加上softmax得分
            #全连接 b*256 -> b*120
            nn.Linear(in_features=256, out_features=120),
            nn.Sigmoid(),
            #全连接 b*120 -> b*84
            nn.Linear(in_features=120, out_features=84),
            nn.Sigmoid(),
            #全连接 b*84 -> b*10
            nn.Linear(in_features=84, out_features=10),
            nn.Softmax(dim=1)
        )

    def forward(self, img):
        #对图像卷积
        feature = self.conv(img)
        #reshap形状为[batch_size, size]
        output = self.fc(feature.view(-1,256))
        return output

if __name__ == "__main__":
    #如果能用cuda就用cuda
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

    [train_image, train_label, n, size] = getData()
    LeNet = convolution_neural_network()
    LeNet.to(device)

    epochs = 10  #epochs次数
    batch_size = 300 #batch大小
    batchs = n // batch_size #有多少个batch
    learning_rate = 0.001 #学习率
    loss_func = nn.CrossEntropyLoss() #交叉熵损失
    optimizer = optim.Adam(params=LeNet.parameters(), lr=learning_rate) #梯度下降使用Adam优化
    loss_list = [] #存储损失

    for epoch in range(epochs):
        accuracy = 0.0
        for batch in range(batchs):
            #梯度清零
            optimizer.zero_grad()
            #得到一个batch索引的上下界
            l = batch * batch_size 
            r = l + batch_size 
            #nn.Conv2d的输入为四维B(bachsize),C(channel),H(high),W(widt)
            #损失函数的输入参数为predict(N,C),label(N),其中C代表种类数,并且label需要为tensor.long类型
            image = torch.Tensor(train_image[l:r]).reshape(-1, 1, size[0], size[1])
            label = torch.tensor(train_label[l:r]).long()
            image = image.to(device)
            label = label.to(device)
            #得到预测向量
            prediction = LeNet(image)
            #统计正确个数
            for idx in range(batch_size):
                if torch.argmax(prediction[idx]) == label[idx]:
                    accuracy += 1
            #计算损失
            loss = loss_func(prediction, label)
            #反向传播
            loss.backward()
            #参数更新
            optimizer.step()
            #将损失转到cpu上,去除梯度后转化为numpy
            loss = loss.cpu().detach().numpy()
            loss_list.append(loss)
        accuracy = accuracy/n
        #每次输出的损失都为用所有图片训练完一次后的损失
        print("第%d轮迭代: 损失为:%f 正确率为:%f" % (epoch, loss_list[-1], accuracy))
    #保存模型的参数为LeNet_parameter.pt,用字典对应
    torch.save({"LeNet":LeNet.state_dict()}, "LeNet_parameter.pt")
    #画损失图像
    plt.plot(loss_list)
    plt.title("loss of each batch")
    plt.savefig("loss.png")
    plt.show()
