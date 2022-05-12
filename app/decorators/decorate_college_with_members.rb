class DecorateCollegeWithMembers
  def self.call(college, members)
    domains = college.college_domains.pluck(:domain)

    college.define_singleton_method('members') do
      members.select do |m|
        domains.include?(m.email.split('@').last)
      end
    end

    college
  end
end
