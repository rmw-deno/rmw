#!/usr/bin/env coffee

import { dirname } from "std/path/mod.ts"

export default dirname(Deno.execPath())
