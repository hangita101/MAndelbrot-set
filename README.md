# Mandelbrot set In Cuda

An simple Implementation of Mandelbrot-set in CUDA and Python for visualization


## How to run:

1. Compile the  `kernel.cu` file using NVCC compiler
```
nvcc kernel.cu -o Set
```
2. Run like this

```
./Set > save.txt
```

3. Run the pyton script

```
python TxtToJpg.py
```

It will generate an `output_image.jpg` image file

<hr>
![output](output_image.jpg)
