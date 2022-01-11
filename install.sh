#!/usr/bin/env sh

set -eu

# https://github.com/ko1nksm/readlinkf
readlinkf() {
    [ ${1:+x} ] || return 1; p=$1; until [ _"${p%/}" = _"$p" ]; do p=${p%/}; done
    [ -e "$p" ] && p=$1; [ -d "$1" ] && p=$p/; set 10 "$(pwd)" "${OLDPWD:-}"; PWD=
    CDPATH="" cd -P "$2" && while [ "$1" -gt 0 ]; do set "$1" "$2" "$3" "${p%/*}"
        [ _"$p" = _"$4" ] || { CDPATH="" cd -P "${4:-/}" || break; p=${p##*/}; }
        [ ! -L "$p" ] && p=${PWD%/}${p:+/}$p && set "$@" "${p:-/}" && break
        set $(($1-1)) "$2" "$3" "$p"; p=$(ls -dl "$p") || break; p=${p#*" $4 -> "}
    done 2>/dev/null; cd "$2" && OLDPWD=$3 && [ ${5+x} ] && printf '%s\n' "$5"
}

SOURCE="$(readlinkf "$0")"
DIR="$(dirname -- "$SOURCE")"

options=true
args=0
while [ $# -gt 0 ]; do
    if $options && case "$1" in -*) true;; *) false;; esac; then
        case "$1" in
            -h)
                cat << eof
install.sh

manage doasedit installation

USAGE:
    install.sh [OPTIONS] <COMMAND>

COMMAND:
    install                     Install doasedit
    uninstall                   Uninstall doasedit

OPTIONS:
    -h, --help                  Print help information
eof
                exit
            ;;
            --)
                options=false
            ;;
            *)
                printf 'Error: Invalid option "%s"\n' "$1"
                exit 1
            ;;
        esac
    else
        case $args in
            0)
                command="$1"
                shift
                
                options=true
                args=0
                case "$command" in
                    install)
                        while [ $# -gt 0 ]; do
                            if $options && case "$1" in -*) true;; *) false;; esac; then
                                case "$1" in
                                    -h|--help)
                                        cat << eof
install.sh

Install doasedit

USAGE:
    install.sh install [OPTIONS]

OPTIONS:
    -h, --help                  Print help information
eof
                                        exit
                                    ;;
                                    --)
                                        options=false
                                    ;;
                                    *)
                                        printf 'Error: Invalid option "%s"\n' "$1"
                                        exit 1
                                    ;;
                                esac
                            else
                                case $args in
                                    *)
                                        printf 'Error: Invalid argument "%s"\n' "$1"
                                        exit 1
                                    ;;
                                esac
                                
                                args=$((args + 1))
                            fi
                            
                            shift
                        done
                    ;;
                    uninstall)
                        while [ $# -gt 0 ]; do
                            if $options && case "$1" in -*) true;; *) false;; esac; then
                                case "$1" in
                                    -h|--help)
                                        cat << eof
install.sh

Uninstall doasedit

USAGE:
    install.sh uninstall [OPTIONS]

OPTIONS:
    -h, --help                  Print help information
eof
                                        exit
                                    ;;
                                    --)
                                        options=false
                                    ;;
                                    *)
                                        printf 'Error: Invalid option "%s"\n' "$1"
                                        exit 1
                                    ;;
                                esac
                            else
                                case $args in
                                    *)
                                        printf 'Error: Invalid argument "%s"\n' "$1"
                                        exit 1
                                    ;;
                                esac
                                
                                args=$((args + 1))
                            fi
                            
                            shift
                        done
                    ;;
                    *)
                        printf 'Error: Invalid <COMMAND> "%s"\n' "$command"
                        exit 1
                    ;;
                esac
                
                break
            ;;
            *)
                printf 'Error: Invalid argument "%s"\n' "$1"
                exit 1
            ;;
        esac
        
        args=$((args + 1))
    fi
    
    shift
done

if [ -z "${command+_}" ]; then
    printf 'Error: Missing argument <COMMAND>\n'
    exit 1
fi

if [ -f "$DIR/install.conf" ]; then
    . "$DIR/install.conf"
else
    printf 'Error: Missing install.conf, run configure.sh\n'
    exit 2
fi

bin_path="$BIN_DIR/$NAME"

case "$command" in
    install)
        cp "$DIR/bin/doasedit" "$bin_path"
        sed -i "s|#!.*|#!$SHELL|" "$bin_path"
        sed -i "s|NAME=.*|NAME='$NAME'|" "$bin_path"
        chmod 755 "$bin_path"
    ;;
    uninstall)
        rm "$bin_path"
    ;;
esac
