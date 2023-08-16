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
AET		= $(shell sed -nr "/^\[$(APP)\]/ { :l /^sAET[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))

## DBMS / Global variable
SOURCE	= $(shell sed -nr "/^\[DBMS\]/ { :l /^sSource[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))
TARGET	= $(shell sed -nr "/^\[DBMS\]/ { :l /^sTarget[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))
NAME	= $(shell sed -nr "/^\[DBMS\]/ { :l /^sName[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))
PORT	= $(shell sed -nr "/^\[DBMS\]/ { :l /^iPort[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" $(INI))
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
	@echo "    aeclient:" >> $(FILE)
	@echo "        image: $(IMAGE)" >> $(FILE)
	@echo "        restart: on-failure:always" >> $(FILE)
	@echo "        container_name: $(APP)" >> $(FILE)
	@echo "        volumes:" >> $(FILE)
	@echo "            - type: bind" >> $(FILE)
	@echo "              source: $(SOURCE)" >> $(FILE)
	@echo "              target: $(TARGET)" >> $(FILE)
	@echo "        environment:" >> $(FILE)
	@echo "            - PYTHONUNBUFFERED=1" >> $(FILE)
	@echo "            - TACKYBOX=$(AET)" >> $(FILE)
	@echo "            - PORT_SQL=$(PORT)" >> $(FILE)
	@echo "            - CRONTAB=5" >> $(FILE)
	@echo "            - DEST=$(DEST)" >> $(FILE)
	@echo "            - SQL=$(USR):$(PWD)@$(IP):$(NAME)" >> $(FILE)
	
	@echo "volumes:\n    mysql-data:\n        external: true" >> $(FILE)
	
	@echo "🔮 \033[1m$(APP) $(FILE) generated\033[0m"
	@docker compose up -d
