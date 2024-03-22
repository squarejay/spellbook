resource "aiven_pg" "spellbook-pg" {
  project                 = var.project_name
  cloud_name              = "do-ams"
  plan                    = "free-1"
  service_name            = "spellbook-pg"
  maintenance_window_dow  = "sunday"
  maintenance_window_time = "23:00:00"

  pg_user_config {
    pg_version = 15

    public_access {
      pg         = true
      prometheus = false
    }

    pg {
      idle_in_transaction_session_timeout = 900
      log_min_duration_statement          = -1
    }

    admin_username = var.pg_admin
  }

  timeouts {
    create = "20m"
    update = "15m"
  }
}

resource "aiven_pg_database" "spellbook-pg-db" {
  database_name = "spellbook"
  project       = var.project_name
  service_name  = aiven_pg.spellbook-pg.service_name
}

resource "random_password" "pg_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aiven_pg_user" "pg_user" {
  project     = var.project_name
  service_name = aiven_pg.spellbook-pg.service_name
  username    = var.pg_admin
  password    = random_password.pg_password.result
}