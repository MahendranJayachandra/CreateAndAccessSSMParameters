resource "aws_ssm_parameter" "params" {
  foreach = var.paramslist
  name  = paramslist.value["name"]
  type  = paramslist.value["type"]
  value = paramslist.value["value"]
}

variable "paramslist" {
param1 = {name = "demo1",type="String",value="test1"},
param2 = {name = "demo2",type="String",value="test2"}
} 