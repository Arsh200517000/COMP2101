#!/bin/bash
#task 1 improve the script
# count the number of files in picture directory
file_count=$(find ~/public_html/pics -type f | wc -l)

#calculate the disk space used by picture directory
disk_space=$(du -sh ~/public_html/pics | cut -f1)

#display the summery
echo "Found $file_count files in the picture directory."
echo "The pictures directory used $disk_space space on the disk."

#task 2
pictures_dir=~/public_html/pics

if [ ! -d "$pictures_dir" ]; then
    echo "Creating $pictures_dir directory..."
    mkdir -p "$pictures_dir"
fi

