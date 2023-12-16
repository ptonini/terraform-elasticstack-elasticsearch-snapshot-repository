resource "elasticstack_elasticsearch_snapshot_repository" "this" {
  name = var.name

  dynamic "s3" {
    for_each = var.type == "s3" ? [0] : []
    content {
      bucket    = var.settings.bucket
      base_path = var.settings.base_path
      readonly  = var.settings.readonly
    }
  }

  dynamic "azure" {
    for_each = var.type == "azure" ? [0] : []
    content {
      container = var.settings.container
      base_path = var.settings.base_path
      readonly  = var.settings.readonly
    }
  }
}

resource "elasticstack_elasticsearch_snapshot_lifecycle" "this" {
  for_each             = var.lifecycle_policies
  name                 = each.key
  repository           = elasticstack_elasticsearch_snapshot_repository.this.name
  schedule             = each.value.schedule
  snapshot_name        = each.value.snapshot_name
  ignore_unavailable   = each.value.ignore_unavailable
  include_global_state = each.value.include_global_state
  indices              = each.value.indices
  expire_after         = each.value.expire_after
}