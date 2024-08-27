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
    ["Cexio-Tap-bot"]="1"
    ["HamsterKombatBot"]="2"
    ["TapSwapBot"]="2"
    ["MemeFiBot"]="2"
    ["PocketFiBot"]="2"
    ["MMProBumpBot"]="2"
    ["ClaytonBOT"]="2"
    ["BlumBot"]="2"
    ["WormSlapBot"]="2"
    ["YesCoinBot"]="2"
    ["HEXACOREbot"]="1"
    ["MajorBot"]="1"
    ["Tomarket"]="1"
    # ["Seed-App-Mine-Seed-BOT-Telegram"]="1"
)

declare -A repos=(
    ["PixelTapBot"]="https://github.com/AlexKrutoy/PixelTapBot.git"
    ["SnapsterBot"]="https://github.com/AlexKrutoy/SnapsterBot.git"
    ["CubesOnTheWater_Bot"]="https://github.com/AlexKrutoy/CubesOnTheWater_Bot.git"
    ["DiamoreCoBot"]="https://github.com/AlexKrutoy/DiamoreCoBot.git"
    ["Cexio-Tap-bot"]="https://github.com/vanhbakaa/Cexio-Tap-bot.git"
    ["HamsterKombatBot"]="https://github.com/shamhi/HamsterKombatBot.git"
    ["TapSwapBot"]="https://github.com/shamhi/TapSwapBot.git"
    ["MemeFiBot"]="https://github.com/shamhi/MemeFiBot.git"
    ["PocketFiBot"]="https://github.com/shamhi/PocketFiBot.git"
    ["MMProBumpBot"]="https://github.com/Alexell/MMProBumpBot.git"
    ["ClaytonBOT"]="https://github.com/Alexell/ClaytonBOT.git"
    ["BlumBot"]="https://github.com/Alexell/BlumBot.git"
    ["WormSlapBot"]="https://github.com/shamhi/WormSlapBot.git"
    ["YesCoinBot"]="https://github.com/shamhi/YesCoinBot.git"
    ["HEXACOREbot"]="https://github.com/HiddenCodeDevs/HEXACOREbot.git"
    ["MajorBot"]="https://github.com/GravelFire/MajorBot.git"
    ["Tomarket"]="https://github.com/GravelFire/Tomarket.git"
    # ["Seed-App-Mine-Seed-BOT-Telegram"]="https://github.com/vanhbakaa/Seed-App-Mine-Seed-BOT-Telegram.git"
)

limits=(
    "Cexio-Tap-bot"
    "MemeFiBot"
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

            backup_dir="/root/TapperBackup/$bot"
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
    5)
        echo -e "${red}Combining...${rest}"
        src_bot="HamsterKombatBot"
        if [ -d "$src_bot/sessions" ]; then
            for bot in "${!bots[@]}"; do
                if [[ " ${limits[@]} " =~ " ${bot} " ]]; then
                    read -p "Bot ${bot} has a limit for sessions. Do you want to skip this bot? (y/N): " skip_choice
                    skip_choice=${skip_choice,,}

                    if [ "$skip_choice" = "y" ]; then
                        echo -e "${purple}Skipping ${bot}.${rest}"
                        continue
                    fi
                fi
                cp -r "$src_bot/sessions/"* "$bot/sessions/"
            done
        else
            echo -e "${red}No sessions found in ${src_bot}${rest}"
        fi
        echo -e "${green}Combine successfully${rest}"
        ;;
    6)
        echo -e "${red}Creating backups...${rest}"
        for bot in "${!bots[@]}"; do
            backup_dir="/root/TapperBackup/$bot"
            mkdir -p "$backup_dir"
            cd "$bot" || exit 1

            if [ -d "sessions" ]; then
                cp -r "sessions" "$backup_dir"
            fi
            if [ -f ".env" ]; then
                cp ".env" "$backup_dir"
            fi

            cd - >/dev/null || exit 1
        done
        echo -e "${green}Backup created successfully${rest}"
        ;;
    7)
        echo -e "${red}Pasting backups...${rest}"
        for bot in "${!bots[@]}"; do
            backup_dir="/root/TapperBackup/$bot"
            cd "$bot" || exit 1

            if [ -d "$backup_dir/sessions" ]; then
                cp -r "$backup_dir/sessions/"* "sessions/"
            fi

            if [ -f "$backup_dir/.env" ]; then
                cp "$backup_dir/.env" .
            fi
            cd - >/dev/null || exit 1
        done
        echo -e "${green}Backup pasted successfully${rest}"
        ;;
    0)
        echo -e "${purple}Exiting...${rest}"
        exit 0
        ;;
    *)
        echo -e "${red}Invalid choice. Please enter '1', '2', '3', '4', '5', '6', '7' or '0'.${rest}"
        exit 1
        ;;
    esac
}

# Main script
clear

if [ "$EUID" -ne 0 ]; then
    echo -e "${red}This script requires root access. please run as root.${rest}"
    exit 1
fi

read -p "Are you sure that you enter this command in the root directory? (y/N): " root_choice
root_choice=${root_choice,,}

if [ "$root_choice" = "n" ]; then
    exit 1
fi

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
echo -e "${green}5) Combine all sessions together${rest}"
echo -e "${green}6) Create backup${rest}"
echo -e "${green}7) Paste backup${rest}"
echo -e "${red}0) Exit${rest}"
read -p "Please choose: " action_choice

perform_operation "$action_choice"
