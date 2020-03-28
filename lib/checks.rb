require 'strscan'

module Checks
  def check_indent(content_string, case_start, case_end)
    space_indent = space_indent_check(content_string, case_start, case_end)
    content_string.each_with_index do |elem, idx|
      elem.reset
      idx.scan(/\s+/)
      string_pos = if elem.matched?
        elem.matched.length
      else
        0
      end
    end
  end

  def space_indent_check(content_string, case_start, case_end)
    arr = []
    line = 0
    content_string.each_with_index do |elem, idx|
      elem.reset
      arr << line
      if elem.exist?(Regexp.new(case_start))
        line += 1
      else
        next
      end
    end
    arr
  end

  def check_space(content_string)
    content_string.each_with_index do |elem, idx|
      space_before(idx + 1, elem, "{")
      space_before(idx + 1, elem, "(")
      space_after(idx + 1, elem, "}")
      space_after(idx + 1, elem, ")")
      space_after(idx + 1, elem, ":")
      space_after(idx + 1, elem, ",")
    end
  end

  def space_before(line, str, char)
    str.reset
    string = str.scan_until(Regexp.new(char))
    while str.matched?
      string = StringScanner.new(string.reverse)
      string.skip(Regexp.new(char))
      str.scan(/\s+/)
      string = str.scan_until(Regexp.new(char))
    end
  end

  def space_after(line, str, char)
    str.reset
    str.scan_until(Regexp.new(char))
    while str.matched?
      str.scan(/\s+/)
      str.scan_until(Regexp.new(char))
    end
  end

  def check_format(content_string)
    content_s.each_with_index do |elem, idx|
      check_after(idx + 1, elem, '{')
      check_after(idx + 1, elem, '}')
      check_after(idx + 1, elem, ';')
    end
  end

  def check_after(line, str, char)
    str.reset
    str.scan_until(Regexp.new(char))
    while str.matched?
      str.scan_until(Regexp.new(char))
    end
  end

  def block_line(content_string, char)
    found = false
    count = 0
    0.upto(content_string.length - 1) do |elem|
      content_string[elem].reset
      if found && content_string[elem] == ''
        counter += 1
      elsif content_string[elem].string != ''
        found = false
      else
        found = true
        count = 0
      end
    end
  end
end