DATA_DIR	=	./memo_data
PUBLIC_DIR	=	./public
STYLESHEET	= stylesheet.css
GEM	=	./Gemfile.lock

wake_up	:	$(GEM) $(DATA_DIR) $(PUBLIC_DIR)
	ruby myapp.rb

$(GEM)	: 
	bundler install

$(DATA_DIR)	:
	mkdir $(DATA_DIR)

$(PUBLIC_DIR)	:
	mkdir $(PUBLIC_DIR)
	cp $(STYLESHEET) $(PUBLIC_DIR)/stylesheet.css
