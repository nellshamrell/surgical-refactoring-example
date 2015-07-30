class RegexToRefactor
  def scary_regex_command(directory)
    # Now we notice the g flag at the end of the substitution command
    # This normally means to replace all matches for the first match
    # Let's write a test to verify, make it fail, then make it pass again
    system "sed -E -i '' 's/#{match_regex}/\\1:/g' #{directory_path(directory)}"
  end

  private

  def match_regex
    ":([[:alpha:]]+)[[:space:]]=>"
  end

  def directory_path(directory)
    "#{directory}/**/*.rb"
  end

end
