resource "elasticstack_elasticsearch_snapshot_repository" "this" {
  name = var.name
  dynamic "s3" {
    for_each = var.type == "s3" ? { 0 = var.settings } : {}
    content {
      bucket    = s3.value["bucket"]
      base_path = s3.value["base_path"]
      readonly  = s3.value["readonly"]
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