module ApplicationHelper
  
  def nav_link_to(title, target_path)
    p title, target_path, (target_path.eql? request.path)
    
    css_klass = "active" if target_path.eql?(request.path)
    content_tag :li, class: css_klass do
      link_to title, target_path
    end
  end
  
end