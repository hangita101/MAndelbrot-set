#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <iostream>
#include <string>

#define HD __host__ __device__

class Complex
{
public:
    float real;
    float imag;

    // Constructor with initialization list
    HD Complex(float real, float imag) : real(real), imag(imag) {}

    // Overloaded operators
    HD Complex operator+(const Complex &b) const
    {
        return Complex(this->real + b.real, this->imag + b.imag);
    }

    HD Complex operator-(const Complex &b) const
    {
        return Complex(this->real - b.real, this->imag - b.imag);
    }

    HD Complex operator*(const Complex &b) const
    {
        return Complex(this->real * b.real - this->imag * b.imag,
                       this->real * b.imag + this->imag * b.real);
    }

    HD Complex operator/(float d) const
    {
        return Complex(this->real / d, this->imag / d);
    }

    HD Complex operator*(float d) const
    {
        return Complex(this->real * d, this->imag * d);
    }

    friend std::ostream &operator<<(std::ostream &os, const Complex &p)
    {
        os << p.real << " + " << p.imag << " i";
        return os;
    }
};
