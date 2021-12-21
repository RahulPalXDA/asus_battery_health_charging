#!/bin/bash

function LOAD_COLORS() {
	NONE='\033[00m'
	RED='\033[01;31m'
	GREEN='\033[01;32m'
	PURPLE='\033[01;35m'
	BLUE='\033[01;36m'
	BOLD='\033[1m'
}
function LOAD_VARS(){
	ACTIVE="-->[Active]"
	BALANCED="\t[2] Balanced Mode."
	BALANCED_INFO="\tStops charging when power is above 80% Charges again when Power is\n\tbelow it. This mode is suitable for meetings & confereces when\n\tusing your notebook on Battery power\n"
	FULL="\t[1] Full Capacity Mode."
	FULL_INFO="\tCharges to full capacity for loger use of your notebook on battery.\n"
	INVALID="OOPS! Invalid Input. Please try again."
	MAXIMUM_LIFESPAN="\t[3] Maximum Lifespan Mode."
	MAXIMUM_LIFESPAN_INFO="\tStops charging when power is above 60% Charges again when Power is\n\tbelow it. This mode is suitable for when your notebook is always\n\towerd by it's AC adapter.\n"
	LIMIT=$(cat /sys/class/power_supply/BAT?/charge_control_end_threshold)
	SYSTEMD_DIR=/etc/systemd
}
function HEADER() {
        echo -e ""
        echo -e "${BOLD}${PURPLE}\t🔋 ASUS Battery Health Charging${NONE}"
        echo -e "\tWhen your notebook is always powerd by it's AC adapter,\n\tSet to a low power settings (around 60% or 80%) to extend the battery life."
        echo -e ""
}
function MAIN() {
	if [ $LIMIT -eq 100 ]; then
		echo -e "$RED $FULL $PURPLE $ACTIVE $NONE"
		echo -e "$FULL_INFO"
	else
		echo -e "$RED $FULL $PURPLE $NONE"
		echo -e "$FULL_INFO"
	fi
	if [ $LIMIT -eq 80 ]; then
		echo -e "$BLUE $BALANCED $PURPLE $ACTIVE $NONE"
		echo -e "$BALANCED_INFO"
	else
		echo -e	"$BLUE $BALANCED $PURPLE $NONE"
		echo -e "$BALANCED_INFO"
	fi
	if [ $LIMIT -eq 60 ]; then
		echo -e "$GREEN $MAXIMUM_LIFESPAN $PURPLE $ACTIVE $NONE"
		echo -e "$MAXIMUM_LIFESPAN_INFO"
	else
		echo -e	"$GREEN $MAXIMUM_LIFESPAN $PURPLE $NONE"
		echo -e "$MAXIMUM_LIFESPAN_INFO"
	fi
}
function SET_THRESHOLD() {
	if [[ -f "/etc/systemd/system/Battery-Health-Charging.service" ]]; then
		sudo systemctl stop Battery-Health-Charging.service
		sudo systemctl disable enable Battery-Health-Charging.service
		sudo rm -rf /etc/systemd/system/Battery-Health-Charging.service
	fi
	if [[ -d "$SYSTEMD_DIR" ]]; then
		echo $MODE | sudo tee /sys/class/power_supply/BAT?/charge_control_end_threshold >> /dev/null
		echo "[Unit]
		Description=ASUS Battery Health Charging
		After=multi-user.target
		StartLimitBurst=0

		[Service]
		Type=oneshot
		Restart=on-failure
		ExecStart=/bin/bash -c 'echo $MODE | sudo tee /sys/class/power_supply/BAT?/charge_control_end_threshold'

		[Install]
		WantedBy=multi-user.target" >> Battery-Health-Charging
		sed 's/		//' Battery-Health-Charging >> Battery-Health-Charging.service
		sudo rm -rf Battery-Health-Charging
		sudo mv Battery-Health-Charging.service /etc/systemd/system/Battery-Health-Charging.service
		sudo systemctl enable Battery-Health-Charging.service
	else
		echo $MODE | sudo tee /sys/class/power_supply/BAT?/charge_control_end_threshold >> /dev/null
	fi
}
function SET_MODE() {
	if [ "$input" -eq 1 ]; then
		echo -e "\nSetting$RED$FULL$NONE"
		MODE=100
		SET_THRESHOLD
		REFREASH
	elif [ "$input" -eq 2 ]; then
		echo -e "\nSetting$BLUE$BALANCED$NONE"
		MODE=80
		SET_THRESHOLD
		REFREASH
	elif [ "$input" -eq 3 ]; then
		echo -e "\nSetting$GREEN$MAXIMUM_LIFESPAN$NONE"
		MODE=60
		SET_THRESHOLD
		REFREASH
	elif [ "$input" -eq 0 ]; then
		echo ""
		exit 0
	else
		echo ""
		echo "$INVALID"
		USER_CHOICE
	fi
}
function USER_CHOICE() {
	read -n1 -p "Enter Your Choice (1/2/3 or 0 to quit): " input
	  if [[ $input ]] && [ $input -eq $input 2>/dev/null ]; then
		SET_MODE
	else
		echo ""
    	echo "$INVALID"
    	USER_CHOICE
	fi
}
function REFREASH() {
	clear
	LOAD_COLORS
	LOAD_VARS
	HEADER
	MAIN
	USER_CHOICE
}
REFREASH
