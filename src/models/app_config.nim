type
  AppConfig* = object
    name*: string
    url*: string
    width*: int
    height*: int
    icon*: string
    debug*: bool

const
  APP_NAME* = "Papa-Mosca"
  APP_VERSION* = "1.0.0"
  DEFAULT_ICON* = "web-browser"
