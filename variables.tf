variable "name" {}

variable "type" {
  default = "s3"
}

variable "settings" {
  type = object({
    bucket    = optional(string)
    base_path = optional(string)
    readonly  = optional(string)
  })
}

variable "policies" {
  type = map(object({
    snapshot_name     = optional(string, "<daily-snap-{now/d}>")
    snapshot_schedule = optional(string, "0 0 0 * * ?")
    snapshot_config = optional(object({
      indices              = optional(set(string), ["*"])
      ignore_unavailable   = optional(bool, false)
      include_global_state = optional(bool, false)
    }), {})
    snapshot_retention = optional(object({
      expire_after = optional(string, "90d")
    }), {})
  }))
}