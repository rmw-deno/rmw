#!/usr/bin/env coffee

import ROOT from "./root"
import * as path from "https://deno.land/std/path/mod.ts"

export default Deno.env.get("RMW_SRV_DATA") or path.join ROOT, "data"

