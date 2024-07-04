package main

import (
	"fmt"
	"net"
)

func main() {
	domain := "scruffy3024.site"
	ips, err := net.LookupIP(domain)
	if err != nil {
		fmt.Printf("Could not get IPs: %v\n", err)
		return
	}

	for _, ip := range ips {
		fmt.Printf("%s IN A %s\n", domain, ip.String())
	}
}
