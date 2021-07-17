COLOR_GREEN=\033[032m
COLOR_RED=\033[0;31m
COLOR_RESET=\033[0m


install:
	rm -rf $${HOME}/.hammerspoon/*
	cp -R .hammerspoon/. $${HOME}/.hammerspoon/
	@echo "${COLOR_GREEN}Installation succeeded. Please reload hammerspoon config.${COLOR_RESET}"

archive:
	rm -rf .hammerspoon
	cp -R $${HOME}/.hammerspoon .
	@echo "${COLOR_GREEN}Archive done. You can make a Git commit now.${COLOR_RESET}"
