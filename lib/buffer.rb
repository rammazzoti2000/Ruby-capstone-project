# require StringScanner

class Buffer
  attr_reader :file_path, :content_string, :line_count
  attr_writer :file_path, :content_string, :line_count

  def initialize(file_path)
    @file_path = file_path
    @content_string = get_file_content(file_path)
    @line_ct = content_string.length
  end

  private

  # rubocop: disable Lint/UselessAssignment
  def get_file_content(file_path)
    content_string = ''
    File.open(file_path, 'r') { |f| content_string = f.readlines.map(&:strip) }
    content_scan = content_string.map { |elem| elem = StringScanner.new(elem) }
    content_scan
  end
  # rubocop: enable Lint/UselessAssignment
end
