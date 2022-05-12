module CollegeHelper
  def domain_display(college)
    college_domains = college.college_domains
    if college_domains.size > 1
      "#{college_domains.first.domain} + #{college_domains.size - 1} More"
    else
      college_domains.first&.domain
    end
  end
end
