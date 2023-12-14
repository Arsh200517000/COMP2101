#!/bin/bash

#Task:1
num_sides=6
range=$((1 + num_sides))
base=1

die1=$((base + RANDOM % range))
die2=$((base + RANDOM % range))


sum=$((die1 + die2))
average=$((sum / 2))

echo "rolling the dice..."
echo "die 1: $die1"
echo "die 2: $die2"
echo "total: $sum"
echo "average: $average"
