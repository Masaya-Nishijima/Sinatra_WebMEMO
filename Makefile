DATA_DIR	= ./memo_data

install	: $(DATA_DIR)
	bundler install

$(DATA_DIR)	:
	mkdir $(DATA_DIR)
