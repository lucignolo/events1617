module SearchesHelper
  def exec_link_for(termine, ricerca)
    if termine.size == 1
      content_tag(:strong, "Termine troppo corto")
    else
      hint = content_tag(:span, "ricerca per: #{termine}!", class: 'scarcity')
      link_to "ESEGUI! #{hint}".html_safe, filtered_publishers_path(ricerca), class: 'button ok register'
    end
  end
end
