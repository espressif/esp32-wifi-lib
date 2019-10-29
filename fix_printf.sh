#!/bin/bash
for dir in esp32 esp32s2beta; do
    if [ -d "$dir" ]; then
        cd $dir
        if [ $dir == esp32 ]; then
            xtensa-esp32-elf-objcopy --redefine-sym ets_printf=phy_printf libphy.a 
        elif [ $dir == esp32s2beta ]; then
            xtensa-esp32-elf-objcopy --redefine-sym ets_printf=phy_printf libphyA.a
            xtensa-esp32-elf-objcopy --redefine-sym ets_printf=phy_printf libphyB.a
            xtensa-esp32-elf-objcopy --redefine-sym ets_printf=phy_printf libphy_marlin3.a
        fi
        xtensa-esp32-elf-objcopy --redefine-sym ets_printf=rtc_printf librtc.a 
        xtensa-esp32-elf-objcopy --redefine-sym printf=sc_printf libsmartconfig.a 
        xtensa-esp32-elf-objcopy --redefine-sym printf=pp_printf libpp.a 
        xtensa-esp32-elf-objcopy --redefine-sym printf=net80211_printf libnet80211.a 
        xtensa-esp32-elf-objcopy --redefine-sym printf=core_printf libcore.a 
        xtensa-esp32-elf-objcopy --redefine-sym ets_printf=core_printf libcore.a 
        xtensa-esp32-elf-objcopy --redefine-sym ets_printf=coexist_printf libcoexist.a
        xtensa-esp32-elf-objcopy --redefine-sym printf=coexist_printf libcoexist.a
        cd ..
    else
        echo "$dir does not exist"
    fi
done;
