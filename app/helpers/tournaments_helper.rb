module TournamentsHelper
  def to_css_class(status)
    s = {0 => "pending",
     1 => "active",
     2 => "inactive"}
    return s[status]
  end
end
