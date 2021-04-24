#!/usr/bin/env coffee

import { getMachineId } from 'https://deno.land/x/machine_id/mod.ts'
import config from '../config/yml'
# import SEED from '../config/seed'

export default do =>
  {port} = config

  loop
    try
      socket = Deno.listenDatagram {
        port: port or 0
        transport: "udp"
        hostname: "0.0.0.0"
      }
    catch err
      port = 5535 + (++ port - 5535 ) % 60000
      continue
    break

  {addr} = socket

  # seed = hash new Uint8Array([
  #   port >>> 8
  #   port & 0xff
  #   ...encode(addr.hostname)
  #   ...encode(await getMachineId())
  #   ...SEED
  # ])

  if not port
    config.port = socket.addr.port

  return socket


