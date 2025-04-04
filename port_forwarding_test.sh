#!/bin/bash

# Ports to Send (s) and Listen (l) to
s_udp_ports=(500 4500 1701)
s_tcp_ports=(443 8080)
l_udp_ports=(500 4500 1701)
l_tcp_ports=(443 8080)

# Check if commands are installed
function check_commands() {
        if ! command -v tcpdump 2>&1 > /dev/null; then
                echo "TCPDump Must Be Installed to Listen for Traffic"
                exit 1
        fi

        if ! command -v nc 2>&1 > /dev/null; then
                echo "Netcat Must Be Installed to Send Test Traffic"
                exit 1
        fi
}

# UDP Send Test
function send_udp_ports() {
    for p in "${s_udp_ports[@]}"; do
        echo "Testing UDP port $ip_address $p"
        nc -u -w 1 "$ip_address" "$p" <<<"Hello"
    done
}

# TCP Send Test
function send_tcp_ports() {
    for p in "${s_tcp_ports[@]}"; do
        echo "Testing TCP port $ip_address $p"
        nc -w 1 "$ip_address" "$p" <<<"Hello"
    done
}

# UDP Listen
function listen_udp_ports() {
    local port_test_string=""

    if [ "${#l_udp_ports[@]}" -eq 0 ]; then
        echo "Must have ports defined"
        exit 1
    fi

    for ((i = 0; i < ${#l_udp_ports[@]}; i++)); do
        port_test_string+="${l_udp_ports[$i]}"
        if [ $i -lt $((${#l_udp_ports[@]} - 1)) ]; then
            port_test_string+=" or "
        fi
    done

    echo "UDP Listening on: $port_test_string"
    sudo tcpdump -i any udp dst port "$port_test_string" -XX -nn
}

# TCP Listen
function listen_tcp_ports() {
    local port_test_string=""

    if [ "${#l_tcp_ports[@]}" -eq 0 ]; then
        echo "Must have ports defined"
        exit 1
    fi

    for ((i = 0; i < ${#l_tcp_ports[@]}; i++)); do
        port_test_string+="${l_tcp_ports[$i]}"
        if [ $i -lt $((${#l_tcp_ports[@]} - 1)) ]; then
            port_test_string+=" or "
        fi
    done

    echo "TCP Listening on: $port_test_string"
    sudo tcpdump -i any dst port "$port_test_string" -XX -nn
}

# Get IP Address
function get_target_info() {
        read -p "Enter an IP Address: " ip_address
        if [[ ! "$ip_address" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
                echo "IP Address format Invalid."
                get_target_info
        fi
}

# Display Menu
function menu() {
    should_show_menu=true
    while [ "$should_show_menu" = true ]; do
        echo ""
        echo "1. Test TCP Ports"
        echo "2. Test UDP Ports"
        echo "3. Listen for TCP Traffic"
        echo "4. Listen for UDP Traffic"
        echo "5. Quit"
        read -p "Enter a menu option: " menu_choice
        case $menu_choice in
            1)
                echo "Testing TCP Ports"
                send_tcp_ports
                ;;
            2)
                echo "Testing UDP Ports"
                send_udp_ports
                ;;
            3)
                echo "Listening for TCP Traffic"
                listen_tcp_ports
                ;;
            4)
                echo "Listening for UDP Traffic"
                listen_udp_ports
                ;;
            5)
                echo "Exiting"
                should_show_menu=false
                ;;
            *)
                echo "Not a valid entry"
                ;;
        esac
    done
}

# Run
check_commands
get_target_info
menu
