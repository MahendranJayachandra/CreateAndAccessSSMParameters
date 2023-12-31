resource "aws_ssm_parameter" "params" {
  for_each = var.paramslist
  name  = each.value["name"]
  type  = each.value["type"]
  value = each.value["value"]
}

variable "paramslist" {
default = {
  param1 = {
    name = "demo1"
    type ="String"
    value ="test1"
  },
  param2 = {
    name = "demo2"
    type ="String"
    value ="test2"
  }
}
} 