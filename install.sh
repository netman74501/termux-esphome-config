#!/data/data/com.termux/files/usr/bin/bash
ENV_DIR="${HOME}/.esphome"
create_setup_env() {
cat << EOF > ${HOME}/setup_env.sh
#!/data/data/com.termux/files/usr/bin/bash
ENV_DIR=${ENV_DIR}
EOF
cat << "EOF" >> ${HOME}/setup_env.sh
TC_DIR=("${HOME}"/.platformio/packages/toolchain*)
RED="\e[31m"
GREEN="\e[32m"
YELOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"
exec_grun() {
  echo -e "Processing ${CYAN}${FILE}${RESET}"
  if [ -e "${FILE}" ] && file -bL --mime "${FILE}" | grep -q "executable; charset=binary"; then
    OUTPUT=$(grun -f -c "${FILE}" 2>&1) # Execute grun and store output
    if echo "$OUTPUT" | grep -q -i -E "patchelf|error"; then # Check output for failures
      echo -e "${RED}Configuration failed.${RESET}"
      return 1
    fi
    echo -e "${GREEN}Configuration succeeded.${RESET}"
    return 0
  fi
  echo -e "${YELOW}Not an executable.${RESET}"
  return 1
}
if [ "$1" != "-nc" ] && [ "$1" != "--no-configure" ]; then
  if shopt -s nullglob; then # Return empty array if no match
    if [ ${#TC_DIR[@]} -gt 0 ]; then # Check for toolchain(s)
      for TC in "${TC_DIR[@]}"; do
        # Speed up finding libraries by changing directory to libexec if it exists
        if [ -d "${TC}"/libexec ]; then
          cd "${TC}"/libexec
          PWD=$(pwd)
          echo "Changed directory to ${PWD}"
        fi
        # Locate directory paths using names of unique binaries
        for DIR in $(find "${TC}" \( -name "readelf" -or -name "*g++" -or -name "cc1" \) -printf '%h\n' 2>/dev/null); do
          for FILE in "${DIR}"/*; do
            exec_grun
          done
        done
      done
    fi
  fi
fi
source "${ENV_DIR}"/bin/activate
unset LD_PRELOAD
mkdir -p "${ENV_DIR}"/configs
cd "${ENV_DIR}"/configs
EOF
}
create_tmp_configs(){
cat <<EOF >${TMPDIR}/bk7231n.yaml
esphome:
  name: bk7231n
bk72xx:
  board: cb2s
EOF
cat <<EOF >${TMPDIR}/esp8266.yaml
esphome:
  name: esp8266
esp8266:
  board: d1_mini
  framework:
    version: recommended
EOF
}
termux-change-repo
pkg update && pkg upgrade -y
pkg install -y python rust git glibc-repo file
pkg update && pkg upgrade -y
pkg install -y libisl-glibc libiconv-glibc libjpeg-turbo
pkg clean
python -m venv ${ENV_DIR}
source ${ENV_DIR}/bin/activate
pip install --upgrade --no-cache wheel setuptools pip
pip install --upgrade --no-cache esphome
cd ${TMPDIR}
create_tmp_configs
esphome -v compile esp8266.yaml
esphome -v compile bk7231n.yaml
cd ${HOME}
create_setup_env
source ${HOME}/setup_env.sh
