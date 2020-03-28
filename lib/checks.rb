require 'colorize'
require 'strscan'

# rubocop: disable Metrics/ModuleLength
module Checks
  def indent_cop(content_s, k_open, k_close)
    lev = check_indent_level(content_s, k_open, k_close)
    content_s.each_with_index do |s, i|
      s.reset
      s.scan(/\s+/)
      sp = if s.matched?
             s.matched.length
           else
             0
           end
      log_error(1, i + 1, nil, nil, lev[i] * 2) unless sp == lev[i] * 2
    end
  end

  def spacing_cop(content_s)
    content_s.each_with_index do |s, i|
      spc_check_before(i + 1, s, '{')
      spc_check_before(i + 1, s, '\(')
      spc_check_after(i + 1, s, '\)')
      spc_check_after(i + 1, s, ',')
      spc_check_after(i + 1, s, ':')
    end
  end

  def line_format_cop(content_s)
    content_s.each_with_index do |s, i|
      check_ret_after(i + 1, s, '{')
      check_ret_after(i + 1, s, '}')
      check_ret_after(i + 1, s, ';')
    end
    check_lines_bet_blocks(content_s, '}')
  end

  def check_indent_level(content_s, k_open, k_close)
    levels = []
    level = 0
    content_s.each_with_index do |s, i|
      s.reset
      levels << level
      level += 1 if s.exist?(Regexp.new(k_open))
      next unless s.exist?(Regexp.new(k_close))

      level -= 1
      levels[i] = level
    end
    levels
  end

  def spc_check_before(line, str, char)
    str.reset
    s = str.scan_until(Regexp.new(char))
    while str.matched?
      s = StringScanner.new(s.reverse)
      s.skip(Regexp.new(char))
      s.scan(/\s+/)
      log_error(3, line, char, s.string.length - s.pos) if s.matched != ' '
      s = str.scan_until(Regexp.new(char))
    end
  end

  def spc_check_after(line, str, char)
    str.reset
    str.scan_until(Regexp.new(char))
    while str.matched?
      str.scan(/\s+/)
      log_error(2, line, char, str.pos) if str.matched != ' '
      str.scan_until(Regexp.new(char))
    end
  end

  def check_ret_after(line, str, char)
    str.reset
    str.scan_until(Regexp.new(char))
    while str.matched?
      log_error(4, line, char, str.pos) unless str.eos?
      str.scan_until(Regexp.new(char))
    end
  end

  # rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def check_lines_bet_blocks(content_s, char)
    found = false
    counter = 0
    0.upto(content_s.length - 1) do |i|
      content_s[i].reset
      if found && content_s[i].string == ''
        counter += 1
        log_error(5, i + 1, char) if counter > 1
      elsif found && content_s[i].string != ''
        log_error(5, i + 1, char) if counter.zero? && !content_s[i].exist?(/}/)
        found = false
      else
        found = false
      end
      if content_s[i].exist?(/}/)
        found = true
        counter = 0
      end
    end
  end

  def log_error(type, line, char = nil, pos = nil, lev = nil)
    err_string = "Error: line #{line}".red
    err_string += ',' + " col: #{pos}".green unless pos.nil?
    case type
    when 1
      puts err_string + ',' + ' Wrong Indentation'.green + ' --> ' + " expected #{lev} spaces "
    when 2
      puts err_string + ',' + ' Spacing'.green + ' --> ' + ' expected single space after '.yellow + char
    when 3
      puts err_string + ',' + ' Spacing'.green + ' --> ' + 'expected single space before '.yellow + char
    when 4
      puts err_string + ',' + ' Line Format'.green + ' --> ' + 'Expected line break after '.yellow + char
    when 5
      puts err_string + ',' + ' Line Format'.green + ' --> ' + 'Expected one empty line after '.yellow + char
    else
      puts "#{err_string}, Other"
    end
    type
  end
end
# rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/ModuleLength
