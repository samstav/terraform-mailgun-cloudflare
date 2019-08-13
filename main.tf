/*
 * Module: terraform-mailgun-cloudflare
 *
 * This template creates the following resources
 *   - A Mailgun domain
 *   - An Cloudflare DNS Zone (unless the zone_id variable is set)
 *   - DNS Records:
 *     - SPF, DKIM, CNAME, MX
 *
 * The MX records are optional, to disable set the variable mailgun_set_mx_for_inbound to false.
 *
 * If using an existing Route53 Zone, you must set the 'zone_id' terraform variable for this module.
 *
 * Another option is to import your Zone *into* this module, but that is probably not the
 * "route" you want to go. (see what I did there?) But if you do:
 *
 * $ terraform import module.mailer.cloudflare_zone.this[0] <your_zone_id>
 *
 * (The `[0]` is needed because it is a "conditional resource" and you must refer to the 'count'
 *  index when importing, which is always [0])
 *
 * where the 'mailer' portion is the name you choose:
 *
 * module "mailer" {
 *   source = "github.com/samstav/terraform-mailgun-cloudflare"
 * }
 *
 * # In *either* case, you can refer to your zone id like this:
 *
 *   "${module.mailer.zone_id}"
 *
 * Since 'zone_id' is also an output variable from the terraform-mailgun-cloudflare module.
 *
 * Here is an example of how one might use the 'zone_id' output variable:
 *
 * resource "cloudflare_record" "keybase_proof" {
 *   zone_id = "${module.mailer.zone_id}"
 *   name = "_keybase"
 *   type = "TXT"
 *   ttl = 300
 *   records = ["keybase-site-verification=JHEIDMF-NkenDk389DnekD83ls8KLDjenf88slej89"]
 * }
 *
 */

# This module uses conditionals and therefore needs at least 0.8.0
# https://github.com/hashicorp/terraform/blob/master/CHANGELOG.md#080-december-13-2016

terraform {
  required_version = ">= 0.8.0"
}

resource "mailgunv3_domain" "this" {
  name          = var.domain
  smtp_password = var.mailgun_smtp_password
  spam_action   = var.mailgun_spam_action
  wildcard      = var.mailgun_wildcard

  # prevent_destroy is on because I have seen issues
  # with mailgun disabling my domain resource when
  # terraform re-creates it. This results in needing
  # to open a ticket with mailgun and is no fun :)

  lifecycle {
    prevent_destroy = true
  }
}

