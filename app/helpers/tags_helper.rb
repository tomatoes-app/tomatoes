module TagsHelper
  def link_tags(tags)
    raw tags.map { |tag| link_to h(tag), tag_path(h(tag)) }.join(', ')
  end
end
