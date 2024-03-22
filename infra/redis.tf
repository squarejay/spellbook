resource "aiven_redis" "spellbook-redis" {
  project                 = var.project_name
  cloud_name              = "do-ams"
  plan                    = "free-1"
  service_name            = "spellbook-redis"
  maintenance_window_dow  = "sunday"
  maintenance_window_time = "23:00:00"

  redis_user_config {
    redis_maxmemory_policy = "allkeys-lru"

    public_access {
      redis = true
    }
  }
}

resource "random_password" "redis_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aiven_redis_user" "spellbook-redis-user" {
  project      = var.project_name
  service_name = aiven_redis.spellbook-redis.service_name
  username     = "spellbook-redis-user"
  password     = random_password.redis_password.result
}