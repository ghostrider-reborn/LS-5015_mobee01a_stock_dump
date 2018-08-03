#!/system/bin/sh
# Version: V1.0
# Author: Alex.Zhou
# Function: Get component info
# modify record:
#     function            date       Author      email 
#     1. create the file  04/08/2014 Alex.zhou   ronggang.zhou@ck-telecom.com
#     2. modified file    03/03/2015 mask.yang   mask.yang@ck-telecom.com

#2.modified file
# 1) add replace space to "_"

#debug switch
#debug="on"


function do_set_property_from_file()
{
	local ret_string
	local property=$2
	if [ -f $1 ]
	then
		ret_string=`cat $1`
		#remove space on string last
		ret_string=${ret_string%%" "}
		#replace space to "_"
		ret_string=${ret_string//" "/"_"}
	else
		ret_string="unknown"
	fi

	if [ $property != "" ]
	then
		setprop $property  $ret_string
	fi
	echo ${ret_string}

}

function set_property_from_file()
{
	do_set_property_from_file $1 "ro.ckt.product.$2"
}
function set_camera()
{
	local a=60
	local info
	while ((a--))
	do
		if [ -s $1 ]
		then
			break
		fi
		sleep 1
	done
	info=`cat $1`
	echo ==$1--$info==
	do_set_property_from_file $1 "ro.ckt.product.$2"
}

function Split_string_and_get()
{
    echo $1
}

GetInfo()
{

	#get emcp info
        cmdline=`cat /proc/cmdline`
        cmdline=${cmdline##*androidboot.emmcname=}
        #cmdline=${cmdline%%/ *}
        cmdline1=$(Split_string_and_get $cmdline)
        echo $cmdline1
        if [ -n $cmdline1 ];then
            setprop ro.ckt.product.emcp $cmdline1
        fi
#	cmdline=`cat /proc/cmdline`

#	emcp_name=`echo ${cmdline}|busybox awk '{
#		for(i=1;i<=NF;i++){
#			if($i~/androidboot.emmcname/){
#				sub(/androidboot.emmcname=/,"")
#				print $i
#			}
#		}
#	}'`
#	if [ ! -d $emcp_name ]
#	then
#		setprop ro.ckt.product.emcp $emcp_name
#	fi
	#do_set_property_from_file /cache/recovery/persist.sys.reset.flag persist.sys.reset.flag
	#if [ -f /cache/recovery/persist.sys.reset.flag ]
	#then
	#	rm /cache/recovery/persist.sys.reset.flag
	#fi
	#nvread=`/system/bin/cktnvtool`
	#add for reset

}

log -p e -t devinfo "get device info "
sleep 10
set_property_from_file /sys/class/touchscreen/ts_info "tp"
set_property_from_file /sys/class/touchscreen/ts_version "tpv"
set_property_from_file /sys/class/lcd/lcd_info "lcd"
#set_property_from_file /sys/class/mdtv/mdtv_info "mdtv"
set_property_from_file /sys/devices/soc.0/a000000.qcom,wcnss-wlan/wcnss_name "wcnss"
#set_property_from_file /sys/devices/soc.0/a000000.qcom,wcnss-wlan/wcnss_name "wcnss"
set_property_from_file /sys/devices/soc.0/78b8000.i2c/i2c-4/4-0014/smb1360_icinfo "chargeic"
GetInfo
set_camera /sys/class/camera/sub_camera_info "sub_camera"
set_camera /sys/class/camera/main_camera_info "main_camera"
set_camera /sys/class/yuv_camera/slave_camera_info "slave_camera"
#SetProperty
