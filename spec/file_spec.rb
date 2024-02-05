require "immosquare-extensions"
require "spec_helper"

##============================================================##
## bundle exec rspec spec/file_spec.rb
##============================================================##
RSpec.describe(File) do
  describe ".normalize_last_line" do
    let(:temp_file_path) { "temp_test_file.txt" }

    ##============================================================##
    ## Before
    ##============================================================##
    before do
      File.write(temp_file_path, "Line 1\nLine 2\nLine 3\n")
    end

    ##============================================================##
    ## After
    ##============================================================##
    after do
      FileUtils.rm_f(temp_file_path)
    end

    it "appends a newline character if it is missing" do
      File.write(temp_file_path, "Line 1\nLine 2\nLine 3")
      expect { File.normalize_last_line(temp_file_path) }.to(change { File.size(temp_file_path) }.by(1))
    end

    it "does not change the file if it already ends with a newline" do
      expect { File.normalize_last_line(temp_file_path) }.not_to(change { File.read(temp_file_path) })
    end

    it "returns the total number of lines in the file" do
      total_lines = File.normalize_last_line(temp_file_path)
      expect(total_lines).to(eq(3))
    end

    it "removes extra newline characters at the end of the file" do
      File.write(temp_file_path, "Line 1\nLine 2\nLine 3\n\n\n")
      expect { File.normalize_last_line(temp_file_path) }.to(change { File.read(temp_file_path) }.to("Line 1\nLine 2\nLine 3\n"))
    end
  end
end
