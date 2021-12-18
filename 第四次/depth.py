import cv2
import numpy as np
from matplotlib import pyplot as plt 

def getDisparity():
    # #将图片读取为灰度图像
    # imgr = cv2.imread("RIma-000023.png", cv2.IMREAD_GRAYSCALE)
    # imgl = cv2.imread("LIma-000023.png", cv2.IMREAD_GRAYSCALE)
  
    #读取彩色图片
    imgr = cv2.imread("RIma-000023.png")
    imgl = cv2.imread("LIma-000023.png")
    #设置参数
    block_size = 7
    channels = imgr.shape[2]
    #计算视差图
    stereo = cv2.StereoSGBM_create(
        #参数设置
        minDisparity = 0, #最小视差
        blockSize = block_size, #窗口大小
        #以下参数设置为官方推荐
        #P1与P2为动态规划有关参数
        P1 = 8*channels*block_size*block_size,
        P2 = 32*channels*block_size*block_size,
        disp12MaxDiff = 1, #左视差图与右视差图的最大差异
        uniquenessRatio = 10, #次低代价>=最低代价*(1+uni/100)
        speckleWindowSize = 100, #平滑区域最大尺寸
        speckleRange = 10 #视差变化的阈值
    )
    disparity = stereo.compute(imgl,imgr)
    return disparity

def getDepth(dis):
    f = 7 #焦距，单位为毫米
    B = 500 #基线， 单位为毫米
    w_of_pixel = 0.0064 #每个像素的宽度，单位为毫米
    [row, col] = dis.shape #获取形状
    #定义空图片
    depth = np.zeros((row, col))
    for r in range(row):
        for c in range(col):
            #计算视差实际值
            D = dis[r][c] * w_of_pixel 
            #如果视差为0，说明深度无穷大
            if D == 0.0:
                Z = float("inf")
            else:
                Z = (B * f) / D 
            depth[r][c] = Z
    return depth

def show(img, title):
    plt.imshow(img)
    plt.title(title)
    plt.colorbar(fraction=0.05, pad=0.05)
    plt.savefig(title + ".png")
    plt.show()
    return

if __name__ == "__main__":
    disparity = getDisparity()
    depth = getDepth(disparity)
    show(disparity, "disparity")
    show(depth, "depth")