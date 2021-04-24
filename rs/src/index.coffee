#!/usr/bin/env coffee

socket = Deno.listenDatagram {
  port: 0
  transport: "udp"
  hostname: "0.0.0.0"
}

{addr} = socket

console.log addr
