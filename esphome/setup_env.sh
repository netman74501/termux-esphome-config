#!/data/data/com.termux/files/usr/bin/bash
RED="\e[31m"
GREEN="\e[32m"
YELOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"
exec_grun() {
  echo -e "Processing ${CYAN}$FILE${RESET}"
  if file -bL --mime "${FILE}" | grep -q "executable; charset=binary"; then
    OUTPUT=$(grun -f -c "$@" 2>&1)
    if echo "$OUTPUT" | grep -q -i -E "patchelf|error"; then
      echo -e "${RED}Configurarion failed.${RESET}"
      return 1
    fi
    echo -e "${GREEN}Configuration succeeded.${RESET}"
    return 0
  fi
  echo -e "${YELOW}Not an executable.${RESET}"
  return 1
}

source /data/data/com.termux/files/home/.esphome/bin/activate
cd /data/data/com.termux/files/home/.esphome/configs
unset LD_PRELOAD
for FILE in /data/data/com.termux/files/home/.platformio/packages/toolchain-xtensa/bin/*
do
  exec_grun $FILE
done
for FILE in /data/data/com.termux/files/home/.platformio/packages/toolchain-xtensa/xtensa-lx106-elf/bin/*
do
  exec_grun $FILE
done
for FILE in /data/data/com.termux/files/home/.platformio/packages/toolchain-xtensa/libexec/gcc/xtensa-lx106-elf/10.3.0/*
do
  exec_grun $FILE
done
cd /data/data/com.termux/files/home/.platformio/packages/toolchain-gccarmnoneeabi/libexec/
for FILE in /data/data/com.termux/files/home/.platformio/packages/toolchain-gccarmnoneeabi/bin/*
do
  exec_grun $FILE
done
for FILE in /data/data/com.termux/files/home/.platformio/packages/toolchain-gccarmnoneeabi/arm-none-eabi/bin/*
do
  exec_grun $FILE
done
for FILE in /data/data/com.termux/files/home/.platformio/packages/toolchain-gccarmnoneeabi/libexec/gcc/arm-none-eabi/10.3.1/*
do
  exec_grun $FILE
done
cd /data/data/com.termux/files/home/.esphome/configs
