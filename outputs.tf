/*
 * Module: tf_mailgun_cloudflare
 *
 * Outputs:
 *   - zone_id
 *   - name_servers
 */

# Be sure to check this output and set using the UpdateDomainNameservers API
output "cloudflare_name_servers" {
  value = data.cloudflare_zone.selected[0].name_servers
}

output "cloudflare_zone_id" {
  value = element(concat(data.cloudflare_zone.selected.*.zone_id, [""]), 0)
}

output "cloudflare_zone_name" {
  value = length(data.cloudflare_zones.selected.*.zones) > 0 ? element(concat(data.cloudflare_zones.selected.*.zones, [""]), 0) : ""
}

output "cloudflare_zone_id" {
  #value = "${element(concat(data.cloudflare_zones.selected.*.zones[0].id, list("")), 0)}"
  #value = "${element(concat(data.cloudflare_zones.selected.*.zones, chunklist(list(""), 1)), 0)}.id"
  value = flatten(
    slice(
      data.cloudflare_zones.selected.*.zones,
      0,
      length(data.cloudflare_zones.selected.*.zones) - max(length(data.cloudflare_zones.selected.*.zones) - 1, 0),
    ),
  )
}

output "cloudflare_name_servers" {
  #value = "${element(concat(data.cloudflare_zones.selected.*.zones, chunklist(list(""), 1)), 0)}"
  #value = "${flatten(slice(data.cloudflare_zones.selected.*.zones, 0, 1))}[0].name_servers"
  value = flatten(
    slice(
      data.cloudflare_zones.selected.*.zones,
      0,
      length(data.cloudflare_zones.selected.*.zones) - max(length(data.cloudflare_zones.selected.*.zones) - 1, 0),
    ),
  )
}
