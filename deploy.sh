#!/bin/bash
domain=lares.com.example
password=Pass$$w0rd
example=redsocial

tarball="${HOSTNAME}-$(date +%Y-%m-%d).tar"
workdir="${PWD}/${HOSTNAME}-$(date +%Y-%m-%d)"

info(){ printf "\e[0;94m[*]\e[0m %s\n" "${*}"; }
error(){ printf "\e[0;91m[x]\e[0m %s\n" "${*}"; }
success(){ printf "\e[0;92m[+]\e[0m %s\n" "${*}"; }
warning(){ printf "\e[0;93m[!]\e[0m %s\n" "${*}"; }

got_root(){
    if [ $UID -ne 0 ]; then
        printf "\e[0;91mGot r00t?\e[0m\n"
        exit 1
    fi
}

create_workdir(){
    if [[ -d "$workdir" ]]; then
        error "$workdir exists"
        exit 2
    else
        success "Creating $workdir"
        mkdir "$workdir"
    fi
}

collect_data(){
    success "Changing to directory $workdir"
    success "Collecting data ..."

    cd "$workdir" && {
		### host overview
		hostname > 01-hostname.txt # hostname
		ifconfig > 02-ifconfig.txt # ip
		cat /etc/*-release > 03-release.txt # release

		### patch analysis
		uname -a > 04-uname.txt # kernel version
        	rpm -qa | sort  | pr -tw123 -4 > 05-InstalledProg.txt # installed programs
