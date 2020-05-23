###############################
# String manipulation
###############################
variable "string" {
  type = string
  default = "jerome-maclean__us_east-1__dev" # Underscore used on purpose
}

locals {
  regex_string1 = regex("([^_]*_?[^_]*_?[^_]*_?[^_]+)__([^_]*_?[^_]*_?[^_]*_?[^_]+)__([^_]*_?[^_]*_?[^_]*_?[^_]+)", var.string)[0]
  regex_string2 = regex("([^_]*_?[^_]*_?[^_]*_?[^_]+)__([^_]*_?[^_]*_?[^_]*_?[^_]+)__([^_]*_?[^_]*_?[^_]*_?[^_]+)", var.string)[1]
  regex_string3 = regex("([^_]*_?[^_]*_?[^_]*_?[^_]+)__([^_]*_?[^_]*_?[^_]*_?[^_]+)__([^_]*_?[^_]*_?[^_]*_?[^_]+)", var.string)[2]

  regex_advanced = regex("^(?:(?P<scheme>[^:/?#]+):)?(?://(?P<authority>[^/?#]*))?", "https://terraform.io/docs/")
}


###############################
# List manipulation (simple)
###############################
variable "list_strings" {
  type = list(string)
  default = ["one","two","three","four",1,2,3,4]
}

locals {
  list_conditional = [
    for value in var.list_strings:
    value if ( value != 3 && value != "one" )
  ][0]
}

###############################
# Map manipulation
###############################
variable "map" {
  type = map
  default = {
    Key1           = "value1"
    Key2           = "value2"
    KeyNull    = null
  }
}

locals {
  # Filter key from map on value condition
  map_conditional = {
    for key,value in var.map:
    key => value if ( value != "value1" && value != null)
  }

  # Mapping tags to asg format
  map_tags_asg_format = null_resource.asg_tags_as_list_of_maps.*.triggers
}

resource "null_resource" "asg_tags_as_list_of_maps" {
  count = length(keys(local.map_conditional))

  triggers = {
    "key"                 = keys(local.map_conditional)[count.index]
    "value"               = values(local.map_conditional)[count.index]
    "propagate_at_launch" = "true"
  }
}

###############################
# Lists manipulation (nested)
###############################
# variable "list_nested" {
#   type = list(string)
#   default = ["one","two","three","four",1,2,3,4]
# }

