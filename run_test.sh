models="blurflower cuphead flower japan spiral starry_night gear jerry mosaic psycwolf spiral the_wave"

for model in $models; do

	python3 test_on_image.py --image_path images/content/zurich.jpeg \
			 --checkpoint_model checkpoints/${model}_20000.pth
done
