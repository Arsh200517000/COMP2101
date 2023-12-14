#!/bin/bash

#task 1:
read -p "Enter the first number: " num1
read -p "Enter the second number: " num2
read -p "Enter the third number: " num3

#task2
sum=$((num1 + num2 + num3))
product=$((num1 * num2 * num3))


echo "Sum of the three number: $sum"
echo "Product of the three numbers: $product"

