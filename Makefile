
APP=dperf
SRCS-y := src/main.c src/socket.c src/config.c src/client.c src/mbuf_cache.c src/udp.c  \
          src/port.c src/mbuf.c src/arp.c src/icmp.c src/tcp.c src/tick.c src/http.c    \
          src/net_stats.c src/flow.c src/work_space.c src/cpuload.c src/config_keyword.c\
          src/socket_timer.c src/ip.c src/eth.c src/server.c src/dpdk.c src/ctl.c       \
          src/icmp6.c src/neigh.c src/vxlan.c src/csum.c src/kni.c src/bond.c src/lldp.c\
          src/rss.c src/ip_list.c src/http_parse.c src/trace.c

PKGCONF = pkg-config
PKG_CONFIG_PATH=$(RTE_SDK)/build/install/lib/x86_64-linux-gnu/pkgconfig

ifneq ($(shell PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) $(PKGCONF) --exists libdpdk && echo 0),0)
$(error "no installation of DPDK found")
endif

ifdef DPERF_DEBUG
CFLAGS += -DDPERF_DEBUG
endif

CFLAGS += -O3 -g -I./src
CFLAGS += -DHTTP_PARSE
CFLAGS += -Wno-address-of-packed-member
CFLAGS += $(shell PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) $(PKGCONF) --cflags libdpdk)
LDFLAGS += $(shell PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) $(PKGCONF) --libs libdpdk) -lpthread -lrte_net_bond -lrte_bus_pci -lrte_bus_vdev

build/$(APP): $(SRCS-y)
	mkdir -p build
	gcc $(CFLAGS) $(SRCS-y) -o $@ $(LDFLAGS) -Wl,-rpath=$(RTE_SDK)/build/install/lib/x86_64-linux-gnu

clean:
	rm -rf build/

