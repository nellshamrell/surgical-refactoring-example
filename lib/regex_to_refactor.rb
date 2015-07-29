class RegexToRefactor
  def self.scary_regex_command(directory)
 #   exec "sed -i -r 's/:(\w+)\s=>/\1:/g' #{directory}/**/*.rb"

 #   system "sed -i '' 's/:(\w+)\s=>/\1:/g' #{directory}/**/*.rb"
    system "sed -E -i '' 's/:([[:alpha:]]+)[[:space:]]=>/\\1:/g' #{directory}/**/*.rb"
  end
end

RegexToRefactor.scary_regex_command('test_files')
