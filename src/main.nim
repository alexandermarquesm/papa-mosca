import os
import cli/command_handler
import utils/file_utils

from cli/help_displayer import showHelp

proc main() =
  createDirectories()

  if paramCount() == 0:
    showHelp()
    return

  let args = commandLineParams()
  handleCommand(args)

when isMainModule:
  main()
