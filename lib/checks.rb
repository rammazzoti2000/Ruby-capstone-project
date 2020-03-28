require 'strscan'
require 'colorize'

# rubocop: disable Metrics/ModuleLength
module Checks
  def check_indent(content_string, case_start, case_end)
    lev = space_indent_check(content_string, case_start, case_end)
    content_string.each_with_index do |elem, idx|
      elem.reset
      elem.scan(/\s+/)
      string_pos = if elem.matched?
                     elem.matched.length
                   else
                     0
                   end
      error_message(1, idx + 1, nil, nil, lev[idx] * 2) unless string_pos == lev[idx] * 2
    end
  end

  def space_indent_check(content_string, case_start, case_end)
    levels = []
    level = 0
    content_string.each_with_index do |s, i|
      s.reset
      levels << level
      level += 1 if s.exist?(Regexp.new(case_start))
      next unless s.exist?(Regexp.new(case_end))

      level -= 1
      levels[i] = level
    end
    levels
  end

  def check_space(content_string)
    content_string.each_with_index do |elem, idx|
      space_before(idx + 1, elem, '{')
      space_before(idx + 1, elem, '\(')
      space_after(idx + 1, elem, '\)')
      space_after(idx + 1, elem, ',')
      space_after(idx + 1, elem, ':')
    end
  end

  def space_before(line, str, char)
    str.reset
    s = str.scan_until(Regexp.new(char))
    while str.matched?
      s = StringScanner.new(s.reverse)
      s.skip(Regexp.new(char))
      s.scan(/\s+/)
      error_message(3, line, char, s.string.length - s.pos) if s.matched != ' '
      s = str.scan_until(Regexp.new(char))
    end
  end

  def space_after(line, str, char)
    str.reset
    str.scan_until(Regexp.new(char))
    while str.matched?
      str.scan(/\s+/)
      error_message(2, line, char, str.pos) if str.matched != ' '
      str.scan_until(Regexp.new(char))
    end
  end

  def check_format(content_string)
    content_string.each_with_index do |elem, idx|
      check_after(idx + 1, elem, '{')
      check_after(idx + 1, elem, '}')
      check_after(idx + 1, elem, ';')
    end
    block_line(content_string, '}')
  end

  def check_after(line, str, char)
    str.reset
    str.scan_until(Regexp.new(char))
    while str.matched?
      error_message(4, line, char, str.pos) unless str.eos?
      str.scan_until(Regexp.new(char))
    end
  end

  # rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def block_line(content_string, char)
    found = false
    count = 0
    0.upto(content_string.length - 1) do |elem|
      content_string[elem].reset
      if found && content_string[elem].string == ''
        count += 1
        error_message(5, elem + 1, char) if count > 1
      elsif found && content_string[elem].string != ''
        error_message(5, elem + 1, char) if count.zero? && !content_string[elem].exist?(/}/)
        found = false
      else
        found = false
      end
      if content_string[elem].exist?(/}/)
        found = true
        count = 0
      end
    end
  end

  def error_message(type, line, char = nil, position = nil, lev = nil)
    string_error = "Error: line #{line}".red
    string_error += "," + " col: #{position}".green unless position.nil?
    case type
    when 1
      puts string_error + "," + " Wrong Indentation".green + " --> " + " expected #{lev} spaces "
    when 2
      puts string_error + "," + " Spacing".green + " --> " + " expected single space after ".yellow + char
    when 3
      puts string_error + "," + " Spacing".green + " --> " + "expected single space before ".yellow + char
    when 4
      puts string_error + "," + " Line Format".green + " --> " + "Expected line break after ".yellow + char
    when 5
      puts string_error + "," + " Line Format".green + " --> " + "Expected one empty line after ".yellow + char
    else
      puts "#{string_error}, Other"
    end
    type
  end
end
# rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/ModuleLength
