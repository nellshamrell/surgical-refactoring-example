require_relative '../lib/regex_to_refactor'

describe RegexToRefactor do
  describe 'calling the method' do
  # Starting from the outer edges of the method and working our way in
    it 'can be called' do
      # Step 1: Figure out how to call the beast
      # 1.1 Write test first - should pass
      # 1.2 Alter code so test should fail, make sure it fails
      expect(RegexToRefactor).to respond_to(:scary_regex_command)
    end

    it 'receives an argument' do
      # Step 2: Let's figure out the argument it is expecting to receive
      # 2.2 Remember, if test passes the first time, then alter code to make sure it fails
      expect{RegexToRefactor.scary_regex_command()}.to raise_error(ArgumentError)
      expect{RegexToRefactor.scary_regex_command('directory', 'something_else')}.to raise_error(ArgumentError)
    end
  end

  describe 'making the system call' do
    it 'calls Ruby#system method' do
      expect(RegexToRefactor).to receive(:system).with(anything())
      RegexToRefactor.scary_regex_command('directory')
    end

    it 'calls the sed command' do
      expect(RegexToRefactor).to receive(:system).with(/sed.*/)
      RegexToRefactor.scary_regex_command('directory')
    end
  end

  describe 'what the method does' do
     # What does system return when the system call is successful?
    # Looking that up, we find that
    # It returns true if the command gives a zero exit status (means the command was successful)
    # And it returns false if the command returns a different exit status and was therefore not successful
    # This spec will fail the first time, the method will return false
    # This allows us to examine the error message returned, it says 'sed: directory/**/*.rb: No such file or directory'
    # Looks like we need to pass it a valid directory
    before do
      # So let's create a directory
      # Yes, this will slow our tests down a bit, but let's
      # figure out what this method does and get our test harness working before trying to optimize
      # I promise we will come back to it!

      # First, let's make our directory
      # The spec still fails, looks like the code is looking for multiple directories with files in them.
      # Let's create another directory within the first one
      # Still no such file or directory.  Looks like it is looking for .rb files within the directories.  Let's create a few of those
      require 'fileutils'

      FileUtils.mkdir_p('directory/nested_dir')

      expect(File.directory?('directory/nested_dir')).to eq(true)

      file = File.new('something.rb', 'w')
      file.write('look there is something in the file')
      file.close
      expect(File).to exist('./something.rb')

      FileUtils.mv('something.rb','directory/nested_dir', verbose: true)
      expect(File).to exist('./directory/nested_dir/something.rb')
    end

    it 'returns successfully' do
      expect(RegexToRefactor.scary_regex_command('directory')).to eq(true)
    end

  end
end
