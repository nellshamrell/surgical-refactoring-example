class RegexToRefactor
  def scary_regex_command(directory)
    system "sed -E -i '' 's/:([[:alpha:]]+)[[:space:]]=>/\\1:/g' #{directory_path(directory)}"
  end

  private

  def directory_path(directory)
    "#{directory}/**/*.rb"
  end
end
