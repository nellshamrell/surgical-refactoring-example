class RegexToRefactor
  def self.scary_regex_command(directory)
    system "sed -E -i '' 's/:([[:alpha:]]+)[[:space:]]=>/\\1:/g' #{directory}/**/*.rb"
  end
end
