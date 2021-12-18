import torch.nn as nn
import torch
import numpy as np
import struct

def getData():
    file_test_image = open('t10k-images.idx3-ubyte', 'rb')
    file_test_label = open('t10k-labels.idx1-ubyte', 'rb')
    
    #*读取前两个数字，一个magic来标识数据，第二个n代表数据总数，>II表示大端存储读取两个无符号整数
    [magic_lab, n] = struct.unpack(">II", file_test_label.read(8))
    [magic_img, n, row, col] = struct.unpack(">IIII", file_test_image.read(16))
    #*读取标签与图片，每个标签或者像素值都为8位无符号整数,并且将图片数据reshape
    test_label = np.fromfile(file_test_label, dtype=np.uint8)
    test_image = np.fromfile(file_test_image, dtype=np.uint8).reshape((n, row, col))
    
    return test_image, test_label, n, (row, col)

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

    [test_image, train_label, n, size] = getData()
    LeNet = convolution_neural_network()
    #加载参数
    state_dict = torch.load("LeNet_parameter.pt")
    LeNet.load_state_dict(state_dict["LeNet"])

    accuracy = 0.0

    for index in range(n):
        #*显示测试图片,非必要，可选
        # plt.imshow(test_image[index], cmap='Greys', interpolation=None)
        # plt.show()
        
        #nn.module的输入为四维B(bachsize),C(channel),H(high),W(widt)
        #损失函数的输入参数为predict(N,C),label(N),其中C代表种类数,并且label需要为tensor.long类型
        image = torch.Tensor(test_image[index]).reshape(-1, 1, size[0], size[1])
        label = torch.tensor(train_label[index]).long().reshape(1)

        #得到预测向量
        prediction = LeNet(image)
        predict_label = torch.argmax(prediction)
        if predict_label == label:
            accuracy += 1

        #*以下可选,如果想要观察每张图片的输出
        # predict_label = predict_label.cpu().detach().numpy()
        # label = label.cpu().detach().numpy()
        # print("预测数字为%d 实际数字为%d" % (predict_label, label))
    accuracy = accuracy/n
    print("正确率为:%f" % accuracy)
