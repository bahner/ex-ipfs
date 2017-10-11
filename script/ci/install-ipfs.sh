#!/bin/sh

USAGE="$0 [<version>] [<install-path>]"

usage() {
  echo "$USAGE"
  echo "installs the ipfs binary at a local install path"
  exit 0
}

die() {
  echo >&2 "error: $@"
  exit 1
}

log() {
  if [ $verbose ]; then
    echo >&2 "$@"
  fi
}

assert_has() {
  if [ -z $(which "$1") ]; then
     die "please install $1"
  fi
}

webget() {
  if type wget >/dev/null;
  then
    # -nc + -O return 1 if file already exists
    wget -nc -q -O "$1" "$2" || test -f "$1"
    return
  fi

  if type curl >/dev/null;
  then
    curl -s -o "$1" "$2"
    return
  fi

  die "please install wget or curl"
}

assert_has unzip
assert_has mv


# get user options
while [ $# -gt 0 ]; do
  # get options
  arg="$1"
  shift

  case "$arg" in
  -h|--help) usage ;;
  -v|--verbose) verbose=1 ;;
  --*)
    die "unrecognised option: '$arg'\n$USAGE" ;;
  *)
    if [ "$version" = "" ]; then
      version="$arg"
    elif [ "$dstpath" = "" ]; then
      dstpath="$arg"
    else
      die "too many arguments\n$USAGE"
    fi
    ;;
  esac
done


# set defaults
if [ "$version" = "" ]; then
  version="master"
fi
if [ "$dstpath" = "" ]; then
  dstpath="/usr/local/bin/ipfs"
fi

# figure out GOPLATFORM
# log "figuring out go platform"
case "$(uname -s)" in
  Darwin) GOOS=darwin ;;
  FreeBSD) GOOS=freebsd ;;
  OpenBSD) GOOS=openbsd ;;
  Linux) GOOS=linux ;;
  CYGWIN*|MINGW32*|MSYS*) GOOS=windows ;;
  *) die "error: unknown arch\nplease add it to: https://github.com/ipfs/install-ipfs" ;;
esac

case $(uname -m) in
  amd64) GOARCH=amd64 ;;
  x86_64) GOARCH=amd64 ;;
  i686) GOARCH=386 ;;
  i686) GOARCH=386 ;;
  *) die "error: unknown arch\nplease add it to: https://github.com/ipfs/install-ipfs" ;;
esac


# figure out URL
ZIP_FILENAME="ipfs_${version}_${GOOS}-${GOARCH}.zip"
BIN_PATH="github.com/ipfs/go-ipfs/cmd/ipfs"
URL="https://gobuilder.me/get/$BIN_PATH/$ZIP_FILENAME"

cwd=$(pwd)
tmpdir="/tmp/install_ipfs"
mkdir -p "$tmpdir"
cd "$tmpdir"

# download url
log "downloading $URL"
webget "$ZIP_FILENAME" "$URL" 2>&1 >/dev/null || die "failed to download $URL"

# unzip
log "unzipping $ZIP_FILENAME"
unzip -o -q "$ZIP_FILENAME" 2>&1 >/dev/null || die "failed to unzip $ZIP_FILENAME"

cd "$cwd"

# installing
log "installing to $dstpath"
mv "$tmpdir/ipfs/ipfs" "$dstpath" 2>&1 >/dev/null || die "failed to move ipfs/ipfs to $dstpath"