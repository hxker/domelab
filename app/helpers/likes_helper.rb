module LikesHelper

  def likeable_tag(likeable)

    return '' if likeable.blank?

    return unlogin_likeable_tag if current_user.blank?

    label = "#{likeable.likes_count} 个赞"
    label = '' if likeable.likes_count == 0

    title, state, icon_name =
        if likeable.liked_by_user?(current_user)
          %w(取消赞 active icon-thumbs-down-alt)
        else
          ['赞', '', 'icon-thumbs-down-alt']
        end
    icon = content_tag('i', '', class: "#{icon_name}")
    like_label = raw "#{icon} <span>#{label}</span>"

    link_to(like_label, '#', title: title, 'data-count' => likeable.likes_count,
            'data-state' => state, 'data-type' => likeable.class, 'data-id' => likeable.id,
            class: "likeable #{state}")
  end

  private

  def unlogin_likeable_tag
    link_to(raw('<i class="fa fa-heart-o"></i> <span></span>'), sign_in_path, class: '')
  end
end
