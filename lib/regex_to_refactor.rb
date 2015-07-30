class RegexToRefactor
  # Character by character, we copy the regex here to understand what it matches
  # Same as refactoring "normal code" - we do it piece by piece
  def first_regex_match(string)
    /:/.match(string)
  end

  def scary_regex_command(directory)
    system "sed -E -i '' 's/:([[:alpha:]]+)[[:space:]]=>/\\1:/g' #{directory_path(directory)}"
  end

  private

  def directory_path(directory)
    "#{directory}/**/*.rb"
  end
end
