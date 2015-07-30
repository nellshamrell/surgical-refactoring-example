class RegexToRefactor
  def scary_regex_command(directory)
    # We're almost there, now we need to add tests to verify
    # what each of the flags do.  Let's start with the -E flag
    # According to the man page for sed, the -E makes it so
    # sed can use extended (modern) regular expressions, rather than basic regular expressions
    # let's try taking that flag out and seeing
    # if any of our current tests break - is it necessary for the regex that we are using?
    # This breaks several tests, most notably the one that
    # tests whether the system command returns true
    # since it doesn't that means this causes an error with the sed method
    # Let's add the flag back in, our existing tests already
    # cover this behavior since they broke when we removed the flag
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
