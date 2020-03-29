class Buffer
  attr_reader :file_path, :content_s

  def initialize(file_path)
    @file_path = file_path
    @content_s = get_file_content(@file_path)
  end

  # rubocop: disable Lint/UselessAssignment
  def get_file_content(file_path)
    content_s = ''
    File.open(file_path, 'r') { |f| content_s = f.readlines.map(&:chomp) }
    content_scan = content_s.map { |v| v = StringScanner.new(v) }
    content_scan
  end
  # rubocop: enable Lint/UselessAssignment
end
