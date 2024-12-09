#!/bin/bash

# obtained using `pactl list sinks`
company_headset=alsa_output.usb-Microsoft_Microsoft_USB_Link_0V33BH4214200F-00.analog-stereo
wired_old=alsa_output.pci-0000_05_00.6.HiFi__Headphones__sink

current=$(pactl get-default-sink)
case $current in
    $company_headset) pactl set-default-sink $wired_old ;;
    $wired_old) pactl set-default-sink $company_headset ;;
    $*) pactl set-default-sink $company_headset ;;
esac
