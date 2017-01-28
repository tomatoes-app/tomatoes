module TagsHelper
  def link_tags(tags)
    safe_join(tags_links(tags), ', ')
  end

  private

  def tags_links(tags)
    tags.map { |tag| link_to h(tag), tag_path(u(tag)) }
  end
end
