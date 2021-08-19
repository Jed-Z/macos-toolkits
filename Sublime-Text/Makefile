COLOR_GREEN=\033[032m
COLOR_RED=\033[0;31m
COLOR_RESET=\033[0m

SUBLIME_SETTINGS_PATH = '$(HOME)/Library/Application Support/Sublime Text/Packages/User/'
SUBLIME_SETTINGS_FILE = Preferences.sublime-settings


install:
	cp $(SUBLIME_SETTINGS_FILE) $(SUBLIME_SETTINGS_PATH)
	@echo "${COLOR_GREEN}Installation succeeded.${COLOR_RESET}"

archive:
	cp $(SUBLIME_SETTINGS_PATH)/$(SUBLIME_SETTINGS_FILE) .
	@echo "${COLOR_GREEN}Archive done. You can make a Git commit now.${COLOR_RESET}"
