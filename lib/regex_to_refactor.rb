class RegexToRefactor
  def scary_regex_command(directory)
    # Let's add in a spec to verify the behavior of the -i flag
    # According to the sed man page -i means SED will alter the files in place
    # if we were to pass an extension to the flag (i.e. -i.tmp
    # it would create a backup of the file with the extension .tmp
    # However, if we pass an empty string it does NOT create a backup file
    # This seems dangerous and like something we'd like to change
    # But remember that when we're refactoring we're NOT changing the behavior of the code
    # So let's hold off on that
    # Let's add a spec, make sure it fails, the make it pass and re-verify
    system "sed -E -i '' '#{substitute_command}' #{directory_path(directory)}"
  end

  private

  def match_regex
    ":([[:alpha:]]+)[[:space:]]=>"
  end

  def directory_path(directory)
    "#{directory}/**/*.rb"
  end

  def substitute_command
    "s/#{match_regex}/\\1:/g"
  end

end
