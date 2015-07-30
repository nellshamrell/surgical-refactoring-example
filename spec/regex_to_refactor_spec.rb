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
    before do
      create_required_directories_and_files
    end

    it 'returns successfully' do
      expect(RegexToRefactor.scary_regex_command('directory')).to eq(true)
    end

    after do
      FileUtils.rm_rf('directory')
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
end
