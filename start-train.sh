#!/usr/bin/env bash

FILES="./popularPresetImages/*"
# try using parallel

mkdir -p trainingOutput

# trap 'kill $(jobs -p)' SIGINT SIGTERM EXIT

batch_count=0
for file in $FILES; do
        filename=$(basename -- "$file")
        extension="${filename##*.}"
        filename="${filename%.*}"
        echo "Starting Training Process for ${file}"
        echo "stdbuf -o 0 python3 train.py --dataset_path train2014 \
			 --style_image $file \
			 --epochs 1 \
			 --batch_size 8 \
			 --image_size 256 \
			 --style_size 512 \
			 --lambda_content 1e5 \
			 --lambda_style 1e10 \
			 --lr 1e-3 \
			 --checkpoint_interval 2000 \
			 --sample_interval 1000 &> trainingOutput/${filename}_output.txt &"

	stdbuf -o 0 python3 train.py --dataset_path train2014 \
			 --style_image $file \
			 --epochs 1 \
			 --batch_size 8 \
			 --image_size 256 \
			 --style_size 512 \
			 --lambda_content 1e5 \
			 --lambda_style 1e10 \
			 --lr 1e-3 \
			 --checkpoint_interval 2000 \
			 --sample_interval 1000 &> trainingOutput/${filename}_output.txt &

	# Increment batch count
        ((batch_count=batch_count+1))
        echo "Batch count: $batch_count" 
	# If batch_count equals 2, wait for processes to end and then reset batch_count
        [[ batch_count -eq 2 ]] && echo "Waiting for training to complete" && wait && batch_count=0
done


                 
                 # --checkpoint_model


