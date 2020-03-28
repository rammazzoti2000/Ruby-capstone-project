# frozen_string_literal: true

require_relative '../lib/buffer.rb'
require_relative '../lib/checks.rb'
include Checks

describe Checks do
  let(:k_open) { '{' }
  let(:k_close) { '}' }

  describe '#check_indent_level' do
    it 'should throw an array with the expected levels of indentation for each line' do
      file_path = '../spec/test_files/indent_test.css'
      b = Buffer.new(file_path)
      expect(check_indent_level(b.content_s, k_open, k_close)).to eql([0, 1, 0])
    end
  end

  describe '#log_error' do
    it 'throws an error message based on the received parameters' do
      expect do
        log_error(1, 10, nil, nil, 2)
      end.to output("Error: line 10, Wrong Indentation, expected 2 spaces \n").to_stdout
    end
  end

  describe '#indent_cop' do
    it 'should throw an error message for line 1 because of incorrect indentation' do
      file_path = '../spec/test_files/indent_test.css'
      b = Buffer.new(file_path)
      expect do
        indent_cop(b.content_s, k_open, k_close)
      end.to output("Error: line 1, Wrong Indentation, expected 0 spaces \n").to_stdout
    end
  end

  describe '#spc_check_before' do
    it 'should throw an error for line 1 because of incorrect spacing' do
      file_path = '../spec/test_files/spacing_test.css'
      b = Buffer.new(file_path)
      expect do
        spc_check_before(1, b.content_s[0], '{')
      end.to output("Error: line 1, col: 5, Spacing, expected single space before {\n").to_stdout
    end
  end

  describe '#spc_check_after' do
    it 'should throw an error for line 3 because of incorrect spacing' do
      file_path = '../spec/test_files/spacing_test.css'
      b = Buffer.new(file_path)
      expect do
        spc_check_after(3, b.content_s[2], ':')
      end.to output("Error: line 3, col: 14, Spacing, expected single space after :\n").to_stdout
    end
  end

  describe '#check_ret_after' do
    it 'should throw an error on line 2 because of incorrect line format' do
      expect do
        file_path = '../spec/test_files/line_form_test.css'
        b = Buffer.new(file_path)
        check_ret_after(2, b.content_s[1], ';')
      end.to output("Error: line 2, col: 12, Line Format, Expected line break after ;\n").to_stdout
    end
  end

  describe '#check_ret_after' do
    it 'should throw an error on line 5 because of incorrect line format' do
      expect do
        file_path = '../spec/test_files/line_form_test.css'
        b = Buffer.new(file_path)
        check_lines_bet_blocks(b.content_s, '}')
      end.to output("Error: line 5, Line Format, Expected one empty line after }\n").to_stdout
    end
  end
end