# Please go to the following URL for more details
#   https://docs.nvidia.com/jetson/l4t/index.html

L4T_target_board    = jetson-agx-xavier-devkit
L4T_target_block    = mmcblk0p1

L4T_Ver_Major       = 32
L4T_Ver_Min+Patch   = 6.1
L4T_drivers_URL     = https://developer.nvidia.com/embedded/l4t/r$(L4T_Ver_Major)_release_v$(L4T_Ver_Min+Patch)/t186/jetson_linux_r$(L4T_Ver_Major).$(L4T_Ver_Min+Patch)_aarch64.tbz2
L4T_rootfs_URL      = https://developer.nvidia.com/embedded/l4t/r$(L4T_Ver_Major)_release_v$(L4T_Ver_Min+Patch)/t186/tegra_linux_sample-root-filesystem_r$(L4T_Ver_Major).$(L4T_Ver_Min+Patch)_aarch64.tbz2
# t186 for Xavier series + TX2, t210 for Nano series + TX1
# jeston_linux for Xavier series + TX2, jeston-t210_linux for Nano series + TX1

DOWNLOAD_DIR        = downloads
DOWNLOAD_EXEC       = aria2c -c -x 15 -s 15

.PHONY: all clean
all: \
  $(DOWNLOAD_DIR)/L4T_drivers_r$(L4T_Ver_Major).$(L4T_Ver_Min+Patch) \
  $(DOWNLOAD_DIR)/L4T_drivers_r$(L4T_Ver_Major).$(L4T_Ver_Min+Patch)/Linux_for_Tegra/rootfs/bin/cp
	cd $(DOWNLOAD_DIR)/L4T_drivers_r$(L4T_Ver_Major).$(L4T_Ver_Min+Patch)/Linux_for_Tegra && \
		sudo ./apply_binaries.sh && \
		sudo ./flash.sh $(L4T_target_board) $(L4T_target_block)

clean:
	-sudo rm -vrf $(DOWNLOAD_DIR)/L4T_drivers_r$(L4T_Ver_Major).$(L4T_Ver_Min+Patch)/Linux_for_Tegra/rootfs/*

$(DOWNLOAD_DIR):
	mkdir -p $@

# ------------- Linux 4 Tegra Tooling ---------------
$(DOWNLOAD_DIR)/L4T_drivers_r$(L4T_Ver_Major).$(L4T_Ver_Min+Patch)_aarch64.tbz2:
	$(DOWNLOAD_EXEC) $(L4T_drivers_URL) -o $@

$(DOWNLOAD_DIR)/L4T_drivers_r$(L4T_Ver_Major).$(L4T_Ver_Min+Patch): $(DOWNLOAD_DIR)/L4T_drivers_r$(L4T_Ver_Major).$(L4T_Ver_Min+Patch)_aarch64.tbz2
	mkdir -p $@
	tar xjvf $< -C $@
# --------------------------------------------------

# ------------- Linux 4 Tegra Image ----------------
$(DOWNLOAD_DIR)/L4T_rootfs_r$(L4T_Ver_Major).$(L4T_Ver_Min+Patch)_aarch64.tbz2:
	$(DOWNLOAD_EXEC) $(L4T_rootfs_URL) -o $@

$(DOWNLOAD_DIR)/L4T_drivers_r$(L4T_Ver_Major).$(L4T_Ver_Min+Patch)/Linux_for_Tegra/rootfs/bin/cp: \
    $(DOWNLOAD_DIR)/L4T_rootfs_r$(L4T_Ver_Major).$(L4T_Ver_Min+Patch)_aarch64.tbz2 \
    $(DOWNLOAD_DIR)/L4T_drivers_r$(L4T_Ver_Major).$(L4T_Ver_Min+Patch)
	sudo chown $(id -nu):$(id -ng) $(DOWNLOAD_DIR)/L4T_drivers_r$(L4T_Ver_Major).$(L4T_Ver_Min+Patch)/Linux_for_Tegra/rootfs/
	sudo tar vxjpf $< -C $(DOWNLOAD_DIR)/L4T_drivers_r$(L4T_Ver_Major).$(L4T_Ver_Min+Patch)/Linux_for_Tegra/rootfs/
# --------------------------------------------------

