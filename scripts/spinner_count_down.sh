count_down () {
    sp="/-\|"

    down_from=${down_from:-5}
    out_msg=${out_msg:-"Done."}
    sleep_length=${sleep_length:-1}
    spin_or_num=${spin_or_num:-"spin"}

    while [[ $down_from -ne 0 ]] ; do
        echo -e "\033[1D\033[1A"
        if [[ $spin_or_num = "spin" ]] ; then
            echo -e "\033[K${sp:i++%${#sp}:1}"
        else
            echo -e "\033[K$down_from"
        fi
        echo -e "\033[2A"
        sleep $sleep_length
        down_from=$(( $down_from-1 ))
    done

    echo "$out_msg"
}

down_from=10 sleep_length=0.2 count_down
