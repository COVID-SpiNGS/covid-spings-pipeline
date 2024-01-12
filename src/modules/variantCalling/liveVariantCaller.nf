
process create_dirs {

  script:
  """
  mkdir -p ./log
  mkdir -p ./tmp
  mkdir -p ./output
  """
}

process run_watcher {

  output: 
  path detected_change

  script:
  """
  python -m watcher.watcher
  """

}

process run_variant_caller {

  input:
  path detected_change

  when:
  detected_change != ''

  script:
  """
  python -m client_server.live_server $detected_change_path
  """
}

