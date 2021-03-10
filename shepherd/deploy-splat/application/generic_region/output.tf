output "control_plane_splat_downstream_spec" {
  value = module.splat_control_plane.downstream_spec
}

output "control_plane_splat_operational_spec" {
  value = module.splat_control_plane.operational_spec
}

output "data_plane_splat_downstream_spec" {
  value = module.splat_management_plane.downstream_spec
}

output "data_plane_splat_operational_spec" {
  value = module.splat_management_plane.operational_spec
}
