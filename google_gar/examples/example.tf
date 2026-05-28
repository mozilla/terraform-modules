module "gar" {
  source = "github.com/mozilla/terraform-modules//google_gar?ref=google_gar-0.4.0"

  description        = "Default repository for test project"
  application        = "glonk"
  realm              = "nonprod"
  repository_readers = ["user:jdoe@firefox.gcp.mozilla.com"]
}
