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
            -h|--help)
                cat << eof
configure.sh

configure doasedit installation

USAGE:
    configure.sh [OPTIONS]

OPTIONS:
    -h, --help                  Print help information
    --prefix=<PREFIX>           Prefix for installation [default: /usr]
    --bin-dir=<BIN_DIR>         Directory for bineries [default: <PREFIX>/bin]
    --name=<NAME>               Program name [default: doasedit]
    --shell=<SHELL>             Shell for binery [default: /usr/bin/env sh]
eof
                exit
            ;;
            --prefix=*)
                prefix="${1#*=}"
            ;;
            --bin-dir=*)
                bin_dir="${1#*=}"
            ;;
            --bname=*)
                name="${1#*=}"
            ;;
            --shell=*)
                shell="${1#*=}"
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

: "${prefix="/usr"}"
: "${bin_dir="$prefix/bin"}"
: "${name="doasedit"}"
: "${shell="/usr/bin/env sh"}"

cat << eof > "$DIR/install.conf"
PREFIX='$prefix'
BIN_DIR='$bin_dir'
NAME='$name'
SHELL='$shell'
eof
