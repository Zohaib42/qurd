module ApplicationHelper
  def optional_string(string)
    string.presence || 'N/A'
  end
end
