#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "complex.cpp"
#include <fstream>
#include <iostream>
#define vptr (void **)

struct Point
{
    float x;
    float y;
    __device__ Point(float x, float y)
    {
        this->x = x;
        this->y = y;
    }
    __device__ Point()
    {
        this->x = 0;
        this->y = 0;
    }
};

__device__ Point LinearInterpolation(int x, int y, int width, int height, Point p1, Point p2)
{
    Point result;
    result.x = p1.x + ((p2.x - p1.x) / width) * x;
    result.y = p1.y + ((p2.y - p1.y) / height) * y;
    return result;
}

__device__ int mandel(Complex c, int maxIter)
{
    Complex z(0, 0);
    int i = 0;
    while (i < maxIter)
    {
        z = z * z + c;
        if (z.real * z.real + z.imag * z.imag > 4.0)
        {
            break;
        }
        i++;
    }
    return i;
}

__global__ void kernel(unsigned int *image_d, const unsigned int width, const unsigned int height)
{
    int idx = blockDim.x * blockIdx.x + threadIdx.x;
    int idy = blockDim.y * blockIdx.y + threadIdx.y;

    Point p1(-2, 2);
    Point p2(2, -2);

    if (idx < width && idy < height)
    {
        Point p = LinearInterpolation(idx, idy, width, height, p1, p2);
        image_d[idy * width + idx] = mandel(Complex(p.x, p.y), 100);
    }
}

void mandelbrot_gpu(unsigned int *image, const unsigned int width, const unsigned int height)
{
    unsigned int *image_d;
    cudaMalloc(vptr(&image_d), sizeof(unsigned int) * width * height);

    dim3 noOfThreads(32, 32);
    dim3 noOfblocks((width + noOfThreads.x - 1) / noOfThreads.x, (height + noOfThreads.y - 1) / noOfThreads.y);
    kernel<<<noOfblocks, noOfThreads>>>(image_d, width, height);
    cudaMemcpy(image, image_d, sizeof(unsigned int) * width * height, cudaMemcpyDeviceToHost);
    cudaFree(image_d);
}

int main()
{
    unsigned int width = 10500;
    unsigned int height = 10500;

    unsigned int *image = new unsigned int[width * height];

    mandelbrot_gpu(image, width, height);

    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            if (image[i * width + j] > 90)
            {
                std::cout << "@";
            }
            else if (image[i * width + j] > 80)
            {
                std::cout << "#";
            }
            else if (image[i * width + j] > 50)
            {
                std::cout << "%";
            }
            else if(image[i*width+j]>10){
                std::cout<<".";
            }
            else
            {
                std::cout << " ";
            }
            // std::cout<<image[i*width+j]<<" ";
        }
        std::cout << "\n";
    }

    delete[] image;
}