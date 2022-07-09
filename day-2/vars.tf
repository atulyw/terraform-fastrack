# variable "env" {
#   type    = string
#   default = "dev"
# }

# variable "tags" {
#   type = map(any)
#   default = {
#     env      = "dev"
#     billings = "cloudblitz"
#     owner    = "abc-project"
#     location = "USA"
#   }
# }

# variable "name" {
#   type    = list(any)
#   default = ["a", "b", "c", "d"]
#   #           0    1    2    3
# }

# variable "condition" {
#   type = bool
#   default = false
# }

# variable "count_num" {
#   type    = number
#   default = "1"
# }

# variable "sg" {
#   type = any
#   default = {
#     env      = ["a", "b", "c"]
#     billings = "cloudblitz"
#     owner    = "abc-project"
#     location = {
#       "usa" = "cali"
#       "uk"  = "london"
#       "china" = {
#           city = "binging"
#       }
#     }
#   }
# }