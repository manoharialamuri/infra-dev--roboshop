variable "components" {
  default = {
    #this is for backend components, attaching to backend alb
    catalogue = {
        rule_priority = 10
    }
    # user = {
    #     rule_priority = 20
    # }
    # cart = {
    #     rule_priority = 30
    # }
    # shipping = {
    #     rule_priority = 40
    # }
    # payment = {
    #     rule_priority = 50
    # }
    #this is attaching to frontend alb and there is only one component attaching to frontend alb
    frontend = {
        rule_priority = 10
    }
  }
}