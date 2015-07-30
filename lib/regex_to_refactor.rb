class RegexToRefactor
  # We now have a test for exactly what this regex does, so let's move it to its own method for now
  # We will re-run our existing tests to make sure it still matches as we expect
  def match_regex
    ":([[:alpha:]]+[[:space:]])=>"
  end

  def scary_regex_command(directory)
    system "sed -E -i '' 's/:#{match_regex}/\\1:/g' #{directory_path(directory)}"
  end

  private

  def directory_path(directory)
    "#{directory}/**/*.rb"
  end
end
