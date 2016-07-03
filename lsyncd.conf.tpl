{{ $sources := split .Env.SOURCES ":" }}
{{ $destinations := split .Env.DESTINATIONS ":" }}
{{ $excludes_env := default .Env.EXCLUDES "" }}
{{ $excludes := split $excludes_env ":" }}

settings {
  nodaemon = true,
  inotifyMode = "{{ default .Env.INOTIFYMODE "CloseWrite or Modify" }}",
  maxDelays = {{ default .Env.MAXDELAYS "1" }}
}

{{ range $index, $element := $sources }}
sync {
  default.rsync,
  source = "{{ $element }}",
  target = "{{ index $destinations $index }}",
  init = {{ default .Env.INIT "false" }},
  rsync = {
    binary = "/usr/bin/rsync",
    archive = true,
    compress = false,
    perms = true,
    owner = true,
    update = true,
    _extra = {"-go"},
    temp_dir = "/tmp/rsync-{{ $index }}",
  },
  exclude = { {{ range $i, $exclude := $excludes }}{{ if $i }}, {{end}}"{{ $exclude }}"{{ end }} }
}
{{ end }}