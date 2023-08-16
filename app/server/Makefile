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
IMAGE	= $(shell sed -nr "/^\[$(APP)\]/ { :l /^sImage[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))
DEST	= $(shell sed -nr "/^\[$(APP)\]/ { :l /^sDest[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))

## DBMS / Global variable
SOURCE	= $(shell sed -nr "/^\[DBMS\]/ { :l /^sSource[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))
TARGET	= $(shell sed -nr "/^\[DBMS\]/ { :l /^sTarget[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))
NAME	= $(shell sed -nr "/^\[DBMS\]/ { :l /^sName[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))
USR		= $(shell sed -nr "/^\[DBMS\]/ { :l /^sUser[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))
PWD		= $(shell sed -nr "/^\[DBMS\]/ { :l /^sPWD[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))
IP		= $(shell sed -nr "/^\[GLOBAL\]/ { :l /^sIP[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))

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
	@-docker rm -f $(APP) > /dev/null 2> $(LOG)

compose:
	@echo "services:" > $(FILE)
	@echo "    aeserver:" >> $(FILE)
	@echo "        image: $(IMAGE)" >> $(FILE)
	@echo "        restart: on-failure:1" >> $(FILE)
	@echo "        container_name: $(APP)" >> $(FILE)
	@echo "        ports:" >> $(FILE)
	@echo "            - 11113:11113" >> $(FILE)
	@echo "        volumes:" >> $(FILE)
	@echo "            - type: bind" >> $(FILE)
	@echo "              source: $(SOURCE)" >> $(FILE)
	@echo "              target: $(TARGET)" >> $(FILE)
	@echo "        depends_on:" >> $(FILE)
	@echo "            - $(NAME)" >> $(FILE)
	@echo "        environment:" >> $(FILE)
	@echo "            - PYTHONUNBUFFERED=1" >> $(FILE)
	@echo "            - TACKYBOX=$(AET)" >> $(FILE)
	@echo "            - SQL=$(USR):$(PWD)@$(IP):$(NAME)\n" >> $(FILE)

	@echo "    rsync_wrapper:" >> $(FILE)
	@echo "        image: $(subst aeserver,rsync,$(IMAGE))" >> $(FILE)
	@echo "        restart: on-failure:always" >> $(FILE)
	@echo "        container_name: wrapper" >> $(FILE)
	@echo "        volumes:" >> $(FILE)
	@echo "            - type: bind" >> $(FILE)
	@echo "              source: $(SOURCE)" >> $(FILE)
	@echo "              target: $(TARGET)" >> $(FILE)
	@echo "        depends_on:" >> $(FILE)
	@echo "            - $(NAME)" >> $(FILE)
	@echo "        environment:" >> $(FILE)
	@echo "            - PYTHONUNBUFFERED=1" >> $(FILE)
	@echo "            - DESTINATIONS=$(DEST)" >> $(FILE)
	@echo "            - MULTITHREAD=4" >> $(FILE)
	@echo "            - SAFETY=10000" >> $(FILE)
	@echo "            - SQL=$(USR):$(PWD)@$(IP):$(NAME)" >> $(FILE)
	
	@echo "volumes:\n    mysql-data:\n        external: true" >> $(FILE)
	
	@echo "🔮 \033[1m$(APP) $(FILE) generated\033[0m"
	@docker compose up -d
