error() {
  echo " !     $*" >&2
  exit 1
}

status() {
  echo "-----> $*"
}

protip() {
  echo
  echo "PRO TIP: $*" | indent
  echo "See https://devcenter.heroku.com/articles/nodejs-support" | indent
  echo
}

# sed -l basically makes sed replace and buffer through stdin to stdout
# so you get updates while the command runs and dont wait for the end
# e.g. npm install | indent
indent() {
  c='s/^/       /'
  case $(uname) in
    Darwin) sed -l "$c";; # mac/bsd sed: -l buffers on line boundaries
    *)      sed -u "$c";; # unix/gnu sed: -u unbuffered (arbitrary) chunks of data
  esac
}

cat_npm_debug_log() {
  test -f $build_dir/npm-debug.log && cat $build_dir/npm-debug.log
}


install_db2_odbc() {
	DB2_DIR="$1"
	if [ ! -d "$DB2_DIR/clidriver" ]; then
		#mkdir -p "$DB2_DIR"
		DB2_DSDRIVER_URL="https://public.dhe.ibm.com/ibmdl/export/pub/software/data/db2/drivers/odbc_cli/linuxx64_odbc_cli.tar.gz"
		status "downloading DB2 ODBC driver..."
		curl ${DB2_DSDRIVER_URL} -s -o ${DB2_DIR}/clidriver.tgz
		tar xzf ${DB2_DIR}/clidriver.tgz -C ${DB2_DIR}
        #Delete the archive
        rm -rf ${DB2_DIR}/clidriver.tgz
	fi
	export IBM_DB_HOME="$DB2_DIR/clidriver"
}

#canvas module dependency setup for cairo
install_canvas_libs(){
    LIB_DIR="$1"
    status "go into $LIB_DIR"
    cd ${LIB_DIR}
    if [ ! -d "$LIB_DIR/cairo-1.12.8" ]; then
      curl https://github.com/plainfield/nodejs-libs/cairo-1.12.8.tar.xz -o cairo.tar.xz
      status "Downloaded ok"
      tar -zxf cairo.tar.xz
    fi
    cd cairo-1.12.8
    status "Configure now"
	./configure --disable-dependency-tracking
	status "Configured ok"
	make install
	status "Installed ok"
	cd ${LIB_DIR}
}
