module OEmbedHelper
  def o_embed_html(cache)
    data = cache.data
    data = {} if data.blank?
    title = data.fetch('title', cache.url)
    html = link_to(title, cache.url, :target => '_blank') 
    return html unless data.has_key?('type')
    case data['type']
    when 'video', 'rich'
      if cache.is_trusted_and_has_html?
        html = data['html']
      elsif data.has_key?('thumbnail_url')
        html = link_to_oembed_image(cache)
      end
    when 'photo'
      if data.has_key?('url')
        img_options = cache.options_hash('')
        html = link_to_oembed_image(cache, '')
      end
    else
    end

    return html.html_safe
  end

  def link_to_oembed_image(cache, prefix = 'thumbnail_')
    link_to(oembed_image_tag(cache, prefix), cache.url, :target => '_blank')
  end
  
  def oembed_image_tag(cache, prefix)
    image_tag(cache.data[prefix + 'url'], cache.options_hash(prefix))
  end

  def oembed_width(cache)
    cache.data.fetch('width', 420)
  end

  def oembed_height(cache)
    cache.data.fetch('height', 260)
  end
end
