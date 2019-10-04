

executor_lifecycle.png: executor_lifecycle.dot
	cat $< | sudo docker run --rm -i vladgolubev/dot2png > $@
