module LikesHelper

  def likeable_tag(likeable,type=nil)

    return '' if likeable.blank?

    return unlogin_likeable_tag if current_user.blank?

    label = likeable.likes_count
    title, state, icon_name =
        if likeable.liked_by_user?(current_user)
          %w(取消赞 active heart)
        else
          ['赞', '', 'heart-empty']
        end
    icon = content_tag('i', '', class: "like-change icon-#{icon_name}")
    like_label = raw "#{icon} <span>#{label}</span>"
    if type=="button"
      style = "btn likeable #{state}"
    else
      style = "likeable #{state}"
    end
    link_to(like_label, '#', title: title, 'data-count' => likeable.likes_count,
            'data-state' => state, 'data-type' => likeable.class, 'data-id' => likeable.id,
            class: style)
  end

  private

  def unlogin_likeable_tag
    link_to(raw('<i class="icon-heart-empty"></i> <span></span>'), sign_in_path, class: '')
  end
end
