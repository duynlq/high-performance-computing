#!/bin/bash

# downloads the plain text of guliver's travels from project gutenberg
wget -O gullivers_travels.txt https://www.gutenberg.org/files/829/829-0.txt

# calculate first five prime numbers
is_prime() {
    local num=$1
    if [[ $num -lt 2 ]]; then
        return 1
    fi
    for ((i = 2; i <= num / 2; i++)); do
        if [[ $((num % i)) -eq 0 ]]; then
            return 1
        fi
    done
    return 0
}

primes=()
num=2
while [[ ${#primes[@]} -lt 5 ]]; do
    if is_prime "$num"; then
        primes+=("$num")
    fi
    ((num++))
done

# create directories with prime numbers as names
for prime in "${primes[@]}"; do
    mkdir "$prime"
done

# split text and move to respective directories
total_lines=$(wc -l < gullivers_travels.txt)
lines_per_part=$((total_lines / 5))

split -l "$lines_per_part" gullivers_travels.txt part_

mv "part_aa" "2"
mv "part_ab" "3"
mv "part_ac" "5"
mv "part_ad" "7"
mv "part_ae" "11"


rm gullivers_travels.txt
rm part_af
# rm -r 2 3 5 7 11
