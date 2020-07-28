#!/usr/bin/env bash


FILES="./copyright/*"
# try using parallel

mkdir -p trainingOutput

# trap 'kill $(jobs -p)' SIGINT SIGTERM EXIT

trainOnStyle() {
	file=$1
        filename=$(basename -- "$file")
        extension="${filename##*.}"
        filename="${filename%.*}"
        echo "Starting Training Process for ${file}"
        echo "stdbuf -o 0 python3 train.py --dataset_path train2014 \
			 --style_image $file \
			 --epochs 1 \
			 --batch_size 4 \
			 --image_size 256 \
			 --style_size 512 \
			 --lambda_content 1e5 \
			 --lambda_style 2e10 \
			 --lr 5e-4 \
			 --checkpoint_interval 2000 \
			 --sample_interval 1000 &> trainingOutput/${filename}_output.txt"

	stdbuf -o 0 python3 train.py --dataset_path train2014 \
			 --style_image $file \
			 --epochs 1 \
			 --batch_size 4 \
			 --image_size 256 \
			 --style_size 512 \
			 --lambda_content 1e5 \
			 --lambda_style 2e10 \
			 --lr 5e-4 \
			 --checkpoint_interval 2000 \
			 --sample_interval 1000 &> "trainingOutput/${filename}_output.txt"

                 # --checkpoint_model
	mv $file processedStyles
}

export -f trainOnStyle

echo "Starting parallel processing"
parallel --joblog trainingOutput/parallel.log -j2 -u trainOnStyle {} ::: $FILES

