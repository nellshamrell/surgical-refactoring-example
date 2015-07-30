require_relative '../lib/regex_to_refactor'

describe RegexToRefactor do
  let(:regex_to_refactor) { RegexToRefactor.new }
  describe 'calling the method' do
    it 'can be called' do
      expect(regex_to_refactor).to respond_to(:scary_regex_command)
    end

    it 'receives an argument' do
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

  # We are deleting the "what the regex matches" specs
  # because they were just to help us figure out
  # what the regex was doing so we could add specs
  # for its behavior in the larger context of the "scary_regex_command" method
  # We now have those specs for that behavior, so we remove these specs

  describe 'how the method changes files' do
    let(:my_string) { ':ab =>' }
    let(:altered_string) { 'ab:'}

    before do
      create_required_directories_and_files

      expect(File.exist?('directory/nested_dir/something.rb')).to eq(true)

      file = File.open('directory/nested_dir/something.rb', 'w')
      file.write(my_string)
      file.close
    end

    it 'changes the file' do
      orig_contents = File.read('directory/nested_dir/something.rb')
      expect(orig_contents).to include(my_string)

      regex_to_refactor.scary_regex_command('directory')

      new_contents = File.read('directory/nested_dir/something.rb')
      expect(new_contents).to_not include(my_string)
      expect(new_contents).to include(altered_string)
    end

    it 'changes all matches within the file' do
      file = File.open('directory/nested_dir/something.rb', 'w')
      file.write("#{my_string} #{my_string}")
      file.close

      contents = File.read('directory/nested_dir/something.rb')
      expect(contents).to include(':ab => :ab =>')

      regex_to_refactor.scary_regex_command('directory')
      new_contents = File.read('directory/nested_dir/something.rb')

      expect(new_contents).to_not include(my_string)
      expect(new_contents).to include('ab: ab:')
    end

    it 'does not save a backup copy of the file' do
      expect(Dir['directory/nested_dir/*'].count).to eq(1)
      regex_to_refactor.scary_regex_command('directory')
      expect(Dir['directory/nested_dir/*'].count).to eq(1)
    end


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
