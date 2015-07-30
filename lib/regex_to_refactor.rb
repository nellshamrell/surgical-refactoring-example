class RegexToRefactor
  # Character by character, we copy the regex here to understand what it matches
  # Regex is a sub program within a program, so we separate it out to concentrate just on it first
  # Same as refactoring "normal code" - we do it piece by piece
  def first_regex_match(string)
    # Resist the urge to make changes as you copy the regex over
    # right now we're just trying to figure out what it does!
    # we'll optimize later
    # Regex is a good "seam" - program within a program
    /:([[:alpha:]]+[[:space:]])=>/.match(string)
  end

  def scary_regex_command(directory)
    system "sed -E -i '' 's/:([[:alpha:]]+)[[:space:]]=>/\\1:/g' #{directory_path(directory)}"
  end

  private

  def directory_path(directory)
    "#{directory}/**/*.rb"
  end
end
