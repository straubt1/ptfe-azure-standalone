{
  "DaemonAuthenticationType":     "password",
  "DaemonAuthenticationPassword": "${consolepassword}",
  "TlsBootstrapType":             "self-signed",
  "TlsBootstrapHostname":         "${domain}",
  "BypassPreflightChecks":        true,
  "ImportSettingsFrom":           "/etc/replicated-ptfe.conf",
  "LicenseFileLocation":          "/etc/replicated.rli"
}