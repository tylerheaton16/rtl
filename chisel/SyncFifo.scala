//> using scala "2.13.12"
//> using dep "org.chipsalliance::chisel:6.6.0"
//> using plugin "org.chipsalliance:::chisel-plugin:6.6.0"
//> using options "-unchecked", "-deprecation", "-language:reflectiveCalls", "-feature", "-Xcheckinit", "-Xfatal-warnings", "-Ywarn-dead-code", "-Ywarn-unused", "-Ymacro-annotations"

import chisel3._
// _root_ disambiguates from package chisel3.util.circt if user imports chisel3.util._
import _root_.circt.stage.ChiselStage

class SyncFifo extends Module {
}

object Main extends App {
  println(
    ChiselStage.emitSystemVerilog(
      gen = new SyncFifo,
      firtoolOpts = Array("-disable-all-randomization", "-strip-debug-info")
    )
  )
}
