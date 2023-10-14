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

resource "elasticsearch_xpack_snapshot_lifecycle_policy" "this" {
  for_each = var.policies
  name     = each.key
  body = jsonencode({
    repository = elasticstack_elasticsearch_snapshot_repository.this.name
    schedule   = each.value.snapshot_schedule
    name       = each.value.snapshot_name
    config     = each.value.snapshot_config
    retention  = each.value.snapshot_retention
  })
}