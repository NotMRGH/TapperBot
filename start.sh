#!/bin/bash

# Define colors
color='\033[0;'

red="${color}31m"
green="${color}32m"
yellow="${color}33m"
blue="${color}34m"
purple="${color}35m"
cyan="${color}36m"
rest='\033[0m'

# Associative arrays for bots and repositories
declare -A bots=(
    ["PixelTapBot"]="1"
    ["SnapsterBot"]="1"
    ["CubesOnTheWater_Bot"]="1"
    ["DiamoreCoBot"]="1"
    ["CEX.IO-bot"]="1"
    ["HamsterKombatBot"]="2"
    ["TapSwapBot"]="2"
    ["MemeFiBot"]="2"
    ["PocketFiBot"]="2"
    ["MMProBumpBot"]="2"
    ["ClaytonBOT"]="2"
    ["telegram-blum-auto"]="1"
    ["WormSlapBot"]="2"
    ["YesCoinBot"]="2"
)

declare -A repos=(
    ["PixelTapBot"]="https://github.com/AlexKrutoy/PixelTapBot.git"
    ["SnapsterBot"]="https://github.com/AlexKrutoy/SnapsterBot.git"
    ["CubesOnTheWater_Bot"]="https://github.com/AlexKrutoy/CubesOnTheWater_Bot.git"
    ["DiamoreCoBot"]="https://github.com/AlexKrutoy/DiamoreCoBot.git"
    ["CEX.IO-bot"]="https://github.com/AlexKrutoy/CEX.IO-bot.git"
    ["HamsterKombatBot"]="https://github.com/shamhi/HamsterKombatBot.git"
    ["TapSwapBot"]="https://github.com/shamhi/TapSwapBot.git"
    ["MemeFiBot"]="https://github.com/shamhi/MemeFiBot.git"
    ["PocketFiBot"]="https://github.com/shamhi/PocketFiBot.git"
    ["MMProBumpBot"]="https://github.com/Alexell/MMProBumpBot.git"
    ["ClaytonBOT"]="https://github.com/doubleTroub1e/ClaytonBOT.git"
    ["telegram-blum-auto"]="https://gitlab.com/D4rkKaizen/telegram-blum-auto.git"
    ["WormSlapBot"]="https://github.com/shamhi/WormSlapBot.git"
    ["YesCoinBot"]="https://github.com/shamhi/YesCoinBot.git"
)

# Function to handle common operations
perform_operation() {
    action_choice=$1

    case $action_choice in
    1)
        echo -e "${green}Starting bots...${rest}"
        for bot in "${!bots[@]}"; do
            cd "$bot" || {
                echo -e "${red}${bot} not found${rest}"
                continue
            }
            screen -dmS "$bot" bash -c "source venv/bin/activate && python3 main.py -a ${bots[$bot]}"
            cd - >/dev/null || exit 1
        done
        ;;
    2)
        echo -e "${red}Stopping bots...${rest}"
        for bot in "${!bots[@]}"; do
            screen -S "$bot" -X quit
        done
        ;;
    3)
        echo -e "${yellow}Installing/updating bots...${rest}"
        for bot in "${!bots[@]}"; do
            read -p "Do you want to skip ${bot}? (y/N): " skip_choice
            skip_choice=${skip_choice,,}

            if [ "$skip_choice" = "y" ]; then
                echo -e "${purple}Skipping ${bot}.${rest}"
                continue
            fi

            backup_dir="~/TapperBackup/$bot"
            mkdir -p "$backup_dir"

            if [ -d "$bot/sessions" ]; then
                cp -r "$bot/sessions" "$backup_dir"
            fi
            if [ -f "$bot/.env" ]; then
                cp "$bot/.env" "$backup_dir"
            fi

            rm -rf "$bot"
            git clone "${repos[$bot]}"
            cd "$bot" || exit 1

            python3.10 -m venv venv
            source venv/bin/activate
            python3.10 -m pip install -r requirements.txt
            cp .env-example .env

            if [ -d "$backup_dir/sessions" ]; then
                cp -r "$backup_dir/sessions" .
            fi
            if [ -f "$backup_dir/.env" ]; then
                cp "$backup_dir/.env" .
            fi

            cd - >/dev/null || exit 1
        done
        echo -e "${green}The installation/update was successful${rest}"
        ;;
    4)
        echo -e "${red}Removing backups...${rest}"
        rm -rf "TapperBackup"
        echo -e "${green}Backup deleted successfully${rest}"
        ;;
    0)
        echo -e "${purple}Exiting...${rest}"
        exit 0
        ;;
    *)
        echo -e "${red}Invalid choice. Please enter '1', '2', '3', '4' or '0'.${rest}"
        exit 1
        ;;
    esac
}

# Main script
clear
echo "
 /\$\$\$\$\$\$\$\$                                                      /\$\$\$\$\$\$\$              /\$\$    
|__  \$\$__/                                                     | \$\$__  \$\$            | \$\$    
   | \$\$  /\$\$\$\$\$\$   /\$\$\$\$\$\$   /\$\$\$\$\$\$   /\$\$\$\$\$\$   /\$\$\$\$\$\$       | \$\$  \ \$\$  /\$\$\$\$\$\$  /\$\$\$\$\$\$  
   | \$\$ |____  \$\$ /\$\$__  \$\$ /\$\$__  \$\$ /\$\$__  \$\$ /\$\$__  \$\$      | \$\$\$\$\$\$\$  /\$\$__  \$\$|_  \$\$_/  
   | \$\$  /\$\$\$\$\$\$\$| \$\$  \ \$\$| \$\$  \ \$\$| \$\$\$\$\$\$\$\$| \$\$  \__/      | \$\$__  \$\$| \$\$  \ \$\$  | \$\$    
   | \$\$ /\$\$__  \$\$| \$\$  | \$\$| \$\$  | \$\$| \$\$_____/| \$\$            | \$\$  \ \$\$| \$\$  | \$\$  | \$\$ /\$\$
   | \$\$|  \$\$\$\$\$\$\$| \$\$\$\$\$\$\$/| \$\$\$\$\$\$\$/|  \$\$\$\$\$\$\$| \$\$            | \$\$\$\$\$\$\$/|  \$\$\$\$\$\$/  |  \$\$\$\$/
   |__/ \_______/| \$\$____/ | \$\$____/  \_______/|__/            |_______/  \______/    \___/  
                 | \$\$      | \$\$                                                              
                 | \$\$      | \$\$                                                              
                 |__/      |__/                                                              


"
echo -e "${cyan}By --> NotMR_GH * Github.com/NotMRGH * ${rest}"
echo -e "${yellow}******************************${rest}"
echo -e " ${purple}--------#- Tapper Bot -#--------${rest}"
echo -e "${green}1) Start${rest}"
echo -e "${red}2) Stop${rest}"
echo -e "${green}3) Install/Update${rest}"
echo -e "${red}4) Remove backup${rest}"
echo -e "${red}0) Exit${rest}"
read -p "Please choose: " action_choice

perform_operation "$action_choice"
