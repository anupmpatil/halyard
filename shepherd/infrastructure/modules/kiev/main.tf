resource "kaas_regional_instance" "kaas_instance" {
  compartment_id = var.compartment_id
  kiev_name      = "${var.service_name}-${var.stage}"
  location       = "OVERLAY"   # SUBSTRATE or OVERLAY

  /* use the below block to migrate existing kiev classic to kaas */
  //    migrate {
  //      jdbc_url    = "jdbc://database.ad.region:1251/service_s"
  //      schema_name = "schema_name"
  //    }
}
