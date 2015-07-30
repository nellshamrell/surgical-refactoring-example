require_relative '../lib/regex_to_refactor'

describe RegexToRefactor do
  let(:regex_to_refactor) { RegexToRefactor.new }
  describe 'calling the method' do
  # Starting from the outer edges of the method and working our way in
    it 'can be called' do
      # Step 1: Figure out how to call the beast
      # 1.1 Write test first - should pass
      # 1.2 Alter code so test should fail, make sure it fails
      expect(regex_to_refactor).to respond_to(:scary_regex_command)
    end

    it 'receives an argument' do
      # Step 2: Let's figure out the argument it is expecting to receive
      # 2.2 Remember, if test passes the first time, then alter code to make sure it fails
      expect{regex_to_refactor.scary_regex_command()}.to raise_error(ArgumentError)
      expect{regex_to_refactor.scary_regex_command('directory', 'something_else')}.to raise_error(ArgumentError)
    end
  end

  describe 'making the system call' do
    it 'calls Ruby#system method' do
      expect_any_instance_of(RegexToRefactor).to receive(:system).with(anything())
      regex_to_refactor.scary_regex_command('directory')
    end

    it 'calls the sed command' do
      expect_any_instance_of(RegexToRefactor).to receive(:system).with(/sed.*/)
      regex_to_refactor.scary_regex_command('directory')
    end
  end

  describe 'what the method does' do
    before do
      create_required_directories_and_files
    end

    it 'returns successfully' do
      expect(regex_to_refactor.scary_regex_command('directory')).to eq(true)
    end

    after do
      clean_up_files('directory')
    end
  end

  describe 'what the regex matches' do
    let(:test_string) { ':ab ' }

    it 'matches a string' do
      expect(regex_to_refactor.first_regex_match(test_string)).to_not be_nil
    end

    it 'captures a group' do
      expect(regex_to_refactor.first_regex_match(test_string)[1]).to_not be_nil
      expect(regex_to_refactor.first_regex_match(test_string)[1]).to eq('ab')
    end
  end

  describe 'how the method changes files' do
    # At this point, we know it does SOMETHING to .rb files at directory/sub-directory. but we're still not sure exactly what
    # We know that "sed" is a streaming editor - it makes changes to a file or files
    # So, after this command is run, something about the content of those files should be changed.
    # Let's first set an expectation that the file should be changed to help us figure out precisely WHAT in the file should change

    before do
      create_required_directories_and_files

      expect(File.exist?('directory/nested_dir/something.rb')).to eq(true)
    end

    it 'changes the file' do
      file = File.open('directory/nested_dir/something.rb')
      file2 = file.clone

      expect(File.read(file)).to eq(File.read(file2))

      regex_to_refactor.scary_regex_command('directory')

      expect(File.read(file)).to_not eq(File.read(file2))
    end

    # Next, let's figure out what these regex matches are expected to be, which will tell us what the method expects to be in the file

    after do
      clean_up_files('directory')
    end
  end

  require 'fileutils'

  def create_required_directories_and_files
    FileUtils.mkdir_p('directory/nested_dir')

    file = File.new('something.rb', 'w')
    file.write('look there is something in the file')
    file.close

    FileUtils.mv('something.rb','directory/nested_dir', verbose: true)
  end

  def clean_up_files(directory)
    FileUtils.rm_rf(directory)
  end
end
