resource "azurerm_application_security_group" "asg_web" {
  name                = "asg-${var.resource_prefix}-${var.env}-WebTier-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(var.common_tags, {
    Tier = "Web"
  })
}

resource "azurerm_application_security_group" "asg_mq" {
  name                = "asg-${var.resource_prefix}-${var.env}-MQTier-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(var.common_tags, {
    Tier = "MQ"
  })
}

resource "azurerm_application_security_group" "asg_app" {
  name                = "asg-${var.resource_prefix}-${var.env}-AppTier-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(var.common_tags, {
    Tier = "App"
  })
}

resource "azurerm_application_security_group" "asg_esha" {
  name                = "asg-${var.resource_prefix}-${var.env}-ESHATier-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(var.common_tags, {
    Tier = "ESHA"
  })
}