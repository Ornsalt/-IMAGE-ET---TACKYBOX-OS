#########################################
## PROJECT      : Tack-Os - Image Et   ##
## DATE         : 2023                 ##
## ENVIRONEMENT : Unix                 ##
## DEPENDENCIES : Docker               ##
## AUTHOR       : MONFORT Clément      ##
##                AUGER   Clément      ##
#########################################

######################
## PARSING VARIABLE ##
######################

## Name and Path of the executable/project
FILE	= docker-compose.yml
APP		= $(shell basename $(shell pwd))
LOG		= $(APP).log

########################
## ARGUMENTS VARIABLE ##
########################

## App varaible
SOURCE	= $(shell sed -nr "/^\[$(APP)\]/ { :l /^sSource[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))
TARGET	= $(shell sed -nr "/^\[$(APP)\]/ { :l /^sTarget[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))
IMAGE	= $(shell sed -nr "/^\[$(APP)\]/ { :l /^sImage[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))
NAME	= $(shell sed -nr "/^\[$(APP)\]/ { :l /^sName[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))
ROOT	= $(shell sed -nr "/^\[$(APP)\]/ { :l /^sRoot[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))
PORT	= $(shell sed -nr "/^\[$(APP)\]/ { :l /^iPort[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))
USR		= $(shell sed -nr "/^\[$(APP)\]/ { :l /^sUser[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))
PWD		= $(shell sed -nr "/^\[$(APP)\]/ { :l /^sPWD[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))

######################
## MAKEFILE VARIABLE #
######################
MAKEFLAGS	+= --no-print-directory

###################
## MAKEFILE RULES #
###################
.PHONY: clean compose
.DEFAULT_TARGET: compose

clean:
	@echo "🧹 Killer Clean !"
	@-docker rm -f $(NAME) > /dev/null 2> $(LOG)
	@-docker volume rm -f mysql-data > /dev/null 2> $(LOG)
	@-rmdir -r $(patsubst "%",%,$(SOURCE)) > /dev/null 2> $(LOG)

compose:
	@mkdir -p $(patsubst "%",%,$(SOURCE)) > /dev/null 2> $(LOG)
	@docker volume create --name=mysql-data > /dev/null 2> $(LOG)
	@echo "🔮 \033[1m$(APP) docker-volume generated\033[0m"
	
	@echo "services:" > $(FILE)
	@echo "    $(NAME):" >> $(FILE)
	@echo "        image: $(IMAGE)" >> $(FILE)
	@echo "        restart: always" >> $(FILE)
	@echo "        container_name: $(NAME)" >> $(FILE)
	@echo "        environment:" >> $(FILE)
	@echo "            MYSQL_DATABASE: $(NAME)" >> $(FILE)
	@echo "            MYSQL_USER: $(USR)" >> $(FILE)
	@echo "            MYSQL_PASSWORD: $(PWD)" >> $(FILE)
	@echo "            MYSQL_ROOT_PASSWORD: $(ROOT)" >> $(FILE)
	@echo "        ports:" >> $(FILE)
	@echo "            - 3306:$(PORT)" >> $(FILE)
	@echo "        volumes:" >> $(FILE)
	@echo "            - mysql-data:/var/lib/mysql" >> $(FILE)

	@echo "volumes:\n    mysql-data:\n        external: true" >> $(FILE)
	@echo "🔮 \033[1m$(APP) $(FILE) generated\033[0m"

	@docker compose up -d > /dev/null 2> $(LOG)
	@-docker exec -i $(NAME) mysql -u imageet -ptkb_image_et < ./src/tackybox.sql > /dev/null 2> $(LOG)
	@echo "🔮 \033[1m$(NAME) container generated\033[0m"
